#!/usr/bin/env bash
set -e

APP=spring-boot-app

docker kill $(docker ps -qf "name=crac-demo") 2>/dev/null || true

case $(uname -m) in
    arm64)   CRAC_TARGET=aarch64 ;;
    *)       CRAC_TARGET=x64 ;;
esac
CRAC_URL=https://cdn.azul.com/zulu/bin/zulu17.42.21-ca-crac-jdk17.0.7-linux_${CRAC_TARGET}.tar.gz

CRAC_TAR=cracjdk.tar.gz
if [ -f ${CRAC_TAR} ]; then
  echo "Using local $CRAC_TAR"
else
  echo "Using CRaC enabled JDK $CRAC_URL"
  wget -O ${CRAC_TAR} ${CRAC_URL}
fi
if [ -z $JAVA_HOME ]; then
  echo "JAVA_HOME is not set. Using Crac JDK from $CRAC_TAR"
  export JAVA_HOME=$PWD/cracjdk
  rm -rf cracjdk
  mkdir cracjdk
  tar xf cracjdk.tar.gz --directory "$JAVA_HOME" --strip-components 1
fi

(cd $APP && mvn clean package)

FUNCTION_JAR=`find $APP/target -name '*.jar'`

docker build -t crac-demo:$APP-builder --build-arg FUNCTION_JAR=$FUNCTION_JAR .
docker run -d --privileged --rm --name=crac-demo -p 8080:8080 crac-demo:$APP-builder

echo "Waiting for service is up..."
sleep 5
echo "Warming up the app..."
rm -f index.html && wget -o wget.log --tries=2 http://localhost:8080
rm -f index.html && wget -o wget.log --tries=2 http://localhost:8080
rm -f index.html && wget -o wget.log --tries=2 http://localhost:8080

echo ======
cat index.html
echo
echo ======

rm -f runtime.tar.gz
echo Requesting for checkpoint...
wget -o /dev/null --tries=1 http://localhost:8080/checkpoint || true

echo "Waiting for checkpoint completed..."
sleep 10

echo Checking checkpoint is completed successfully...
docker exec -it crac-demo ls /app/app-image/cppath

echo Creating lambda package for restore...
rm -rf runtime.tar.gz
docker exec -it crac-demo tar czf runtime.tar.gz /app bootstrap
docker cp crac-demo:/runtime.tar.gz runtime-$APP.tar.gz

echo Creating docker image for restore...
docker exec -it crac-demo rm runtime.tar.gz entrypoint.sh
docker commit --change='ENTRYPOINT ["bash", "/bootstrap"]' $(docker ps -qf "name=crac-demo") crac-demo:$APP-checkpoint

echo Killing builder container...
docker kill $(docker ps -qf "name=crac-demo")

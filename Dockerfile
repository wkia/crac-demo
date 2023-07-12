FROM ubuntu:22.04

ARG FUNCTION_JAR

ENV APP_DIR /app
ENV JAVA_HOME $APP_DIR/jdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV CRAC_FILES_DIR $APP_DIR/app-image

COPY cracjdk.tar.gz $JAVA_HOME/cracjdk.tar.gz

RUN tar xf $JAVA_HOME/cracjdk.tar.gz --directory "$JAVA_HOME" --strip-components 1; rm $JAVA_HOME/cracjdk.tar.gz;
COPY $FUNCTION_JAR $APP_DIR/app.jar
COPY entrypoint.sh /entrypoint.sh
COPY bootstrap /bootstrap
ENTRYPOINT /entrypoint.sh

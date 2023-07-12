#!/bin/bash
echo 128 > /proc/sys/kernel/ns_last_pid
java -XX:CRaCCheckpointTo=$CRAC_FILES_DIR -jar $APP_DIR/app.jar
sleep infinity

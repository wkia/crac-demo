#!/usr/bin/env bash
set -ex

APP=$1
APP_IMAGE=crac-demo:$APP-checkpoint
docker run --rm -p 8080:8080 --name crac-demo $APP_IMAGE

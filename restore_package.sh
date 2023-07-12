#!/usr/bin/env bash
set -e

PACKAGE=$1
docker run --rm -p 8080:8080 -v $PWD:/local --name crac-demo ubuntu:22.04 bash -c "tar xzf /local/$PACKAGE && bash ./bootstrap"

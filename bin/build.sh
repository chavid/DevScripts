#!/bin/bash

#target=${1}
#shift
#flavor=${1}
#shift

cd ${DEV_SCRIPTS_DOCKER_DIR}

rm -rf mydevtools
cp -r ../bin mydevtools

docker build -f Dockerfile -t `cat Dockertag` .
#docker build --force-rm --no-cache -f Dockerfile -t `cat Dockertag` .

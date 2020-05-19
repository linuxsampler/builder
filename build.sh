#!/bin/bash

if [[ "$LINUXSAMPLER_VERSION" == "" || "$UBUNTU_VERSION" == "" ]]
then
    echo "Error: Don't run this script directly!"
    echo "Use versioned script instead (e.g. \"./build-2.1.1-ubuntu-18.04.sh\")"
    exit 1
fi

set -e

DOCKER_IMAGE=linuxsampler-$LINUXSAMPLER_VERSION-ubuntu-$UBUNTU_VERSION

sudo docker rm -f $DOCKER_IMAGE || true
sudo docker build --build-arg LINUXSAMPLER_VERSION="$LINUXSAMPLER_VERSION" --build-arg UBUNTU="ubuntu:$UBUNTU_VERSION" . -t linuxsampler-$LINUXSAMPLER_VERSION-ubuntu-$UBUNTU_VERSION

sudo docker run -it -d --name $DOCKER_IMAGE $DOCKER_IMAGE /bin/bash
sudo docker exec -it $DOCKER_IMAGE make -j8
sudo docker exec -it $DOCKER_IMAGE make install
sudo docker exec -it $DOCKER_IMAGE tar -czvf linuxsampler-$LINUXSAMPLER_VERSION.tar.gz linuxsampler-$LINUXSAMPLER_VERSION
sudo docker cp $DOCKER_IMAGE:/root/linuxsampler-$LINUXSAMPLER_VERSION/linuxsampler-$LINUXSAMPLER_VERSION.tar.gz ./
sudo chown $USER linuxsampler-$LINUXSAMPLER_VERSION.tar.gz

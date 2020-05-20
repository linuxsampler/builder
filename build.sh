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
sudo docker exec -it $DOCKER_IMAGE checkinstall -D -y --nodoc --backup=no --pkglicense="GPL2" --maintainer="S. Yakupov \\<s.yakupov@noviga.com\\>" --requires="libasound2,libgig9,libjack0,libsndfile1,libsqlite3-0" --install=no
sudo docker cp $DOCKER_IMAGE:/root/linuxsampler-$LINUXSAMPLER_VERSION/linuxsampler_$LINUXSAMPLER_VERSION-1_amd64.deb ./
sudo chown $USER linuxsampler_$LINUXSAMPLER_VERSION-1_amd64.deb

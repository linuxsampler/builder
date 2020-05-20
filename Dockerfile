ARG UBUNTU="ubuntu-latest"
FROM $UBUNTU

ARG LINUXSAMPLER_VERSION="2.1.1"
ENV LSVER=$LINUXSAMPLER_VERSION

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update && apt-get install -y \ 
    alsa-base \
    autoconf \
    bison \
    build-essential \
    checkinstall \
    dssi-dev \
    file \
    libasio-dev \
    libasound2-dev \
    libgig-dev \
    libjack-dev \
    libsndfile-dev \
    libsqlite3-dev \
    lv2-dev \
    wget

WORKDIR /root/
RUN wget -nv https://download.linuxsampler.org/packages/linuxsampler-$LSVER.tar.bz2
RUN tar -xvf linuxsampler-$LSVER.tar.bz2
WORKDIR /root/linuxsampler-$LSVER
RUN mkdir linuxsampler-$LSVER
RUN ./configure

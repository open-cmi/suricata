FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="$PATH:/root/.cargo/bin"

#  run command
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
apt-get update

RUN apt-get install -y tzdata pkg-config &&\
apt-get install -y build-essential make net-tools libtool vim rsync gdb iputils-ping zlib1g && \
apt-get install -y libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev libcap-ng-dev libcap-ng0 libjansson-dev zlib1g-dev libpcre2-dev && \
apt-get install -y libssl-dev libreadline-dev libmagic-dev libgeoip-dev liblua5.1-dev libhiredis-dev libevent-dev && \
apt-get install -y python-yaml rustc cargo libpcre2-dev &&\
apt-get install -y rustc cargo

RUN apt-get clean && \
apt-get autoclean && \
apt-get autoremove

COPY . ./root/
COPY ./config ./root/.cargo/

RUN cargo install --force --debug --version 0.24.3 cbindgen

USER root

RUN cd /root/ && ./autogen.sh && ./configure --enable-unittests && make

#VOLUME  ["/usr/local/etc"]

WORKDIR /root/

#!/bin/sh

apt update && \
  apt -y upgrade \
  apt -y install sudo \

apt-get -y install git \
  automake \
  bison \
  build-essential \
  pkg-config \
  libevent-dev \
  libncurses5-dev

cd /usr/local/src/
git clone https://github.com/tmux/tmux

cd ./tmux/
./autogen.sh
./configure --prefix=/usr/local
make

make install
which tmux  
tmux -V

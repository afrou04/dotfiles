#!/bin/sh

# set -ex

# install tmux
tmux -V > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "tmuxをインストールします"
  sudo brew install tmux
else 
  echo "tmuxはインストール済みです"
fi

# install git
git --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "gitをインストールします"
  sudo brew install git
else 
  echo "gitはインストール済みです"
fi

# install hub
hub --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "hubをインストールします"
  sudo brew install hub
else 
  echo "hubはインストール済みです"
fi

# install fzf
fzf --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "fzfをインストールします"
  sudo brew install fzf
else 
  echo "fzfはインストール済みです"
fi

# install tig
tig -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "tigをインストールします"
  sudo brew install tig
else 
  echo "tigはインストール済みです"
fi

node -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "nodeをインストールします"
  sudo brew install -y nodejs npm && \
    sudo npm install n -g && \
    sudo n stable && \
    sudo brew purge -y nodejs npm && \
    sudo brew purge -y nodejs npm 
else 
  echo "nodeはインストール済みです"
fi

# install dein
DEIN_DIR="$HOME/.cache/dein"
if [ -d $DEIN_DIR ]; then
  echo "deinはインストール済みです"
else 
  echo "deinをインストールします"
  sh ./.dein.sh $HOME/.cache/dein
fi

# install docker
docker -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "dockerをインストールします"
  sudo brew install docker.io
  sudo brew install podman-docker
else 
  echo "dockerはインストール済みです"
fi

# install mosh
mosh -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "moshをインストールします"
  sudo brew install mosh
else 
  echo "moshはインストール済みです"
fi

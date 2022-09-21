#!/bin/bash
set -e

node -v &> /dev/null

if [ $? -ne 0 ]; then
  echo "nodeをインストールします"
  sudo apt install -y nodejs npm && \
    sudo npm install n -g && \
    sudo n stable && \
    sudo apt purge -y nodejs npm && \
    sudo apt purge -y nodejs npm 
else 
  echo "nodeはインストール済みです"
  node -v
fi

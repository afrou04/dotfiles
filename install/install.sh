#!/bin/sh

set -e

# install tmux
tmux -V &> /dev/null
if [ $? -ne 0 ]; then
  echo "tmuxをインストールします"
else 
  echo "tmuxはインストール済みです"
fi

# install git
git --version &> /dev/null
if [ $? -ne 0 ]; then
  echo "gitをインストールします"
else 
  echo "gitはインストール済みです"
fi

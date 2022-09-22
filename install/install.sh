#!/bin/sh

# set -x

# install tmux
tmux -V > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "tmuxをインストールします"
  sudo apt install tmux
else 
  echo "tmuxはインストール済みです"
fi

# install git
git --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "gitをインストールします"
  sudo apt install git
else 
  echo "gitはインストール済みです"
fi

# install hub
hub --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "hubをインストールします"
  sudo apt install hub
else 
  echo "hubはインストール済みです"
fi

# install fzf
fzf --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "fzfをインストールします"
  sudo apt install fzf
else 
  echo "fzfはインストール済みです"
fi

# install brew
brew -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "brewをインストールします"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else 
  echo "brewはインストール済みです"
fi

# install dein
DEIN_DIR="$HOME/.cache/dein"
if [ -d $DEIN_DIR ]; then
  echo "deinはインストール済みです"
else 
  echo "deinをインストールします"
  sh ./dein.sh $HOME/.cache/dein
fi


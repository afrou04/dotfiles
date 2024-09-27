#!/bin/sh

# set -ex

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
  brew install ripgrep
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

# install golang
go version -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "golangをインストールします"
  brew install go
  brew install goenv
else 
  echo "golangはインストール済みです"
fi

# install fnm
fnm --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "fnmをインストールします"
  brew install fnm
  fnm install v18.17.0
  fnm use v18.17.0
  fnm install v14.15.4
else
  echo "fnmはインストール済みです"
fi

delta -V > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "git-deltaをインストールします"
  brew install git-delta
else 
  echo "git-deltaはインストール済みです"
fi

# install dein
DEIN_DIR="$HOME/.cache/dein"
if [ -d $DEIN_DIR ]; then
  echo "deinはインストール済みです"
else 
  echo "deinをインストールします"
  sh ./.dein.sh $HOME/.cache/dein
fi

# install yq
yq -V > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "yqをインストールします"
  curl -LJO https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
  sudo mv yq_linux_amd64 /usr/local/bin/yq
  sudo chmod a+x /usr/local/bin/yq
else
  echo "yqはインストール済みです"
fi

# install gh cli
gh version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "ghをインストールします"
  brew install gh
else
  echo "ghはインストール済みです"
fi

# install xsel
xsel --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "xselをインストールします"
  sudo apt-get install xsel
else
  echo "xselはインストール済みです"
fi


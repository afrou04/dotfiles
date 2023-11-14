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
else 
  echo "fzfはインストール済みです"
fi

# install tig
tig -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "tigをインストールします"
  sudo apt install tig
else 
  echo "tigはインストール済みです"
fi

# install brew
brew -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "brewをインストールします"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else 
  echo "brewはインストール済みです"
fi

node -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "nodeをインストールします"
  sudo apt install -y nodejs npm && \
    sudo npm install n -g && \
    sudo n stable && \
    sudo apt purge -y nodejs npm && \
    sudo apt purge -y nodejs npm 
else 
  echo "nodeはインストール済みです"
fi

delta -V > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "git-deltaをインストールします"
  brew install git-delta
else 
  echo "git-deltaはインストール済みです"
fi

lazygit -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "lazygitをインストールします"
  brew install lazygit
else 
  echo "lazygitはインストール済みです"
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
  sudo apt install docker.io
  sudo apt install podman-docker
else
  echo "dockerはインストール済みです"
fi

# install mosh
mosh -v > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "moshをインストールします"
  sudo apt-get install mosh
else
  echo "moshはインストール済みです"
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

# install brew
brew --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "brewをインストールします"
  brew install fnm
  fnm install v18.17.0
  fnm use v18.17.0
  fnm install v14.15.4
else
  echo "brewはインストール済みです"
fi

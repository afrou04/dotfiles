#!/bin/sh

apt update
apt -y upgrade
apt -y install sudo

sudo apt-get -y update && \
  apt-get -y install git

cd `dirname $0`

# install neovim
bash ./neovim.sh
bash ./node.sh
npm install -g neovim
bash ./dein.sh ~/.cache/dein

# install tmux
bash ./tmux.sh

source "$HOME/.bash_profile"

# symbolic link
bash ../link.sh

# load tmux setting
tmux source "$HOME/.tmux.conf"


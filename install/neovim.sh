#!/bin/bash

apt-get update -y && \
  apt-get install -y software-properties-common && \
  apt-add-repository -y ppa:neovim-ppa/stable && \
  apt-get update -y && \
  apt-get install -y \
  curl \
  git \
  language-pack-ja-base \
  language-pack-ja \
  neovim \
  python-dev \
  python3-dev \
  python3-pip

pip3 install --upgrade neovim && \
  pip install pynvim

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bash_profile
source ~/.bash_profile
source ~/.bashrc

pyenv -v
pyenv global 3.6.3

git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
source ~/.bash_profile

# pyenvに必要なライブラリをinstall
apt-get install -y \
  gcc \
  make \
  openssl \
  libssl-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libffi-dev \
  zlib1g-dev

# neovim用にpython2系をinstall
pyenv install 2.7.15
pyenv virtualenv 2.7.15 neovim2
pyenv local neovim2
pip2 install neovim
# neovim用にpython3系をinstall
pyenv install 3.6.3
pyenv virtualenv 3.6.3 neovim3
pyenv local neovim3
pip install pynvim

pyenv local --unset


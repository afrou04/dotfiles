from ubuntu:18.04

shell ["/bin/bash", "-c"]

run apt-get update -y && \
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

env lang="ja_jp.utf-8" language="ja_jp:ja" lc_all="ja_jp.utf-8"

run pip3 install --upgrade neovim


#!/bin/bash

cd `dirname $0`

IGNORE_PATTERN="^\.(git)(?!.*h).*$"

for dotfile in .??*; do
    if [[ $dotfile =~ $IGNORE_PATTERN ]]; then
        continue
    fi
    ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done

mkdir -p "$HOME/.config"
ln -snfv "$(pwd)/config/nvim" "$HOME/.config/nvim"
ln -snfv "$(pwd)/config/git/.gitconfig" "$HOME/.gitconfig"
ln -snfv "$(pwd)/config/zplugs" "$HOME/.zsh"


commands="./command/*"
for commandFilePath in $commands; do
  filename=$(basename ${commandFilePath})
  sudo ln -snfv "$(pwd)/command/$filename" "/usr/local/bin"
done


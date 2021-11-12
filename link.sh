#!/bin/sh

cd `dirname $0`

IGNORE_PATTERN="^\.(git)"

for dotfile in .??*; do
    [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
    ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done

mkdir -p "$HOME/.config"
ln -snfv "$(pwd)/config/nvim" "$HOME/.config/nvim"


commands="./command/*"
for commandFilePath in $commands; do
  filename=$(basename ${commandFilePath})
  ln -snfv "$(pwd)/command/$filename" "/usr/local/bin"
done


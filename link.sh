#!/bin/sh

cd `dirname $0`

IGNORE_PATTERN="^\.(git)(?!.*h).*$"

for dotfile in .??*; do
    [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
    ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done

mkdir -p "$HOME/.config"
ln -snfv "$(pwd)/config/nvim" "$HOME/.config/nvim"
ln -snfv "$(pwd)/config/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"


commands="./command/*"
for commandFilePath in $commands; do
  filename=$(basename ${commandFilePath})
  sudo ln -snfv "$(pwd)/command/$filename" "/usr/local/bin"
done


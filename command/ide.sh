#!/bin/bash
set -eu

# set tmux panes for ide

tmux split-window -v
tmux resize-pane -D 18
tmux split-window -h

# open dotifiles
# tmux new-window -c "$HOME/dotfiles" nvim .zshrc

# move ide window
# tmux select-window -p 
# nvim


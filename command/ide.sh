#!/bin/bash
set -eux

# set tmux panes for ide

tmux split-window -v
tmux resize-pane -D 15
tmux split-window -h

# open dotifiles
# tmux new-window -c "$HOME/dotfiles" nvim .zshrc

# move ide window
# tmux select-window -p 
# nvim


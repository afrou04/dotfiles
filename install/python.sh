#!/bin/sh

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


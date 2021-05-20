export LANG=ja_JP.UTF-8

export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

export GOPATH=${HOME}/go
export PATH="${GOPATH}/bin:${PATH}"

export BAT_THEME="base16"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"


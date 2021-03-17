export PATH=$PATH:/Users/bunta/Library/Android/sdk/platform-tools
export LANG=ja_JP.UTF-8

export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/.pyenv/shims:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/bzip2/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/bzip2/include"

[ -f ~/.bash_powerline ] && . ~/.bash_powerline

export GOPATH=${HOME}/go
export PATH="${GOPATH}/bin:${PATH}"

export CLOUD_SQL_PROXY_PATH=${HOME}/cloud_sql_proxy
export PATH="${CLOUD_SQL_PROXY_PATH}/bin:${PATH}"

export BAT_THEME="ansi"


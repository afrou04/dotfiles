. "$HOME/.cargo/env"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/Users/afro/go/bin"

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR="nvim"

# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# vimでclipboardにcopyできるようにする
# https://qiita.com/cawpea/items/3ca4ab80fc465d8eed7e
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export MANPATH=/opt/local/man:$MANPATH

eval "`npm completion`"
eval "$(hub alias -s)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/afrou/google/path.zsh.inc' ]; then . '/home/afrou/google/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/afrou/google/completion.zsh.inc' ]; then . '/home/afrou/google/completion.zsh.inc'; fi

# source "$HOME/google-cloud-sdk/completion.bash.inc"
# source "$HOME/google-cloud-sdk/path.bash.inc"


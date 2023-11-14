export PATH=$HOME/bin:/usr/local/bin:$PATH

. "$HOME/.cargo/env"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/Users/afro/go/bin"

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# FXIME: 読み込みで落ちる
# if [ -f "$HOME/fnm/completion.zsh" ]; then . "$HOME/fnm/completion.zsh"; fi
eval "$(fnm env --use-on-cd)"

export EDITOR="nvim"

export ZPLUG_HOME="$HOME/.zplug"

# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# eval "`npm completion`"
eval "$(hub alias -s)"
eval "$(zoxide init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google/path.zsh.inc" ]; then . "$HOME/google/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google/completion.zsh.inc" ]; then . "$HOME/google/completion.zsh.inc"; fi


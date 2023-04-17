. "$HOME/.cargo/env"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/Users/afro/go/bin"

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# alias air='$(go env GOPATH)/bin/air'
# alias sqlboiler='$(go env GOPATH)/bin/sqlboiler'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export EDITOR="nvim"

# source "$HOME/google-cloud-sdk/completion.bash.inc"
# source "$HOME/google-cloud-sdk/path.bash.inc"


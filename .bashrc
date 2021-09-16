#gitの設定
alias gs='git status'
alias ga="git add"
alias gc="git commit -m"
alias gps="git push origin HEAD"
alias gpsf="git push --force-with-lease origin"
alias gpl="git pull origin"
alias gplm="git pull origin master"
alias gpsm="git push origin master"
alias gck="git checkout"
alias gb="git branch"
alias gdl="git push --delete"
alias gd="git diff"
alias gdd="git difftool"
alias gl="git log --graph --oneline --decorate=full --color | emojify | less -r"
alias ggraph="git log --graph"
alias gst="git stash"

alias open="nvim"

#  ------------------------------
# base64
# ------------------------------
alias encode='function __encode(){ echo -n "$1" | base64 }; __encode'
alias decode='function __decode(){ echo -n "$1" | base64 -d }; __decode'

# ngrok
# ex) ngrok http 3000
alias ngrok='~/../../Applications/ngrok'

alias ls="exa -lh"
alias ..="cd .."
alias reload="source ~/.bash_profile"

alias cat="bat"

# docker設定
alias dc="docker compose"
alias dui="lazydocker"

alias kusa='curl https://github-contributions-api.deno.dev/$(git config user.name).term'

# Add in ~/.bashrc or ~/.bash_profile
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

BRANCH_COLOR="\[\033[00;32m\]"
USER_COLOR="\[\033[00;94m\]"
DIR_COLOR="\[\033[00;33m\]"
NO_COLOR="\[\033[00m\]"

# gitで補完できるようにする
if [ "$(uname)" == 'Darwin' ]; then
  source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
  source /usr/local/etc/bash_completion.d/git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=true
  export PS1='\[\e[94m\u@\h\] \[\e[33m\W\]\[\e[32m\]$(__git_ps1 "(%s)")\[\033[00m\]\n$ '
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  PS1="$USER_COLOR\u@\h $DIR_COLOR\W$BRANCH_COLOR\$(parse_git_branch)$NO_COLOR\n\$ "
fi

# vimでclipboardにcopyできるようにする
# https://qiita.com/cawpea/items/3ca4ab80fc465d8eed7e
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export MANPATH=/opt/local/man:$MANPATH

# fzf setting {{{
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

function cd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias pip="python -m pip"


function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend

eval "`npm completion`"
eval "$(hub alias -s)"

# tmux is not running
# if [[ ! -n $TMUX ]]; then
#   uim-fep
# fi

function fck() {
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  # aaa=$(echo $branch)
  # echo "$branch"
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

#git config
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

alias ls="ls"
alias ll="ls -al"
alias ..="cd .."
alias reload="source ~/.zshrc"

# docker設定
alias dc="docker compose"
alias dui="lazydocker"

alias kusa='curl https://github-contributions-api.deno.dev/$(git config user.name).term'

# Add in ~/.zshrc or ~/.zsh_profile
function parse_git_branch () {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/@\1/'
}

BRANCH_COLOR="\[\033[38;05;244m\]"
USER_COLOR="\[\033[00;94m\]"
DIR_COLOR="\[\033[38;05;244m\]"
NO_COLOR="\[\033[00m\]"

# git-promptの読み込み
source ~/.zsh/git-prompt.sh

# git-completionの読み込み
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
# autoload -Uz compinit && compinit
#
# GIT_PS1_SHOWDIRTYSTATE=true
# GIT_PS1_SHOWUNTRACKEDFILES=true
# GIT_PS1_SHOWSTASHSTATE=true
# GIT_PS1_SHOWUPSTREAM=auto
#
# setopt PROMPT_SUBST ; PS1='%n@$(__git_ps1 "%s")\$ '
# export PS1="$USER_COLOR\u@\h $DIR_COLOR\W$BRANCH_COLOR\$(parse_git_branch)$NO_COLOR\n\$ "

# prompt style
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}"
zstyle ':vcs_info:git:*' unstagedstr "%F{green}"
zstyle ':vcs_info:*' formats "%F{color}%c%u%b%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
PROMPT='
%F{cyan} %F{clor}%n %1d $vcs_info_msg_0_%f
%F{color}$%f '

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


function search_history() {
  BUFFER=$(history -n -r 1 | awk '!a[$0]++' | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N search_history
bindkey '^r' search_history

eval "`npm completion`"
eval "$(hub alias -s)"


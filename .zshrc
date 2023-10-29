#git config
alias gs='git status'
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
alias pbcopy='xsel --clipboard --input'
alias encode='function __encode(){ echo -n "$1" | base64 }; __encode'
alias decode='function __decode(){ echo -n "$1" | base64 -d }; __decode'
alias ls="ls"
alias ll="ls -al"
alias ..="cd .."
alias reload="source ~/.zshrc && tmux source ~/.tmux.conf"
alias dc="docker compose"
alias dui="lazydocker"
alias kusa='curl https://github-contributions-api.deno.dev/$(git config user.name).term'
alias nyarn='echo "😺「にゃーん」" && yarn'

# prompt style
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}"
zstyle ':vcs_info:git:*' unstagedstr "%F{green}"
zstyle ':vcs_info:*' formats "%F{color}%c%u%b%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }
function precmd() {
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  fi
}
PROMPT='
%F{cyan} %F{color}%n %F{cyan} %F{clor}%~ %F{cyan} $vcs_info_msg_0_%f
%F{color}$%f '

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


# history, aliasからコマンドを検索する
function search_history() {
  BUFFER=$({ history -n -r 1 | awk '!a[$0]++'; alias | grep -oP "(?<=')[^']*(?=')" } | fzf +s +m -q "$LBUFFER" --prompt="Search Command... ")
  CURSOR=$#BUFFER
}
zle -N search_history
bindkey '^r' search_history


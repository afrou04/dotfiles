
#bashの設定
alias mkal="vim ~/.bashrc"
alias ldbash="source ~/.bash_profile"

#gitの設定
alias gs='git status'
alias ga="git add"
alias gc="git commit -m"
alias gps="git push origin HEAD"
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

# ngrok
# ex) ngrok http 3000
alias ngrok='~/../../Applications/ngrok'

alias ll="ls -la"

alias ..="cd .."

# docker設定
alias dc="docker-compose"

export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

# gitで補完できるようにする
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

# vimでclipboardにcopyできるようにする
# https://qiita.com/cawpea/items/3ca4ab80fc465d8eed7e
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export MANPATH=/opt/local/man:$MANPATH

# fzf setting {{{
# git checkout
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
fgb() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
# git log
fgl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
# enterでpreview
# ctrl-uでgit add
fgs() {
  modified_files=$(git status --short | awk '{print $2}') &&
  selected_files=$(echo "$modified_files" | fzf -m --preview 'git diff --color {}') &&
  git add $selected_files
}
# }
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

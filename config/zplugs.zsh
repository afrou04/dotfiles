source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug zsh-users/zsh-history-substring-search, as: plugin
zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load 

zstyle ':autocomplete:*' insert-unambiguous yes
zstyle '：autocomplete：* ' fzf-completion yes
zstyle ':completion:*' menu select
zmodload zsh/complist

bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^j' vi-down-line-or-history

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
  BUFFER=$({ \
    cheatlist 2>/dev/null; \
    alias | grep -oP "(?<=')[^']*(?=')"; \
    history -n -r 1 | awk '!a[$0]++'} \
    | fzf +s +m -q "$LBUFFER" --prompt="Search History... ")
  CURSOR=$#BUFFER
}

bindkey -e # ctrl-a, ctrl-eがtmux上で使えない問題の対応
zle -N search_history
bindkey '^r' search_history


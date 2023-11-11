# dir
DOTFIELS_DIR="$HOME/dotfiles"

source "$HOME/.zplug/init.zsh"
source "$DOTFIELS_DIR/config/zplugs.zsh"

export HISTFILE=$HOME/.zsh_history # 履歴ファイルの保存先
export HISTSIZE=10000              # メモリに保存される履歴の件数
export SAVEHIST=10000              # HISTFILE で指定したファイルに保存される履歴の件数

setopt hist_expire_dups_first # 履歴を切り詰める際に、重複する最も古いイベントから消す
setopt hist_ignore_all_dups   # 履歴が重複した場合に古い履歴を削除する
setopt hist_ignore_dups       # 前回のイベントと重複する場合、履歴に保存しない
setopt hist_save_no_dups      # 履歴ファイルに書き出す際、新しいコマンドと重複する古いコマンドは切り捨てる
setopt share_history          # 全てのセッションで履歴を共有する

# abbrevにしたい
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gsw='git switch'
alias gp='git push'
alias gpf='git push --force-with-lease origin'
alias gb='git branch'
alias gl='git log'
alias dc="docker compose"
alias ls="ls"
alias ll="ls -al"

#git config
alias open="nvim"
alias pbcopy='xsel --clipboard --input'
alias reload="source ~/.zshrc && tmux source ~/.tmux.conf"
alias reset="sudo hwclock -s"
alias dui="lazydocker"
alias kusa='curl https://github-contributions-api.deno.dev/$(git config user.name).term'
alias nyarn='echo "😺「にゃーん」" && yarn'
alias cheatlist="$DOTFIELS_DIR/command/cheatsheet/script.sh $DOTFIELS_DIR/command/cheatsheet/.commands.yml"
alias ide="$DOTFIELS_DIR/command/ide.sh"

# change directory
alias ..="cd .."
alias dc="dotfiles && nvim"

PURE_PROMPT_SYMBOL='%F{cyan}'
# PROMPT='%F{cyan} %F{color}%n %F{cyan} %F{clor}%~ %F{cyan}
# %F{color}$%f '

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
  BUFFER=$({ \
    cheatlist 2>/dev/null; \
    alias | grep -oP "(?<=')[^']*(?=')"; \
    history -n -r 1 | awk '!a[$0]++'} \
    | fzf +s +m -q "$LBUFFER" --prompt="Search History... ")
  CURSOR=$#BUFFER
}
zle -N search_history
bindkey '^r' search_history

bindkey -e # ctrl-a, ctrl-eがtmux上で使えない問題の対応

fpath=(path/to/zsh-completions/src $fpath)

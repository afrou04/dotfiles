# dir
DOTFIELS_DIR="$HOME/dotfiles"

fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
PURE_PROMPT_SYMBOL='%F{cyan}'

# FXIME: 読み込みで落ちる
# if [ -f "$HOME/fnm/completion.zsh" ]; then . "$HOME/fnm/completion.zsh"; fi
eval "$(fnm env --use-on-cd)"

source "$DOTFIELS_DIR/config/zplugs.zsh"
source ~/.zsh/git-prompt.sh

# eval "`npm completion`"
eval "$(hub alias -s)"
eval "$(zoxide init zsh)"

if [ -f "$HOME/google/path.zsh.inc" ]; then . "$HOME/google/path.zsh.inc"; fi
if [ -f "$HOME/google/completion.zsh.inc" ]; then . "$HOME/google/completion.zsh.inc"; fi

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
alias gps='git push'
alias gpsf='git push --force-with-lease origin'
alias gb='git branch'
alias gl='git log'
alias dc="docker compose"
alias ls="ls"
alias ll="ls -al"

#git config
alias open="nvim"
alias pbcopy='xsel --clipboard --input'
alias reload="~/.zshenv && source ~/.zshrc && tmux source ~/.tmux.conf"
alias reset="sudo hwclock -s"
alias dui="lazydocker"
alias nyarn='echo "😺「にゃーん」" && yarn'
alias cheatlist="$DOTFIELS_DIR/command/cheatsheet/script.sh $DOTFIELS_DIR/command/cheatsheet/.commands.yml"
alias ide="$DOTFIELS_DIR/command/ide.sh"
alias ..="cd .."


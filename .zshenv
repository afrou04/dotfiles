export PATH=$HOME/bin:/usr/local/bin:$PATH

# . "$HOME/.cargo/env"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/Users/afro/go/bin"

export GOPATH="$HOME/go"
export GOENV_ROOT="$HOME/.goenv"
export PATH="$PATH:$GOPATH/bin"

# goenv/fnm/zoxide の実体は linuxbrew 配下にある。これらを呼ぶ前に PATH へ入れる
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

# 外部コマンドを呼ぶ前に PATH を整える。
# WSL の interop が挿入する /mnt/c/... は DrvFs 上にあり stat が 2〜5ms かかる。
# これが /usr/bin より前に並んでいると、fork のたびに 19 ディレクトリを走査してから
# /usr/bin に到達するため起動が 5〜7 秒になる。末尾へ退避して約70%削減する
# （Windows 側コマンドは引き続き名前で呼べる）。/mnt が無い環境では no-op。
path=(${path:#/mnt/*} ${(M)path:#/mnt/*})
typeset -U path # 重複を除去。reload のたびに PATH が伸びるのを防ぐ

eval "$(goenv init - --no-rehash)"

export EDITOR="nvim"
export ZPLUG_HOME="$HOME/.zplug"

if [ -f "$HOME/.secrets" ]; then
  . "$HOME/.secrets"
fi


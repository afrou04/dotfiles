#!/bin/sh

# moshi (https://getmoshi.app) のセットアップ
#
# moshi-hook の導入 → ペアリング → Claude Code への hook 設定 → デーモン常駐 までを行う。
# 何度実行しても安全（各ステップは設定済みならスキップする）。
#
# ペアリングトークンはこのリポジトリ（public）には絶対に置かない。以下の優先順で解決する:
#   1. 環境変数 MOSHI_PAIRING_TOKEN
#   2. $HOME/.config/moshi/token (chmod 600)
#   3. 対話入力（入力値は 2 に保存する）
# トークンは Moshi アプリの Settings -> Integrations で発行する。
#
# 対象は Linux / WSL。macOS は brew と Keychain を使うため対象外。

set -u

MOSHI_TOKEN_FILE="${MOSHI_TOKEN_FILE:-$HOME/.config/moshi/token}"

# moshi-hook のインストール先。curl 版インストーラの既定値に合わせる
export PATH="$HOME/.local/bin:$PATH"

case "$(uname -s)" in
  Linux) ;;
  *)
    echo "moshi.shはLinux/WSL専用です（macOSは brew install rjyo/moshi/moshi-hook を使ってください）"
    exit 1
    ;;
esac

# ペアリングトークンを解決して標準出力へ返す
resolve_token() {
  if [ -n "${MOSHI_PAIRING_TOKEN:-}" ]; then
    printf '%s' "$MOSHI_PAIRING_TOKEN" | tr -d '[:space:]'
    return 0
  fi

  if [ -r "$MOSHI_TOKEN_FILE" ]; then
    tr -d '[:space:]' < "$MOSHI_TOKEN_FILE"
    return 0
  fi

  # 対話端末が無ければ入力を求められないので失敗させる
  if [ ! -t 0 ]; then
    return 1
  fi

  printf 'Moshiのペアリングトークン（アプリの Settings -> Integrations）: ' > /dev/tty
  read -r _token < /dev/tty
  _token=$(printf '%s' "$_token" | tr -d '[:space:]')
  [ -n "$_token" ] || return 1

  # トークンはリポジトリ外（$HOME 配下）にのみ保存する
  mkdir -p "$(dirname "$MOSHI_TOKEN_FILE")"
  chmod 700 "$(dirname "$MOSHI_TOKEN_FILE")"
  printf '%s\n' "$_token" > "$MOSHI_TOKEN_FILE"
  chmod 600 "$MOSHI_TOKEN_FILE"
  echo "トークンを $MOSHI_TOKEN_FILE に保存しました" > /dev/tty

  printf '%s' "$_token"
}

# install moshi-hook
moshi-hook version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "moshi-hookをインストールします"
  curl -fsSL https://getmoshi.app/install.sh | sh

  # インストール後のバージョン確認
  moshi-hook version > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "moshi-hookのインストールに失敗しました"
    exit 1
  fi
else
  echo "moshi-hookはインストール済みです"
fi

# pair moshi-hook
moshi-hook status 2>/dev/null | grep -qE '^status: +paired'
if [ $? -ne 0 ]; then
  echo "moshi-hookをペアリングします"

  token=$(resolve_token)
  if [ -z "${token:-}" ]; then
    echo "ペアリングトークンが取得できませんでした"
    echo "  MOSHI_PAIRING_TOKEN を設定するか $MOSHI_TOKEN_FILE を作成してください"
    exit 1
  fi
  if [ ${#token} -lt 16 ]; then
    echo "ペアリングトークンが短すぎます（${#token}文字）。値を確認してください"
    exit 1
  fi

  # WSL/headless では Keychain が使えないため file ストアを指定する
  # サーバ側の一時エラーで失敗することがあるので一度だけリトライする
  moshi-hook pair --token "$token" --store file
  if [ $? -ne 0 ]; then
    echo "ペアリングに失敗しました。再試行します"
    sleep 3
    moshi-hook pair --token "$token" --store file
    if [ $? -ne 0 ]; then
      echo "moshi-hookのペアリングに失敗しました"
      exit 1
    fi
  fi
  unset token
else
  echo "moshi-hookはペアリング済みです"
fi

# install claude code hooks
moshi-hook status 2>/dev/null | grep -qE '^ +claude +current'
if [ $? -ne 0 ]; then
  echo "Claude Codeのhookを設定します"

  # install は ~/.claude/settings.json を書き換えるので事前に控えを取る
  CLAUDE_SETTINGS="$HOME/.claude/settings.json"
  if [ -f "$CLAUDE_SETTINGS" ]; then
    backup="$CLAUDE_SETTINGS.bak.$(date +%Y%m%d%H%M%S)"
    cp "$CLAUDE_SETTINGS" "$backup"
    echo "  $backup にバックアップしました"
  fi

  moshi-hook install --target claude
  if [ $? -ne 0 ]; then
    echo "Claude Codeのhook設定に失敗しました"
    exit 1
  fi
else
  echo "Claude Codeのhookは設定済みです"
fi

# run moshi-hook daemon
moshi-hook probe 2>/dev/null | grep -qE '^running: +true'
if [ $? -ne 0 ]; then
  echo "moshi-hookデーモンをsystemdユーザーサービスとして常駐させます"
  moshi-hook service install
  if [ $? -ne 0 ]; then
    echo "moshi-hookデーモンの常駐化に失敗しました"
    echo "  systemdが無い環境では 'moshi-hook serve' を手動で起動してください"
    exit 1
  fi
else
  echo "moshi-hookデーモンは稼働中です"
fi

# enable linger
# ユーザーのログアウト後もサービスを維持するために必要
loginctl show-user "$(id -un)" --property=Linger 2>/dev/null | grep -q 'Linger=yes'
if [ $? -ne 0 ]; then
  echo "lingerを有効化します（ログアウト後もデーモンを維持するため）"
  sudo loginctl enable-linger "$(id -un)"
else
  echo "lingerは有効です"
fi

echo ""
echo "moshiのセットアップが完了しました"
echo "  状態確認: moshi-hook status"
echo "  ログ:     moshi-hook logs -f"
echo "  通知送信: moshi-notify \"タイトル\" \"本文\""

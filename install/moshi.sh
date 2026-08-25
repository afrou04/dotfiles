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

# herdr プラグインの場所をリポジトリ相対で解決するために使う
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# moshi-hook のインストール先。curl 版インストーラの既定値に合わせる
export PATH="$HOME/.local/bin:$PATH"

case "$(uname -s)" in
  Linux) ;;
  *)
    echo "moshi.shはLinux/WSL専用です（macOSは brew install rjyo/moshi/moshi-hook を使ってください）"
    exit 1
    ;;
esac

# settings.json の hook を間引くのに使う
command -v jq > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "moshi.shにはjqが必要です"
  exit 1
fi

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
#
# moshi-hook install は毎回実行する。実行条件に `moshi-hook status` の current/stale を
# 使わないのは、下で通知イベントを間引くと status が必ず stale を報告するようになるため
# （間引いた状態こそが狙いなので stale は異常ではない）。install はべき等で moshi 以外の
# hook も保持するので、毎回 install -> 間引き の順に流して最終形を固定する。
#
# 通知は herdr プラグイン（config/herdr/moshi-agent-notify）へ一本化するので、
# moshi-hook が書く hook のうち残すのは PermissionRequest だけにする。
#
# PermissionRequest は async:false（同期実行）で、Moshi 側の承認・拒否を
# Claude Code の権限判断へ返す唯一の経路になっている。herdr のプラグインイベントは
# コマンドを起動するだけで戻り値を返せないため、この承認往復は代替できない。
# 残り（UserPromptSubmit / PreToolUse / PostToolUse / Stop / SessionStart /
# SessionEnd）は herdr の状態変化通知と重複するので落とす。
prune_claude_hooks() {
  jq '
    def is_moshi: (.command // "") | test("moshi-hook") and test("claude-hook");
    def drop_moshi: .hooks |= map(select(is_moshi | not));
    def drop_empty: map(select((.hooks | length) > 0));

    .hooks = ((.hooks // {})
      | with_entries(
          if .key == "PermissionRequest" then .
          else .value = ((.value // []) | map(drop_moshi) | drop_empty)
          end)
      | with_entries(select((.value | length) > 0)))
  ' "$1"
}

CLAUDE_SETTINGS="$HOME/.claude/settings.json"

# install も間引きも ~/.claude/settings.json を書き換えるので事前に控えを取る
backup=""
if [ -f "$CLAUDE_SETTINGS" ]; then
  backup="$CLAUDE_SETTINGS.bak.$(date +%Y%m%d%H%M%S)"
  cp "$CLAUDE_SETTINGS" "$backup"
fi

moshi-hook install --target claude
if [ $? -ne 0 ]; then
  echo "Claude Codeのhook設定に失敗しました"
  exit 1
fi

if [ ! -f "$CLAUDE_SETTINGS" ]; then
  echo "$CLAUDE_SETTINGS が見つかりません"
  exit 1
fi

# jq の出力は一度一時ファイルへ落とす（途中で失敗しても settings.json を壊さないため）。
# 書き戻しは cat のリダイレクトで行い、元のパーミッションを保つ
tmp="$CLAUDE_SETTINGS.tmp.$$"
prune_claude_hooks "$CLAUDE_SETTINGS" > "$tmp"
if [ $? -ne 0 ] || [ ! -s "$tmp" ]; then
  rm -f "$tmp"
  echo "hookの間引きに失敗しました"
  if [ -n "$backup" ]; then
    echo "  $backup から復元してください"
  fi
  exit 1
fi
cat "$tmp" > "$CLAUDE_SETTINGS"
rm -f "$tmp"

if [ -n "$backup" ] && cmp -s "$backup" "$CLAUDE_SETTINGS"; then
  # 差分が無ければ控えは不要
  rm -f "$backup"
  echo "Claude Codeのhookは設定済みです"
else
  echo "Claude Codeのhookを設定しました（通知イベントは間引き済み）"
  if [ -n "$backup" ]; then
    echo "  $backup にバックアップしました"
  fi
fi

# install herdr plugin
#
# 通知そのものは herdr のプラグインが担う。エージェントの状態が blocked / done へ
# 変わったときに moshi-notify を呼ぶので、Claude Code に限らず herdr が面倒を見る
# エージェントすべてが同じ経路で通知される。
# herdr を使っていない環境では moshi-hook の PermissionRequest だけが残る。
HERDR_PLUGIN_DIR="$(dirname "$SCRIPT_DIR")/config/herdr/moshi-agent-notify"

command -v herdr > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "herdrが無いのでmoshi-agent-notifyプラグインの登録はスキップします"
elif [ ! -f "$HERDR_PLUGIN_DIR/herdr-plugin.toml" ]; then
  # このスクリプトだけを単体で持ち出した場合など。ここまでの設定は済んでいるので、
  # 中断せずプラグインの登録だけ諦める
  echo "$HERDR_PLUGIN_DIR が見つからないのでmoshi-agent-notifyプラグインの登録はスキップします"
else
  # 同じパスへの再リンクは上書きになるので、何度実行しても安全
  herdr plugin link "$HERDR_PLUGIN_DIR" --enabled > /dev/null
  if [ $? -ne 0 ]; then
    echo "moshi-agent-notifyプラグインの登録に失敗しました"
    exit 1
  fi
  echo "moshi-agent-notifyプラグインを登録しました"
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

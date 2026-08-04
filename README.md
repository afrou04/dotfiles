# Make a symbolic link

./dotfilesLink.sh

# moshi

[moshi](https://getmoshi.app) をセットアップする（Linux / WSL）。

```sh
./install/moshi.sh
```

moshi-hook の導入・ペアリング・Claude Code への hook 設定・デーモン常駐までを行う。何度実行してもよい。

ペアリングトークン（アプリの Settings -> Integrations で発行）は public リポジトリに置かないため、
以下から読む。どちらも無ければ実行時に対話入力し、`$HOME/.config/moshi/token` へ保存する。

1. 環境変数 `MOSHI_PAIRING_TOKEN`
2. `$HOME/.config/moshi/token`（`chmod 600`）

- Claude Code の hook は `~/.claude/settings.json` に追記される（既存の hook 設定は保持される）
- デーモンは systemd ユーザーサービス `moshi-hook.service` として常駐する
- moshi-hook が扱わないジョブ（ビルド・デプロイ・cron など）からの通知は `moshi-notify "タイトル" "本文"`


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

## 通知イベントの間引き

`moshi-hook install` が入れる hook のうち、こちらが操作したタイミングで飛んでくるものは
`install/moshi.sh` が毎回間引く。残す／外すの内訳は以下。

| hook | 扱い | 挙動 |
| --- | --- | --- |
| `PermissionRequest` | 残す | 承認待ち。同期実行でスマホから承認・却下を返せる |
| `PreToolUse` (`AskUserQuestion` / `ExitPlanMode`) | 残す | 質問・プランが提示された瞬間 |
| `Stop` | 残す | 作業完了 |
| `SessionStart` / `SessionEnd` | 残す | 通知は出さず、起動時刻・モデル名などを記録するだけ |
| `UserPromptSubmit` | 外す | セッション最初のプロンプト送信時に「Session started」を通知する |
| `PostToolUse` (`AskUserQuestion` / `ExitPlanMode`) | 外す | こちらが回答・承認した直後に発火する |

間引いた結果 `moshi-hook status` は claude を常に `stale` と報告するが、これは意図した状態。
`moshi-hook install --target claude` を単体で実行すると外した hook が復活するので、
`install/moshi.sh` 経由で流し直す。


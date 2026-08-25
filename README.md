# Make a symbolic link

./dotfilesLink.sh

# moshi

[moshi](https://getmoshi.app) をセットアップする（Linux / WSL）。

```sh
./install/moshi.sh
```

moshi-hook の導入・ペアリング・Claude Code への hook 設定・herdr プラグインの登録・デーモン常駐までを行う。
何度実行してもよい。

ペアリングトークン（アプリの Settings -> Integrations で発行）は public リポジトリに置かないため、
以下から読む。どちらも無ければ実行時に対話入力し、`$HOME/.config/moshi/token` へ保存する。

1. 環境変数 `MOSHI_PAIRING_TOKEN`
2. `$HOME/.config/moshi/token`（`chmod 600`）

- Claude Code の hook は `~/.claude/settings.json` に追記される（既存の hook 設定は保持される）
- デーモンは systemd ユーザーサービス `moshi-hook.service` として常駐する
- moshi-hook が扱わないジョブ（ビルド・デプロイ・cron など）からの通知は `moshi-notify "タイトル" "本文"`

## 通知は herdr の状態変化から出す

プッシュ通知は herdr プラグイン `config/herdr/moshi-agent-notify` が担う。
`install/moshi.sh` が `herdr plugin link --enabled` で登録し、
プラグインは `pane.agent_status_changed` を受けて `moshi-notify` を呼ぶ。
Claude Code に限らず herdr が面倒を見るエージェントはすべて同じ経路で通知される。

herdr が入っていない環境では登録をスキップする。

既定では `blocked`（入力待ち）と `done`（完了）のときに通知する。
設定は `herdr plugin config-dir moshi-agent-notify` が指すディレクトリの `.env` に置く。

| キー | 既定 | 意味 |
| --- | --- | --- |
| `NOTIFY_STATES` | `blocked,done` | 通知する `agent_status`。`idle` / `working` も指定できる |
| `AGENTS` | 空 | 通知対象のエージェント名（`claude,codex` など）。空なら全て |
| `SKIP_FOCUSED` | `0` | `1` なら表示中のペインは通知しない |
| `UNIFIED` | `0` | `1` なら同一ライセンスの全デバイスへ送る |
| `DEBUG` | `0` | `1` で受信イベントを標準出力へ。`herdr plugin log list` で読む |

`pane_agent_status_changed` は `cwd` を持たないので、通知本文の cwd とセッション名は
`herdr agent get <pane_id>` で補う。通知するかどうかの判定にはイベントの `agent_status`
だけを使う（`herdr agent get` の状態は発火の原因になった遷移より新しいことがある）。

## moshi-hook 側の hook

`moshi-hook install` が入れる hook のうち、`install/moshi.sh` は `PermissionRequest`
だけを残して毎回それ以外を落とす。

| hook | 扱い | 理由 |
| --- | --- | --- |
| `PermissionRequest` | 残す | `async: false`（同期実行）で、Moshi 側の承認・却下を Claude Code の権限判断へ返せる |
| それ以外 | 外す | 通知するだけなので herdr の状態変化通知と重複する |

herdr のプラグインイベントはコマンドを起動するだけで戻り値を返せないため、
スマホからの承認往復はこの hook でしか成立しない。`moshi-hook uninstall --target claude`
はエージェント単位でしか外せず、承認往復も一緒に消える。

承認待ちのときは `PermissionRequest` hook と herdr の `blocked` 通知が両方飛ぶ。
`pane_agent_status_changed` は承認待ちと質問待ちを区別しないので、重複を消すには
承認往復を捨てるしかない。承認できることを優先してこの形にしている。

間引いた結果 `moshi-hook status` は claude を常に `stale` と報告するが、これは意図した状態。
`moshi-hook install --target claude` を単体で実行すると外した hook が復活するので、
`install/moshi.sh` 経由で流し直す。

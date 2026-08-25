#!/usr/bin/env python3
"""herdr plugin: エージェントの状態変化を Moshi のプッシュ通知として送る。

`pane.agent_status_changed` で発火し、通知対象の状態 (既定: blocked / done) に
なったペインを `moshi-notify` へ流す。

herdr 0.7.5 の `pane_agent_status_changed` イベントは
`{"event": ..., "data": {pane_id, workspace_id, agent_status, agent, ...}}` の形で
渡ってくる。cwd は含まれず、display_agent / title / state_labels は値が無いと
省略される。そのため通知本文に載せる cwd やタイトルは
`herdr agent get <pane_id>` で補い、それも取れなければ
HERDR_PLUGIN_CONTEXT_JSON のワークスペース情報で埋める。

判定に使う状態はイベントの agent_status のみとする。`herdr agent get` の
agent_status は「取得した時点」の値で、発火の原因になった遷移より新しいことが
あるため、判定には使わない。

設定は herdr のプラグイン設定ディレクトリ (`herdr plugin config-dir
moshi-agent-notify`) 配下の `.env` から読む。無ければ既定値で動く。

    NOTIFY_STATES=blocked,done   通知する agent_status (カンマ区切り)
    AGENTS=                      通知対象のエージェント名。空なら全て
    SKIP_FOCUSED=0               1 なら表示中 (focused) のペインは通知しない
    UNIFIED=0                    1 なら同一ライセンスの全デバイスへ送る
    DEBUG=0                      1 なら受信したイベントを標準出力へ出す
                                 (`herdr plugin log moshi-agent-notify` で見る)
"""
import json
import os
import re
import shutil
import subprocess
import sys

PLUGIN_ID = "moshi-agent-notify"

# タイトル先頭に付くスピナー（◐ ✳ など）を落とすためのパターン。
# 英数・かな・漢字が現れるまでの記号と空白を取り除く
TITLE_PREFIX = re.compile(r"^[^\w぀-ヿ一-鿿]+")

# 状態ごとの見出し。ここに無い状態は通知しない
STATE_LABELS = {
    "blocked": "⏸ 入力待ち",
    "done": "✅ 完了",
    "idle": "💤 待機",
    "working": "▶ 作業中",
}

DEFAULT_NOTIFY_STATES = "blocked,done"


def debug(enabled, *args):
    if enabled:
        print(*args, file=sys.stdout, flush=True)


def config_dir():
    """herdr のプラグイン設定ディレクトリを返す。取得できなければ None。

    通常は herdr が HERDR_PLUGIN_CONFIG_DIR で渡してくる。手で実行したときの
    ために herdr へ問い合わせる経路も残す。
    """
    val = os.environ.get("HERDR_PLUGIN_CONFIG_DIR")
    if val:
        return val
    try:
        out = subprocess.run(
            ["herdr", "plugin", "config-dir", PLUGIN_ID],
            capture_output=True,
            text=True,
            timeout=5,
        )
        path = out.stdout.strip()
        return path or None
    except Exception:
        return None


def load_env():
    """設定ディレクトリの .env を読む。無ければ空の dict を返す。"""
    directory = config_dir()
    if not directory:
        return {}
    env = {}
    try:
        with open(os.path.join(directory, ".env")) as fh:
            for line in fh:
                line = line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue
                key, val = line.split("=", 1)
                env[key.strip()] = val.strip().strip('"').strip("'")
    except OSError:
        pass
    return env


def truthy(val):
    return str(val).strip().lower() in ("1", "true", "yes", "on")


def csv_set(val):
    return {item.strip().lower() for item in str(val).split(",") if item.strip()}


def event_data(event):
    """イベント本体を取り出す。data でネストされていても直下でも拾う。"""
    data = event.get("data")
    if isinstance(data, dict) and data:
        return data
    return event


def plugin_context():
    """herdr が渡すワークスペース情報。`herdr agent get` が空だったときの控え。"""
    try:
        ctx = json.loads(os.environ.get("HERDR_PLUGIN_CONTEXT_JSON", "{}"))
        return ctx if isinstance(ctx, dict) else {}
    except ValueError:
        return {}


def agent_info(pane_id):
    """`herdr agent get` でペインの詳細を引く。取れなければ空の dict。

    ここで得た agent_status は判定に使わない (発火時点より新しいことがある)。
    """
    if not pane_id:
        return {}
    try:
        out = subprocess.run(
            ["herdr", "agent", "get", pane_id],
            capture_output=True,
            text=True,
            timeout=6,
        )
        payload = json.loads(out.stdout)
        info = payload.get("result", {}).get("agent", {})
        return info if isinstance(info, dict) else {}
    except Exception:
        return {}


def moshi_notify_cmd():
    """moshi-notify の実行パスを返す。見つからなければ None。"""
    found = shutil.which("moshi-notify")
    if found:
        return found
    for path in ("/usr/local/bin/moshi-notify", os.path.expanduser("~/.local/bin/moshi-notify")):
        if os.access(path, os.X_OK):
            return path
    return None


def main():
    cfg = load_env()
    dbg = truthy(cfg.get("DEBUG", os.environ.get("MOSHI_HERDR_DEBUG", "0")))

    raw = os.environ.get("HERDR_PLUGIN_EVENT_JSON", "{}")
    debug(dbg, "event:", raw)
    debug(dbg, "herdr env:", {k: v for k, v in os.environ.items() if k.startswith("HERDR_")})

    try:
        event = json.loads(raw)
    except ValueError:
        return
    data = event_data(event)

    status = str(data.get("agent_status") or "").lower()
    notify_states = csv_set(cfg.get("NOTIFY_STATES", DEFAULT_NOTIFY_STATES))
    if status not in notify_states or status not in STATE_LABELS:
        debug(dbg, "skip: status", status)
        return

    agent = str(data.get("agent") or data.get("display_agent") or "").lower()
    agents = csv_set(cfg.get("AGENTS", ""))
    if agents and agent not in agents:
        debug(dbg, "skip: agent", agent)
        return

    pane_id = str(data.get("pane_id") or "")
    info = agent_info(pane_id)

    if truthy(cfg.get("SKIP_FOCUSED", "0")) and info.get("focused"):
        debug(dbg, "skip: focused pane", pane_id)
        return

    ctx = plugin_context()
    cwd = str(info.get("cwd") or ctx.get("workspace_cwd") or "").rstrip("/")
    project = os.path.basename(cwd) or str(ctx.get("workspace_label") or "") or "?"
    # ペインのタイトル。エージェントが付けたセッション名が入る
    raw_title = (
        data.get("title")
        or info.get("terminal_title_stripped")
        or info.get("terminal_title")
        or ""
    )
    title = TITLE_PREFIX.sub("", str(raw_title)).strip()

    heading = f"{STATE_LABELS[status]} · {project}"
    if agent:
        heading = f"{heading} ({agent})"

    body_lines = []
    if title:
        body_lines.append(title)
    if cwd:
        body_lines.append(cwd)
    body_lines.append(f"pane {pane_id}" if pane_id else "pane ?")
    body = "\n".join(body_lines)

    cmd = moshi_notify_cmd()
    if not cmd:
        debug(dbg, "moshi-notify が見つかりません")
        return

    argv = [cmd]
    if truthy(cfg.get("UNIFIED", "0")):
        argv.append("-u")
    argv.extend([heading, body])

    debug(dbg, "notify:", argv)
    try:
        # 通知の失敗で herdr 側を止めない
        subprocess.run(argv, capture_output=True, text=True, timeout=15)
    except Exception:
        pass


if __name__ == "__main__":
    main()

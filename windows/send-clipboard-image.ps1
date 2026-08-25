# クリップボードの画像をSSH先へ転送し、リモート側のパスを手元のクリップボードに入れる。
#
# Claude CodeはSSH先で動いているため、手元のクリップボードにある画像をCtrl+Vでは渡せない。
# SSHが運ぶのはキーストロークとテキストだけで、Claude Codeがクリップボードを読もうとしても
# それは接続先のマシンのものになるため。画像はファイルとして転送し、パスを貼って渡す。
#
# 使い方:
#   1. Win+Shift+S などでスクリーンショットを撮る (クリップボードに入る)
#   2. このスクリプトを実行する (ホットキーに割り当てると楽)
#   3. Claude Codeのプロンプトで Ctrl+Shift+V するとパスが貼られる
#
# ホットキーの割り当て方 (どれか一つ):
#   - このファイルへのショートカットを作り、プロパティの「ショートカットキー」に設定する
#   - PowerToys の Keyboard Manager でキーにコマンドを割り当てる
#   - AutoHotkey で `^!s::Run "powershell -File <このファイルのパス>", , Hide` のように書く

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

# 転送先。IPは変わりうるのでTailscaleのMagicDNS名を使う
$RemoteHost = 'afrou@wsl-herdr'
$RemoteDir = 'ss'

function Send-ClipboardImage {
    $image = Get-Clipboard -Format Image
    if ($null -eq $image) {
        Write-Host 'クリップボードに画像がありません' -ForegroundColor Yellow
        return
    }

    $name = 'ss-{0:yyyyMMdd-HHmmss}.png' -f (Get-Date)
    $localPath = Join-Path $env:TEMP $name

    try {
        $image.Save($localPath, [System.Drawing.Imaging.ImageFormat]::Png)

        scp -q $localPath "${RemoteHost}:${RemoteDir}/$name"
        if ($LASTEXITCODE -ne 0) {
            # 初回など転送先ディレクトリが無い場合に作ってからやり直す
            ssh $RemoteHost "mkdir -p '$RemoteDir'"
            scp -q $localPath "${RemoteHost}:${RemoteDir}/$name"
            if ($LASTEXITCODE -ne 0) { throw "転送に失敗しました (scp exit $LASTEXITCODE)" }
        }

        $remotePath = "~/$RemoteDir/$name"
        Set-Clipboard -Value $remotePath
        Write-Host "転送しました: $remotePath" -ForegroundColor Green
    }
    finally {
        if (Test-Path $localPath) { Remove-Item $localPath -Force }
    }
}

Send-ClipboardImage

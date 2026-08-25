# WSLインスタンスを常駐させ、Tailscale SSHで外から到達できる状態に保つ。
#
# WSL2のVMは中で動くプロセスが全部終わると自動で停止する。停止するとWSL内の
# tailscaledも一緒に死に、tailnet上でノードがofflineになって外からsshできなくなる。
# 何もしないプロセスを1つ常駐させることでVMの自動停止を防ぐ。
#
# タスクのアクションはwsl.exeを直接呼ぶ。このスクリプト自体をタスクから実行させると
# \\wsl.localhost\ 越しにファイルを読むことになり、WSLが止まっている状態では
# スクリプトが読めずWSLを起動できないという循環に陥るため。
#
# 使い方 (Installとuninstallは管理者PowerShellで実行):
#   powershell -ExecutionPolicy Bypass -File .\keep-wsl-alive.ps1 -Install
#   powershell -ExecutionPolicy Bypass -File .\keep-wsl-alive.ps1 -Status
#   powershell -ExecutionPolicy Bypass -File .\keep-wsl-alive.ps1 -Uninstall
#
# 管理者権限が要るのは、ログオン前から常駐させるためにS4Uログオンと
# スタートアップトリガーを使うため。S4Uだとコンソールウィンドウも出ない。
#
# スリープ対策は別途必要。このタスクはVMの自動停止しか防がない。
# Windowsがスリープに入るとWSLごと止まるため、常時到達させたいなら
#   powercfg /change standby-timeout-ac 0
# などで電源設定側も合わせて調整する。
#
# wsl --shutdown を打つと常駐プロセスごと落ちる。タスクの再試行設定は
# 異常終了しか拾わないため自動では戻らない。手で再開する:
#   Start-ScheduledTask -TaskName KeepWslAlive
#
# 起動時トリガー + S4Uでログオン前から常駐させる構成はこの環境では未検証。
# S4Uログオンだとwsl.exeが必要とするユーザープロファイルが揃わない可能性がある。
# 再起動後に -Status を見て確認する。正常なら
#   タスク = Running / 結果コード = 267009 (SCHED_S_TASK_RUNNING) / WSL = 起動中
# となる。結果コードが0はsleepが終了したことを意味する (このタスクでは異常)。
# 駄目ならNew-ScheduledTaskPrincipalの -LogonType を Interactive に変え、
# ログオン時トリガーだけに頼る (ログオン前の到達性は諦める)。

[CmdletBinding(DefaultParameterSetName = 'Status')]
param(
    [Parameter(ParameterSetName = 'Install', Mandatory = $true)][switch]$Install,
    [Parameter(ParameterSetName = 'Uninstall', Mandatory = $true)][switch]$Uninstall,
    [Parameter(ParameterSetName = 'Status')][switch]$Status,
    [Parameter(ParameterSetName = 'Install')]
    [Parameter(ParameterSetName = 'Status')]
    [ValidateNotNullOrEmpty()][string]$Distro = 'Ubuntu'
)

$ErrorActionPreference = 'Stop'

$TaskName = 'KeepWslAlive'
$WslExe = Join-Path $env:SystemRoot 'System32\wsl.exe'
$KeepAliveCommand = '/bin/sleep'
$KeepAliveArgs = 'infinity'

function Test-Admin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-WslDistro {
    # wsl.exeの一覧出力はUTF-16LE。エンコーディングを合わせないと1文字おきにNULが混ざる
    $prev = [Console]::OutputEncoding
    try {
        [Console]::OutputEncoding = [Text.Encoding]::Unicode
        $raw = & $WslExe --list --quiet 2>$null
    }
    finally {
        [Console]::OutputEncoding = $prev
    }
    return @($raw -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

function Install-KeepAliveTask {
    if (-not (Test-Admin)) {
        throw '管理者PowerShellで実行してください (S4Uログオンとスタートアップトリガーの登録に必要)'
    }
    if (-not (Test-Path $WslExe)) {
        throw "wsl.exeが見つかりません: $WslExe"
    }

    $distros = Get-WslDistro
    if ($distros.Count -eq 0) {
        throw 'WSLディストリビューションが1つも見つかりません'
    }
    if ($distros -notcontains $Distro) {
        throw "ディストリビューション '$Distro' がありません。候補: $($distros -join ', ')"
    }

    $userId = '{0}\{1}' -f $env:USERDOMAIN, $env:USERNAME
    $argument = '-d {0} --exec {1} {2}' -f $Distro, $KeepAliveCommand, $KeepAliveArgs

    $action = New-ScheduledTaskAction -Execute $WslExe -Argument $argument
    $triggers = @(
        # 起動時とログオン時の両方を張る。S4Uでの起動時トリガーが効かない環境でも
        # ログオン時に拾えるようにするため。MultipleInstancesで二重起動は防ぐ
        (New-ScheduledTaskTrigger -AtStartup),
        (New-ScheduledTaskTrigger -AtLogOn -User $userId)
    )
    $principal = New-ScheduledTaskPrincipal -UserId $userId -LogonType S4U -RunLevel Limited
    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -DontStopOnIdleEnd `
        -StartWhenAvailable `
        -MultipleInstances IgnoreNew `
        -ExecutionTimeLimit ([TimeSpan]::Zero) `
        -RestartCount 3 `
        -RestartInterval (New-TimeSpan -Minutes 1)

    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $action `
        -Trigger $triggers `
        -Principal $principal `
        -Settings $settings `
        -Description "WSL ($Distro) を常駐させ、中で動くtailscaledをofflineにしない" `
        -Force | Out-Null

    Start-ScheduledTask -TaskName $TaskName
    Write-Host "タスク '$TaskName' を登録して開始しました (distro: $Distro)" -ForegroundColor Green
}

function Uninstall-KeepAliveTask {
    if (-not (Test-Admin)) {
        throw '管理者PowerShellで実行してください'
    }
    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($null -eq $task) {
        Write-Host "タスク '$TaskName' は登録されていません" -ForegroundColor Yellow
        return
    }
    Stop-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    Write-Host "タスク '$TaskName' を削除しました。常駐していたsleepも止まります" -ForegroundColor Green
}

function Show-Status {
    $task = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    if ($null -eq $task) {
        Write-Host "タスク: 未登録 ($TaskName)" -ForegroundColor Yellow
    }
    else {
        $info = Get-ScheduledTaskInfo -TaskName $TaskName
        Write-Host "タスク: $($task.State) ($TaskName)"
        Write-Host "  最終実行: $($info.LastRunTime)  結果コード: $($info.LastTaskResult)"
        Write-Host "  アクション: $($task.Actions[0].Execute) $($task.Actions[0].Arguments)"
    }

    $prev = [Console]::OutputEncoding
    try {
        [Console]::OutputEncoding = [Text.Encoding]::Unicode
        $running = @(& $WslExe --list --running --quiet 2>$null | ForEach-Object { $_.Trim() } | Where-Object { $_ })
    }
    finally {
        [Console]::OutputEncoding = $prev
    }
    if ($running.Count -eq 0) {
        Write-Host 'WSL: 起動中のディストリビューションなし' -ForegroundColor Yellow
    }
    else {
        Write-Host "WSL: 起動中 -> $($running -join ', ')"
    }

    # WSLが動いていてもTailscale SSHが無効なら外からsshできない。
    # 停止中のディストリビューションには問い合わせない (問い合わせ自体が起動させてしまうため)
    if ($running -contains $Distro) {
        $prefs = & $WslExe -d $Distro --exec sh -c 'tailscale debug prefs 2>/dev/null | grep -i runssh' 2>$null
        if ($prefs -match 'true') {
            Write-Host "Tailscale SSH: 有効 ($Distro)"
        }
        else {
            Write-Host "Tailscale SSH: 無効 ($Distro) -> WSL内で sudo tailscale set --ssh" -ForegroundColor Yellow
        }
    }
}

switch ($PSCmdlet.ParameterSetName) {
    'Install' { Install-KeepAliveTask }
    'Uninstall' { Uninstall-KeepAliveTask }
    default { Show-Status }
}

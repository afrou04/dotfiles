function Watch-Clipboard {
    $interval = 500

    $oldClipboard = Get-Clipboard
    $newClipboard = Get-Clipboard
    
    while ($true) {
        $oldClipboard = Get-Clipboard

        if ($newClipboard -ne $oldClipboard) {
            Write-Host "Change clipboad!"
            Write-Host "New clipboard content: $oldClipboard"

            $newClipboard = Convert-UrlFormat $oldClipboard
            
            Set-Clipboard -Value $newClipboard
        }

        Start-Sleep -Milliseconds $interval
    }
}

# URLの形式を変換する関数
function Convert-UrlFormat {
    param(
        [string]$content
    )

    # zenhubに一致したissueはgithubのURLに変換する
    $regexPattern = "https:\/\/app\.zenhub\.com\/workspaces\/(\w+)-(\w+)\/issues\/gh\/(.*?)\/(.*?)/(\d+)$"

    if ($content -match $regexPattern) {

        # 抽出した情報を変数に格納
        $organization = $matches[3]
        $repository = $matches[4]
        $id = $matches[5]

        $newUrl = "https://github.com/$organization/$repository/issues/$id"
        
        return $newUrl
    }
    else {
        return $content
    }
}

Watch-Clipboard


# PHP
base image: [lorisleiva/laravel-docker](https://hub.docker.com/r/lorisleiva/laravel-docker/)  
[cli tools](#cli-tools)

---

## cli tools
- [bat](https://github.com/sharkdp/bat/releases)
- [diskus](https://github.com/sharkdp/diskus/releases)
- [fd](https://github.com/sharkdp/fd/releases)
- [fzf](https://github.com/junegunn/fzf-bin/releases)
- [hyperfine](https://github.com/sharkdp/hyperfine/releases)
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases)
- [starship](https://github.com/starship/starship/releases)

## usage
```powershell
function php ([String]$src = "~\php", [Int]$port) {
    $bind = pathValidate $src | mountFolder "/php"
    $map = $port | ? { $_ -gt 0 -and ($_ -lt 65535) } | % { "-p $_" } # 0 < port < 65535

    iex "
        docker create ``
            -e TZ=Asia/Hong_Kong ``
            $map ``
            $bind ``
            -v php:/root/.vscode-server/extensions ``
            --tmpfs /root/.cache ``
            --tmpfs /tmp ``
            -i ``
            tmpac/php
    "
}

function pathValidate ([String]$path) {
    $path | ? { Test-Path $_ } | Resolve-Path
}

function mountFolder {
    Param
    (
        [String]$dst,

        [Parameter(ValueFromPipeline)]
        [String]$src
    )

    $src | ? { $_ } | % { "-v $($_ -replace '\\', '/'):$dst" }
}
```
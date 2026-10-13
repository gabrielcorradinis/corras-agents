# Prepara um repositorio para o fluxo do time: CLAUDE.md, specs/DECISOES.md e .gitignore.
# Uso: .\instalar-no-repo.ps1 C:\caminho\do\repo
param([Parameter(Mandatory = $true)][string]$Repo)
$ErrorActionPreference = "Stop"
$kit = $PSScriptRoot

if (-not (Test-Path (Join-Path $Repo ".git"))) { throw "$Repo nao e um repositorio git." }

$claudeMd = Join-Path $Repo "CLAUDE.md"
if (Test-Path $claudeMd) {
    Write-Host "CLAUDE.md ja existe. Acrescentando o fluxo no final (revise e junte as secoes)."
    Add-Content -Path $claudeMd -Encoding utf8 -Value ("`n`n" + (Get-Content (Join-Path $kit "repo\CLAUDE.md") -Raw -Encoding utf8))
} else {
    Copy-Item (Join-Path $kit "repo\CLAUDE.md") $claudeMd
}

New-Item -ItemType Directory -Force (Join-Path $Repo "specs") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $Repo "incidentes") | Out-Null
$decisoes = Join-Path $Repo "specs\DECISOES.md"
if (-not (Test-Path $decisoes)) { Copy-Item (Join-Path $kit "repo\specs\DECISOES.md") $decisoes }

$gitignore = Join-Path $Repo ".gitignore"
if (-not (Test-Path $gitignore) -or -not (Select-String -Path $gitignore -Pattern "^uat/" -Quiet)) {
    Add-Content -Path $gitignore -Encoding utf8 -Value "`n# Time de agentes`nuat/"
}

Write-Host "Pronto em $Repo."
Write-Host "Falta: preencher 'Como rodar a aplicacao' no CLAUDE.md (ou deixar o /spec perguntar na primeira vez) e commitar."

# Instala os agentes e os comandos /spec e /autonomo para todos os projetos desta maquina.
# Uso: .\instalar-global.ps1
$ErrorActionPreference = "Stop"
$kit = $PSScriptRoot
$claude = Join-Path $HOME ".claude"

New-Item -ItemType Directory -Force (Join-Path $claude "agents") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $claude "skills") | Out-Null

Copy-Item (Join-Path $kit "global\agents\*.md") (Join-Path $claude "agents") -Force
# cada pasta de global\skills vira um comando (/spec, /autonomo), com os arquivos de apoio dela
Get-ChildItem (Join-Path $kit "global\skills") -Directory | ForEach-Object {
    $destino = Join-Path $claude ("skills\" + $_.Name)
    New-Item -ItemType Directory -Force $destino | Out-Null
    Copy-Item (Join-Path $_.FullName "*") $destino -Recurse -Force
}

Write-Host "Agentes instalados em $claude\agents:"
Get-ChildItem (Join-Path $claude "agents") -Filter *.md | ForEach-Object { Write-Host "  - $($_.BaseName)" }
Write-Host "Comandos instalados em $claude\skills:"
Get-ChildItem (Join-Path $kit "global\skills") -Directory | ForEach-Object { Write-Host "  - /$($_.Name)" }

$mcp = claude mcp list 2>$null | Select-String -Pattern "^playwright"
if (-not $mcp) {
    Write-Host "Configurando MCP do Playwright (escopo de usuario)..."
    claude mcp add --scope user playwright -- npx -y "@playwright/mcp@latest"
} else {
    Write-Host "MCP do Playwright ja configurado."
}

Write-Host ""
Write-Host "Pronto. Em cada repositorio, rode: .\instalar-no-repo.ps1 <caminho-do-repo>"

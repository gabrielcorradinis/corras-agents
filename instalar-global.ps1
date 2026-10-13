# Instala os agentes e o comando /spec para todos os projetos desta maquina.
# Uso: .\instalar-global.ps1
$ErrorActionPreference = "Stop"
$kit = $PSScriptRoot
$claude = Join-Path $HOME ".claude"

New-Item -ItemType Directory -Force (Join-Path $claude "agents") | Out-Null
New-Item -ItemType Directory -Force (Join-Path $claude "skills\spec") | Out-Null

Copy-Item (Join-Path $kit "global\agents\*.md") (Join-Path $claude "agents") -Force
Copy-Item (Join-Path $kit "global\skills\spec\SKILL.md") (Join-Path $claude "skills\spec") -Force

Write-Host "Agentes instalados em $claude\agents:"
Get-ChildItem (Join-Path $claude "agents") -Filter *.md | ForEach-Object { Write-Host "  - $($_.BaseName)" }
Write-Host "Comando /spec instalado em $claude\skills\spec"

$mcp = claude mcp list 2>$null | Select-String -Pattern "^playwright"
if (-not $mcp) {
    Write-Host "Configurando MCP do Playwright (escopo de usuario)..."
    claude mcp add --scope user playwright -- npx -y "@playwright/mcp@latest"
} else {
    Write-Host "MCP do Playwright ja configurado."
}

Write-Host ""
Write-Host "Pronto. Em cada repositorio, rode: .\instalar-no-repo.ps1 <caminho-do-repo>"

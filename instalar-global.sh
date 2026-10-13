#!/usr/bin/env bash
# Instala os agentes e o comando /spec para todos os projetos desta máquina (Mac/Linux).
# Uso: ./instalar-global.sh
set -euo pipefail
kit="$(cd "$(dirname "$0")" && pwd)"
claude_dir="$HOME/.claude"

mkdir -p "$claude_dir/agents" "$claude_dir/skills/spec"
cp "$kit"/global/agents/*.md "$claude_dir/agents/"
cp "$kit"/global/skills/spec/SKILL.md "$claude_dir/skills/spec/"

echo "Agentes instalados em $claude_dir/agents:"
for f in "$claude_dir"/agents/*.md; do echo "  - $(basename "${f%.md}")"; done
echo "Comando /spec instalado em $claude_dir/skills/spec"

if ! claude mcp list 2>/dev/null | grep -q '^playwright'; then
  echo "Configurando MCP do Playwright (escopo de usuário)..."
  claude mcp add --scope user playwright -- npx -y @playwright/mcp@latest
else
  echo "MCP do Playwright já configurado."
fi

echo
echo "Pronto. Em cada repositório, rode: ./instalar-no-repo.sh <caminho-do-repo>"

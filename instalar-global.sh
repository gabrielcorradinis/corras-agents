#!/usr/bin/env bash
# Instala os agentes e os comandos /spec e /autonomo para todos os projetos desta máquina (Mac/Linux).
# Uso: ./instalar-global.sh
set -euo pipefail
kit="$(cd "$(dirname "$0")" && pwd)"
claude_dir="$HOME/.claude"

mkdir -p "$claude_dir/agents" "$claude_dir/skills"
cp "$kit"/global/agents/*.md "$claude_dir/agents/"
# cada pasta de global/skills vira um comando (/spec, /autonomo), com os arquivos de apoio dela
for d in "$kit"/global/skills/*/; do
  n="$(basename "$d")"
  mkdir -p "$claude_dir/skills/$n"
  cp -R "$d". "$claude_dir/skills/$n/"
done

echo "Agentes instalados em $claude_dir/agents:"
for f in "$claude_dir"/agents/*.md; do echo "  - $(basename "${f%.md}")"; done
echo "Comandos instalados em $claude_dir/skills:"
for d in "$kit"/global/skills/*/; do echo "  - /$(basename "$d")"; done

if ! claude mcp list 2>/dev/null | grep -q '^playwright'; then
  echo "Configurando MCP do Playwright (escopo de usuário)..."
  claude mcp add --scope user playwright -- npx -y @playwright/mcp@latest
else
  echo "MCP do Playwright já configurado."
fi

echo
echo "Pronto. Em cada repositório, rode: ./instalar-no-repo.sh <caminho-do-repo>"

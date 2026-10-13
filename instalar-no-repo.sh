#!/usr/bin/env bash
# Prepara um repositório para o fluxo do time: CLAUDE.md, specs/DECISOES.md e .gitignore (Mac/Linux).
# Uso: ./instalar-no-repo.sh /caminho/do/repo
set -euo pipefail
kit="$(cd "$(dirname "$0")" && pwd)"
repo="${1:?informe o caminho do repositório}"

[ -d "$repo/.git" ] || { echo "$repo não é um repositório git."; exit 1; }

if [ -f "$repo/CLAUDE.md" ]; then
  echo "CLAUDE.md já existe. Acrescentando o fluxo no final (revise e junte as seções)."
  { printf '\n\n'; cat "$kit/repo/CLAUDE.md"; } >> "$repo/CLAUDE.md"
else
  cp "$kit/repo/CLAUDE.md" "$repo/CLAUDE.md"
fi

mkdir -p "$repo/specs" "$repo/incidentes"
[ -f "$repo/specs/DECISOES.md" ] || cp "$kit/repo/specs/DECISOES.md" "$repo/specs/DECISOES.md"

if ! grep -q '^uat/' "$repo/.gitignore" 2>/dev/null; then
  printf '\n# Time de agentes\nuat/\n' >> "$repo/.gitignore"
fi

echo "Pronto em $repo."
echo "Falta: preencher 'Como rodar a aplicação' no CLAUDE.md (ou deixar o /spec perguntar na primeira vez) e commitar."

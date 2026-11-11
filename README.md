# corras-agents

Um time de subagentes para o Claude Code, com prompts em português. Em vez de pedir uma feature e torcer, a demanda passa por papéis separados: alguém fecha a especificação com você, o QA escreve os testes de aceite antes do código, um implementador faz os testes passarem, revisores validam e, no fim, segurança e um teste de aceitação no navegador.

Cada agente tem um escopo de escrita limitado (o QA só mexe em teste, o refinador só em `specs/`, e assim por diante), então dá para saber quem fez o quê e por quê.

## O fluxo

```
ideia ─► /spec (entrevista) ─► explorador ─► refinador-tecnico ─► arquiteto
                                                                    │
            ┌───────────────── para cada tarefa da spec ────────────┘
            ▼
     qa escreve os testes ─► implementador ─► qa + code-reviewer
            ▲                                        │
            └──────────── BLOQUEANTE? volta ─────────┘
                                                     │ tudo aprovado
                                                     ▼
                                          seguranca + watch ─► PR
```

Falha em produção segue outro caminho: o `investigador-de-falhas` entende e reproduz antes de qualquer correção, e o relatório dele entra no fluxo normal.

## O time

| Agente | Modelo | Quando roda | Escreve em |
|---|---|---|---|
| `/spec` (comando) | o da sessão | Quando a demanda chega como ideia solta. Entrevista o humano antes de escrever. Na primeira vez em um repositório, faz a entrevista inicial do projeto. | `specs/DECISOES.md` |
| `/autonomo` (comando) | o da sessão | Quando você quer passar o trabalho e só ver pronto. Pergunta tudo numa rodada só no começo e depois o time vai sozinho. | `specs/MANDATO.md`, `REGISTRO.md`, `PENDENTES.md` |
| `explorador` | haiku | Passo 0, sempre. Mapeia a área do código que a demanda toca. | nada |
| `refinador-tecnico` | opus | Transforma o pedido em spec fechada, com as decisões tomadas e tarefas autocontidas. | `specs/` |
| `arquiteto` | opus | Revisa a spec antes de existir código. Aprova ou devolve. | nada |
| `qa` | sonnet | Duas vezes por tarefa: escreve os testes de aceite antes do implementador e valida depois. | arquivos de teste |
| `implementador` | sonnet | Uma tarefa por vez. Faz os testes do QA passarem. É o único que edita código de produção. | código |
| `code-reviewer` | sonnet | Por tarefa, em paralelo com o QA. | nada |
| `seguranca` | opus | Uma vez por demanda, no fim. Obrigatório em login, pagamento, dado pessoal e integrações. | nada |
| `watch` | sonnet | Uma vez por demanda. Abre a aplicação pelo MCP do Playwright e navega como usuário, ou chama a API quando não há tela. | `uat/` |
| `investigador-de-falhas` | opus | Antes de corrigir qualquer falha. Guarda memória dos incidentes do projeto. | `incidentes/` |

A divisão de modelos é proposital: Opus planeja, revisa a spec e investiga; Sonnet executa e valida; Haiku explora, que é o passo mais repetido e o que menos precisa de raciocínio.

## O que tem no repositório

```
global/agents/            os 9 agentes, vão para ~/.claude/agents/
global/skills/spec/       comando /spec
global/skills/autonomo/   comando /autonomo e os modelos de MANDATO, REGISTRO e PENDENTES
repo/CLAUDE.md            o fluxo e as regras, vai para a raiz de cada repositório
repo/specs/DECISOES.md    registro das decisões do projeto
instalar-global.*         instala agentes, comandos e o MCP do Playwright (uma vez por máquina)
instalar-no-repo.*        prepara um repositório (CLAUDE.md, specs/, incidentes/, .gitignore)
```

Os agentes ficam globais, mas o `CLAUDE.md` é por repositório de propósito: o fluxo só vale onde você instalar, e não em todo projeto da máquina.

## Instalação

Precisa do Claude Code (comando `claude` no PATH), git e Node (o MCP do Playwright roda via `npx`).

```bash
git clone https://github.com/gabrielcorradinis/corras-agents.git
cd corras-agents
```

1. Uma vez por máquina:
   - Windows: `.\instalar-global.ps1`
   - Mac/Linux: `./instalar-global.sh`
2. Em cada repositório onde o time vai trabalhar:
   - Windows: `.\instalar-no-repo.ps1 C:\caminho\do\repo`
   - Mac/Linux: `./instalar-no-repo.sh /caminho/do/repo`

   Se o repositório já tiver um `CLAUDE.md`, o fluxo é acrescentado no final; revise e junte as seções. Depois, commite o que foi criado.
3. No `CLAUDE.md` do repositório, troque o nome em "Humano de escalada" por quem responde quando o time trava, e preencha "Como rodar a aplicação" (ou deixe o `/spec` perguntar na primeira entrevista). O `watch` depende dessa seção para subir a aplicação.
4. Abra o Claude Code no repositório, rode `/agents` para conferir os 9 agentes e digite `/spec`.

## Como usar

```
/spec quero que o cliente consiga salvar o carrinho para depois
```
Ele pergunta antes de escrever: no máximo três perguntas por vez, sempre com opções e uma recomendação. Quando uma decisão anterior do projeto se aplica, ele mostra qual foi e pergunta se mantém.

```
Use o explorador e depois o refinador-tecnico para a issue #123, e siga o fluxo do CLAUDE.md.
```

```
Use o investigador-de-falhas para o alerta de timeout no checkout (log em anexo).
```

```
/autonomo quero um app de agendamento para barbearias
```

## Modo autônomo

O `/autonomo` serve para quando você quer entregar a demanda e voltar só no fim.

1. Os agentes estudam o pedido e o projeto (explorador, rascunho do refinador, arquiteto e, se houver dado sensível, segurança).
2. A sessão junta tudo o que é decisão sua (negócio, escopo, gasto, contas, produção, o que é difícil de desfazer) e pergunta numa rodada só. As escolhas técnicas óbvias aparecem como lista para você vetar.
3. As respostas viram `specs/MANDATO.md`, com o critério de pronto e os limites.
4. O time executa sem perguntar. Dúvida nova vira decisão registrada em `specs/REGISTRO.md`. O que só você pode fazer (criar conta, digitar senha, gastar, mexer em produção) vai para `specs/PENDENTES.md`, e o trabalho segue no que não depende disso.
5. Termina quando o critério de pronto estiver verificado ou quando só restarem pendências.

Na volta, leia a seção Resultado do mandato e as entradas do REGISTRO marcadas "Revisar: sim".

## Regras do fluxo

- Três níveis de severidade para todos os validadores: BLOQUEANTE, IMPORTANTE e SUGESTÃO. Só BLOQUEANTE reprova.
- O implementador só toca os arquivos listados na tarefa e não altera os testes de aceite do QA.
- Limites de rodada: o arquiteto devolve a spec no máximo 2 vezes; cada tarefa tem no máximo 5 rodadas. Passou disso, escala para o humano.
- A partir da rodada 2, validador não levanta apontamento novo sobre código que não mudou, salvo problema crítico de segurança.
- `specs/`, `incidentes/` e `.claude/agent-memory/` vão para o git. `uat/` não.

## Ajustando para o seu time

Os prompts são um ponto de partida. Adapte ao stack, aos padrões e à infra de vocês.

- Edite os arquivos deste repositório e rode `instalar-global` de novo. Não edite direto em `~/.claude/agents`, senão a próxima instalação sobrescreve.
- Se os ciclos estão longos, quase sempre é um validador marcando SUGESTÃO como BLOQUEANTE. Ajuste o prompt dele.
- Se os testes do QA saem errados com frequência, o problema costuma estar na spec (critério vago), não no QA.
- Para tarefas independentes em paralelo, acrescente `isolation: worktree` no frontmatter do `implementador`. Cada execução ganha um worktree próprio e você faz o merge depois. Comece sem isso.
- `maxTurns` nos validadores é um teto de segurança. Se algum parar antes de terminar, aumente.

## Lore (opcional)

O `/autonomo` e o `CLAUDE.md` têm passos que usam o Lore, um MCP de memória e correio entre sessões do Claude que eu uso no meu grupo. Se ele não estiver conectado, esses passos são simplesmente pulados e o resto funciona igual.

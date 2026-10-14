# Kit: time de agentes (Core - Sec e Falhas)

## O time
| Agente | Modelo | Quando roda | Edita? |
|---|---|---|---|
| `/spec` (comando) | o da sessão | Quando a demanda chega como ideia. Entrevista o humano. Na primeira vez em um repo, faz a entrevista inicial do projeto. | `specs/DECISOES.md` |
| `/autonomo` (comando) | o da sessão | Quando o humano quer passar o trabalho e só ver pronto. Os agentes estudam o pedido, a sessão pergunta TODAS as decisões do humano numa rodada só no começo e depois o time vai até o critério de pronto sem perguntar. | `specs/MANDATO.md`, `REGISTRO.md`, `PENDENTES.md` |
| `explorador` | haiku | Passo 0, sempre. Mapeia a área da demanda para o refinador. | não |
| `refinador-tecnico` | opus | Escreve a spec fechada em `specs/<nome>.md` e registra decisões globais em `DECISOES.md`. | só `specs/` |
| `arquiteto` | opus | Revisa a spec, antes do código. | não |
| `qa` | sonnet | Duas vezes por tarefa: escreve os testes de aceite antes do implementador e valida depois. | só arquivos de teste |
| `implementador` | sonnet | Uma tarefa por vez. Faz os testes do QA passarem. Único que edita código de produção. | sim |
| `code-reviewer` | sonnet | Por tarefa, em paralelo com o QA. | não |
| `seguranca` | opus | Uma vez por demanda, ao final. | não |
| `watch` | sonnet | Uma vez por demanda. UAT via MCP do Playwright ou via API. | só `uat/` |
| `investigador-de-falhas` | opus | Antes de corrigir qualquer falha. Memória de incidentes em `.claude/agent-memory/`. | só `incidentes/` |

## Estrutura do kit
```
global/agents/         agentes, vão para ~/.claude/agents/
global/skills/spec/    comando /spec, vai para ~/.claude/skills/spec/
global/skills/autonomo/ comando /autonomo e os modelos de MANDATO, REGISTRO e PENDENTES
repo/CLAUDE.md         fluxo e regras, vai para a raiz de cada repositório
repo/specs/DECISOES.md ledger de decisões do projeto, vai para cada repositório
instalar-global.*      instala agentes, comando e MCP do Playwright (uma vez por máquina)
instalar-no-repo.*     prepara um repositório (CLAUDE.md, specs/, incidentes/, .gitignore)
```

## Instalação
1. Uma vez por máquina: `.\instalar-global.ps1` (Windows) ou `./instalar-global.sh` (Mac/Linux). Também configura o MCP do Playwright no escopo do usuário.
2. Em cada repositório: `.\instalar-no-repo.ps1 C:\repo` ou `./instalar-no-repo.sh /repo`. Commite o que ele criou.
3. Abra o Claude Code no repositório, rode `/agents` para ver os 9 agentes e digite `/spec` para conferir o comando.
4. Preencha "Como rodar a aplicação" no CLAUDE.md, ou deixe o `/spec` perguntar na primeira entrevista.

Os agentes são globais, mas o CLAUDE.md é por repositório de propósito: assim o fluxo só vale onde o time quiser, e não em todo projeto pessoal da máquina.

## Como chamar
"/spec quero que o cliente consiga salvar carrinho para depois" (ele vai perguntar antes de escrever).
"Use o explorador e depois o refinador-tecnico para a issue #123, e siga o fluxo do CLAUDE.md."
"Use o investigador-de-falhas para o alerta X (log em anexo)."
"/autonomo quero um app de agendamento para barbearias" (ele estuda, pergunta tudo de uma vez, e depois só volta com o trabalho pronto).

## Modo autônomo (/autonomo)
1. Varredura: explorador, refinador-tecnico (rascunho com as perguntas abertas), arquiteto e, se houver login, pagamento ou dado pessoal, seguranca. Com o Lore conectado, lê também a memória do grupo e do projeto e busca o que outros projetos já decidiram.
2. Uma rodada de perguntas: tudo o que é do humano (negócio, escopo, nome público, gasto, contas, produção, o que é difícil de desfazer), mais critério de pronto, fora do escopo, git, limites e quem avisar. As escolhas técnicas óbvias aparecem como lista para vetar.
3. `specs/MANDATO.md` com as respostas; specs fechadas e aprovadas pelo arquiteto; "Posso soltar o time?".
4. Execução pelo fluxo do CLAUDE.md, seção "Modo autônomo": pergunta nova vira decisão registrada em `specs/REGISTRO.md`; o que só o humano pode fazer vai para `specs/PENDENTES.md` e o trabalho segue no resto.
5. Fim quando o critério de pronto estiver verificado (ou só restarem pendências): Resultado no mandato, commit, Lore atualizado e carta para quem o mandato manda avisar.
Na volta, leia o Resultado do mandato e as entradas do REGISTRO marcadas "Revisar: sim".

## Plano para esta semana (gastar os tokens aprendendo)
- Dia 1: cada pessoa escolhe uma issue real, pequena, e roda o fluxo completo.
- Dia 2-3: anote onde o time errou ou travou. Ajuste o prompt do agente responsável no kit e rode `instalar-global` de novo.
- Dia 4: uma demanda maior, deixando rodar sozinho (sessões em paralelo).
- Dia 5: 30 min de troca: o que mudaram nos prompts e por quê. O kit fica versionado no git.

## Dicas
- Opus planeja, revisa spec e investiga; Sonnet executa e valida; Haiku explora. Equilíbrio entre qualidade e custo.
- Só BLOQUEANTE reprova. Se os ciclos estiverem longos, quase sempre é validador marcando SUGESTÃO como BLOQUEANTE: ajuste o prompt dele.
- QA escreve os testes de aceite antes do código. Se os testes dele saírem errados com frequência, o problema está na spec (critério vago), não no QA.
- Tarefas em paralelo: quando uma spec tiver tarefas independentes, acrescente `isolation: worktree` no frontmatter do `implementador`. Cada execução ganha um worktree git próprio e você faz o merge depois. Comece sem isso; ligue quando a fila de tarefas independentes incomodar.
- `maxTurns` nos validadores é um teto de segurança. Se algum parar antes de terminar, aumente.
- Os prompts são ponto de partida: adaptem ao stack, aos padrões e à infra da Tray.

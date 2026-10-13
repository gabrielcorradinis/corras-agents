# Fluxo do time de agentes

## Como rodar a aplicação
<!-- PREENCHER: comandos para subir o projeto, rodar testes e URL local. O Watch depende disso. O /spec preenche na primeira entrevista se estiver vazio. -->

## Humano de escalada
Gabriel. Todo ponto em que o fluxo diz "escale ao humano" é com ele.

## Escala de severidade (vale para todos os validadores)
- BLOQUEANTE: impede a entrega. É o único nível que reprova.
- IMPORTANTE: precisa ser resolvido, mas pode entrar como pendência listada no PR.
- SUGESTÃO: fica a critério do humano.

## Fluxo padrão para uma demanda
0. Se a demanda chegou como ideia ou pedido solto, rode `/spec`. Ele entrevista o humano, chama explorador, `refinador-tecnico` e `arquiteto`, e entrega a spec aprovada. Pule para o passo 3.
1. `explorador` mapeia a área da demanda.
2. `refinador-tecnico` gera a spec em `specs/`. Se ele listar perguntas, pare e pergunte ao humano. Em seguida `arquiteto` revisa a spec. Se reprovar, volta ao refinador (limite: 2 vezes; depois, humano).
3. Para cada tarefa da spec:
   a. `qa` (momento 1) escreve os testes de aceite da tarefa. Eles devem falhar.
   b. `implementador` faz os testes passarem e escreve os unitários.
   c. Em paralelo, `qa` (momento 2) e `code-reviewer` validam a tarefa.
   d. Se houver BLOQUEANTE, junte os apontamentos sem duplicar, resolva conflitos entre validadores e devolva ao `implementador`. Atualize a seção Status da spec (rodada e pendências). Limite: 5 rodadas por tarefa; depois, pare e escale ao humano.
4. Com todas as tarefas aprovadas, rode uma vez por demanda, em paralelo: `seguranca` e `watch`. Se houver BLOQUEANTE, volta ao passo 3d. O contador de rodadas continua o mesmo.
5. Só então abra o PR, com: resumo da spec, resultado de cada validador, lista de IMPORTANTE em aberto e docs atualizados.

## Fluxo para falhas
1. `investigador-de-falhas` primeiro. Sem entendimento e reprodução, não há correção.
2. Se for instabilidade externa, registre e encerre.
3. Se for bug, o relatório vira entrada para o `refinador-tecnico` e segue o fluxo padrão a partir do passo 1.

## Regras
- Só o implementador edita código de produção. QA grava só em arquivos de teste, refinador só em `specs/`, investigador só em `incidentes/`, watch só em `uat/`.
- O implementador só toca os arquivos listados na tarefa e não altera os testes de aceite do QA.
- A partir da rodada 2, validador não levanta apontamento novo sobre código que não mudou, salvo CRÍTICO de segurança.
- Decisões de negócio e de ambiente da empresa são do humano. Decisões que valem para o projeto inteiro ficam registradas em `specs/DECISOES.md`.
- `specs/`, `incidentes/` e `.claude/agent-memory/` vão para o git. `uat/` não.

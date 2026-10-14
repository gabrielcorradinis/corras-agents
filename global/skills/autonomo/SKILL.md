---
name: autonomo
description: Modo autônomo do time de agentes. Os agentes estudam o pedido e o projeto, a sessão junta TODAS as decisões que são do humano e pergunta tudo numa rodada só no começo, grava o mandato em specs/MANDATO.md e depois o time desenvolve sozinho até o critério de pronto, registrando cada decisão que tomar em specs/REGISTRO.md e o que só o humano pode fazer em specs/PENDENTES.md. Use quando o humano disser que quer passar o trabalho e só ver pronto ("vai até o fim", "modo autônomo", "/autonomo <ideia>").
---
# /autonomo: perguntar tudo no começo, depois ir até o fim

O humano quer conversar uma vez, no começo, e receber o trabalho pronto. Seu trabalho tem duas metades:
1. Antes de soltar o time: descobrir com os agentes todas as decisões que são dele e perguntar todas de uma vez.
2. Depois: coordenar o fluxo do CLAUDE.md sem voltar a perguntar, até cumprir o critério de pronto.

Os modelos dos arquivos estão em `modelos/` ao lado deste SKILL.md (`~/.claude/skills/autonomo/modelos/`). Se o repositório ainda não tem `CLAUDE.md` do time nem `specs/DECISOES.md`, avise o humano que falta rodar o `instalar-no-repo` e pare; é o único caso em que esta skill para antes da varredura.

## Fase 1: varredura (o humano ainda não é chamado)
1. Contexto que já existe:
   - Se o MCP do Lore estiver conectado: `caixa`; `memoria` do projeto "grupo" (padrão de trabalho do humano, vale em tudo) e do projeto desta pasta, se existir; `buscar` com o tema do pedido para ver o que outros projetos já decidiram.
   - `specs/DECISOES.md`, as specs existentes, README e docs de estado do repositório.
2. Rode o `explorador` sobre o projeto inteiro (se o repositório está vazio, sobre o ambiente: linguagem, ferramentas instaladas, como se roda e testa). Peça a lista "perguntas que só o humano pode responder".
3. Rode o `refinador-tecnico` em modo varredura (diga isso no brief): rascunho da spec do pedido inteiro em `specs/<nome>.md`, com as escolhas que dá para fazer sozinho já feitas e, na seção "Perguntas para o humano", cada ponto aberto com opções, recomendação, impacto e se dá para desfazer depois. Pedido grande: uma spec por entrega, na ordem em que serão feitas.
4. Rode o `arquiteto` sobre o rascunho, pedindo além da revisão normal a lista do que ficou sem decisão. Rode o `seguranca` também se o pedido tem login, pagamento, dado pessoal ou integração externa, pedindo só as decisões que precisam ser tomadas (não uma revisão de código).
5. Consolide. Junte as perguntas dos agentes, tire as repetidas, tire as que o código, o Lore ou `DECISOES.md` já respondem e separe em dois grupos:
   - **Do humano**: regra de negócio, escopo e prioridade, nome público, texto e marca, gasto ou serviço pago, conta em serviço externo, segredo, deploy e dado de produção, o que não pode mudar, e qualquer coisa difícil de desfazer.
   - **Do time**: técnica, com uma resposta claramente melhor ou já usada no projeto ou no grupo. Essas não viram pergunta; viram lista para o humano vetar.

## Fase 2: uma rodada de perguntas
- Use a ferramenta de perguntas (AskUserQuestion) quando existir: até 4 perguntas por chamada, 2 a 4 opções cada, a sua recomendação em primeiro com "(Recomendado)" e o porquê na descrição. Faça quantas chamadas forem precisas, mas tudo nesta rodada. Sem a ferramenta, uma lista numerada com as opções.
- Sempre inclua, mesmo que ninguém tenha levantado:
  - **Critério de pronto**: proponha itens verificáveis ("o fluxo X funciona no navegador", "testes verdes", "publicado no ambiente de dev") e peça para ajustar.
  - **Fora do escopo**: o que não fazer agora.
  - **Git**: commit e push na main a cada entrega testada, ou branch com PR no fim.
  - **Limites**: o que o time nunca faz sem ele (por padrão: gastar, criar conta, digitar senha, deploy ou dado de produção, publicar em loja, apagar o que não se recupera).
  - **Aviso**: quem avisar no Lore quando terminar ou travar.
- Por último, mostre a lista "Do time" e pergunte numa pergunta só se ele veta alguma.
- Não economize perguntas que são dele. Depois desta rodada não há outra.

## Fase 3: mandato
1. Copie `modelos/MANDATO.md`, `modelos/REGISTRO.md` e `modelos/PENDENTES.md` para `specs/` (não sobrescreva arquivo que já existe; acrescente). Preencha o MANDATO com o objetivo, o critério de pronto, o fora do escopo, as decisões do humano (com a pergunta e a resposta), as do time que ele não vetou, os limites, a política de git e o aviso.
2. Devolva ao `refinador-tecnico` as respostas para fechar as specs (sem perguntas abertas) e passe pelo `arquiteto` de novo. O que valer para o projeto inteiro vai para `specs/DECISOES.md`.
3. Mostre ao humano um resumo curto (onde está o mandato, quantas specs e tarefas, o critério de pronto) e pergunte uma última vez: "Posso soltar o time?". Com o sim, mude o Status do MANDATO para "em execução", faça commit de `specs/` e siga.

## Fase 4: execução sem perguntas
Siga o fluxo padrão do CLAUDE.md com as regras da seção "Modo autônomo" dele. Em resumo:
- Toda pergunta nova vira decisão sua (ou do agente que a levantou): prefira a opção que dá para desfazer, a mais barata e a que o projeto já usa; registre em `specs/REGISTRO.md` e siga.
- O que só o humano pode fazer vai para `specs/PENDENTES.md`, com o que o time fez enquanto isso, e o trabalho continua no que não depende dele.
- Limites de rodada (arquiteto 2 vezes, 5 rodadas por tarefa) não chamam o humano: a sessão decide (simplificar a tarefa, trocar a abordagem, ou entregar com ressalva), registra e segue.
- A cada tarefa aprovada, atualize o Status do MANDATO (o que está pronto, o que falta). A cada spec entregue, se o Lore estiver conectado: `anotar` estado e decisões na memória do projeto e `passar`.
- Se a sessão estiver perto do limite de contexto ou de uso, deixe o Status do MANDATO e o `passar` em dia antes de continuar: quem retomar começa por eles.

## Fase 5: fim
O trabalho termina quando:
- todos os itens do critério de pronto foram verificados (pelo `qa`, pelo `watch` ou por comando com saída conferida), ou
- tudo o que falta depende de `PENDENTES.md`.

Então: preencha a seção Resultado do MANDATO (cada item do critério com como foi verificado; o que ficou pendente e por quê; as decisões do REGISTRO que merecem revisão dele), mude o Status para "pronto" ou "parado em pendências", faça o commit final conforme a política de git, atualize o Lore (`anotar` e `passar`) e mande carta pelo Lore a quem o MANDATO manda avisar. No chat, entregue o mesmo resumo em poucas linhas.

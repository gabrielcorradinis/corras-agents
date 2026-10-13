---
name: spec
description: Entrevista o humano sobre uma ideia ou demanda, questionando e oferecendo opções, até fechar as decisões. Depois aciona explorador, refinador-tecnico e arquiteto. Use quando o humano trouxer uma ideia, um pedido solto ou uma issue sem detalhe suficiente. Na primeira vez em um repositório, faz a entrevista inicial do projeto.
---
# /spec: da ideia à especificação

Você conduz uma entrevista curta com o humano antes de qualquer spec ser escrita. O objetivo é que ele tome as decisões ciente do que já foi decidido no projeto.

## Primeira vez no repositório
Se `specs/DECISOES.md` não existir ou estiver só com os comentários de exemplo, faça a entrevista inicial do projeto antes da demanda:
1. Rode o `explorador` pedindo um levantamento do projeto inteiro: stack, framework, biblioteca de validação, padrão de erro, acesso a dados, convenções de tabela, como se roda e testa.
2. Para cada item que ele encontrou, pergunte ao humano confirmando: "Encontrei X no código. É o padrão do projeto, ou é legado que não deve ser seguido?". Ofereça opções. Nunca registre uma decisão só porque está no código.
3. Pergunte o que o código não mostra: regras de mensagem ao usuário, o que nunca pode mudar, dependências com outros times.
4. Grave as respostas confirmadas em `specs/DECISOES.md`, uma linha por decisão, com a origem "entrevista inicial". Se a seção "Como rodar a aplicação" do CLAUDE.md estiver vazia, preencha com o que o explorador encontrou e o humano confirmou.

## Antes de perguntar sobre a demanda
1. Leia `specs/DECISOES.md`.
2. Liste os arquivos em `specs/` e leia as seções Decisões das specs que tocam a mesma área da ideia.
3. Rode o `explorador` sobre a área da demanda.

## Como entrevistar
- Pergunte em blocos de no máximo 3 perguntas por vez. Espere a resposta antes do próximo bloco.
- Toda pergunta vem com opções e com a sua recomendação em primeiro lugar, explicando o porquê em uma linha.
- Quando o ponto já tiver decisão anterior, apresente assim: "Na spec <nome> vocês decidiram <X>. Mantém, ou muda para este caso?". Nunca contrarie uma decisão anterior em silêncio.
- Não pergunte o que o explorador já descobriu no código. Pergunte o que só o humano sabe: regra de negócio, prioridade, prazo, ambiente, o que pode e o que não pode mudar.
- Cubra, no mínimo: objetivo e quem usa; o que fica fora do escopo; regras de negócio e casos de borda; tela ou API (e os estados de tela, se houver); dados e integrações; o que define que ficou pronto.
- Pare de perguntar quando as respostas deixarem de mudar o desenho. Entrevista longa demais é tão ruim quanto spec vaga.

## Ao fechar
1. Mostre um resumo das decisões tomadas, em lista, e peça confirmação em uma pergunta só.
2. Acione o `refinador-tecnico` passando o pedido original, o mapa do explorador e o resumo confirmado. Ele escreve `specs/<nome>.md`.
3. Acione o `arquiteto` sobre a spec gerada. Se reprovar, devolva ao refinador. Repita no máximo 2 vezes; depois, traga ao humano.
4. Peça ao refinador para acrescentar em `specs/DECISOES.md` toda decisão desta spec que vale para o projeto inteiro, e não só para esta demanda.
5. Diga ao humano onde está a spec e que o próximo passo é o fluxo padrão do CLAUDE.md.

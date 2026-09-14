---
name: valida-skill-cro
description: Avalia a skill de processo de CRO que o aluno acabou de criar com o Skill Creator, nota por critério nomeado e aponta o que falta responder — sem preencher a lacuna por ele. Use quando o usuário disser "validar minha skill", "avaliar a skill que eu criei", "dar nota na skill", "essa skill tá boa?" ou "rodar o validador".
---

# Valida Skill CRO — nota e lacunas da skill do aluno

## Tarefa

Receber a skill de processo que o aluno acabou de gerar com o Skill Creator,
avaliar em 5 critérios nomeados e devolver uma nota por critério, uma nota
final e — para cada ponto que faltar — a pergunta exata que a skill não
responde. Esta skill não corrige a skill do aluno: ela é o antipattern que
confere se a metodologia dele está completa.

## Input necessário

Peça ao aluno:
1. O caminho do arquivo `SKILL.md` que ele gerou, ou o conteúdo colado
   direto no chat.

Se vier só um pedaço (por exemplo, sem a seção de passos), avalie apenas o
que foi entregue e diga explicitamente quais critérios ficaram sem material
suficiente — não peça para o aluno completar antes de rodar; a nota parcial
também é informação.

## Os 5 critérios

Cada um vem de uma peça específica do que uma skill de processo precisa ter,
nas próprias palavras usadas na definição do exercício: a skill é uma
receita — **ingredientes** (fontes de dado) e **modo de preparo** (sequência
de passos) — e o processo por trás dela tem **cargos**, **handoffs** e
**entregáveis** nomeados.

| # | Critério | Pergunta-guia |
|---|---|---|
| 1 | Papéis | A skill nomeia os cargos ou papéis das pessoas envolvidas no processo? |
| 2 | Handoffs | A skill nomeia as passagens entre papéis — quem entrega para quem, e em que momento? |
| 3 | Entregáveis | A skill nomeia o entregável de cada etapa — o que sai de cada handoff? |
| 4 | Ingredientes | A skill diz de onde vem o dado que alimenta cada etapa, com fonte nomeada (não "os dados da empresa")? |
| 5 | Modo de preparo | A sequência de passos é executável — dá para seguir passo 1, passo 2, passo 3 — ou é vaga ("analisar", "otimizar", "melhorar")? |

## Escala

Cada critério recebe 0, 1 ou 2:

- **0 — ausente.** Não aparece em nenhum lugar da skill.
- **1 — parcial.** Aparece, mas de forma genérica ou incompleta (por
  exemplo, cita "o time de CRO" sem nomear os cargos dentro dele, ou cita
  "os dados" sem dizer de onde vêm).
- **2 — completo.** Nomeado e específico o suficiente para outra pessoa
  executar sem perguntar de volta.

**Nota final:** soma dos 5 critérios, de 0 a 10.

- **8–10** — a skill descreve um processo executável; está pronta para virar
  a skill de execução do time.
- **4–7** — a skill tem processo real por trás, mas com lacunas que impedem
  que outra pessoa a rode sem perguntar de volta.
- **0–3** — o que foi descrito ainda não é um processo (ou é a operação de
  uma ferramenta, não um processo de negócio — ver sinal de alerta abaixo).

## Sinal de alerta — ferramenta em vez de processo

Uma skill pode ter uma sequência de passos claramente executável ("abra o
relatório X, clique em Y, exporte Z") e ainda assim pontuar 0 em Papéis,
Handoffs e Entregáveis. Isso não é um empate entre critérios — é o sinal de
que o aluno descreveu como usar uma ferramenta, não o processo de CRO da
empresa dele. Diga isso explicitamente quando acontecer: "Modo de preparo
pontuou alto porque os cliques são claros, mas isso descreve uma ferramenta,
não o processo — falta dizer quem faz isso, para quem entrega e o que essa
pessoa faz com o resultado."

## Regras de avaliação

- Toda nota abaixo de 2 vem acompanhada da **pergunta específica que a skill
  não responde** — nunca da observação genérica "está vago". Exemplo correto:
  "não diz quem recebe a lista de hipóteses depois de priorizada" — e não
  "falta detalhar handoffs".
- **Nunca invente conteúdo para preencher a lacuna do aluno.** Se a skill não
  diz de onde vem o dado, aponte a ausência — não sugira uma fonte plausível
  (não escreva "provavelmente vem do GA4"). O aluno tem que sair sabendo o
  que falta no processo dele, não recebendo um processo que você inventou.
- Cite o trecho da skill que sustenta cada nota 1 ou 2, do mesmo jeito que
  uma nota de heurística de página precisa citar o que foi visto na tela.
- Não avalie estilo de escrita, formatação de Markdown ou tamanho do
  arquivo. Os 5 critérios são os únicos pontos de avaliação.

## Output

| Critério | Nota (0-2) | O que sustenta a nota / o que falta |
|---|---|---|
| Papéis | ... | ... |
| Handoffs | ... | ... |
| Entregáveis | ... | ... |
| Ingredientes | ... | ... |
| Modo de preparo | ... | ... |

**Nota final:** X/10 — [faixa: pronta / incompleta / ainda não é um processo]

**Sinal de alerta (ferramenta vs. processo):** [presente / ausente — e por quê]

**As 2 lacunas mais urgentes:** [as perguntas específicas, na ordem em que
o aluno deveria resolvê-las antes de rodar o Skill Creator de novo]

## Calibragem — como o facilitador confere antes do evento

Antes de usar em sala, rode este validador contra três skills de teste e
confirme que a nota final separa as três:

1. **Uma skill de processo completa** — papéis, handoffs, entregáveis,
   fontes de dado e passos executáveis, todos nomeados. Deve ficar em 8–10.
2. **Uma skill vaga** — fala em termos genéricos ("o time analisa os dados
   e otimiza o processo"), sem nomear nada. Deve ficar em 0–3, com os 5
   critérios reprovados e uma pergunta específica em cada linha.
3. **Uma skill que descreve uma ferramenta em vez de um processo** —
   sequência de cliques numa interface, sem papel, handoff ou entregável
   nomeado. Deve disparar o sinal de alerta da seção acima: nota alta em
   Modo de preparo, nota baixa nos outros quatro critérios.

Se as três notas não se separarem assim — por exemplo, se a skill de
ferramenta pontuar bem no total, ou se a skill vaga passar de 3 — ajuste a
redação dos critérios ou da escala antes do dia do evento. Não ajuste o
validador durante a aula: o critério tem que estar fechado antes do aluno
rodar.

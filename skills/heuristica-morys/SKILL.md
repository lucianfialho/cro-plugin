---
name: heuristica-morys
description: Varredura de página nas 7 dimensões da heurística de André Morys (Relevância, Confiança, Orientação, Estímulo, Segurança, Conveniência, Confirmação). Diagnostica onde a página perde conversão antes de propor hipótese. Use quando o usuário disser "analisar página", "heurística", "diagnóstico de CRO", "onde estou perdendo conversão".
---

# Heurística de Morys — varredura em 7 dimensões

Você é um estrategista de CRO. Avalia páginas usando a heurística de André Morys.

## Input necessário

Antes de começar, peça ao usuário:
1. A URL da página
2. Um print da página (acima da dobra, desktop e mobile se possível)
3. Qual é a conversão desejada nessa página
4. Quem é o público que chega nela

Se faltar o print, diga que a análise fica limitada ao que a URL sugere e
peça confirmação antes de seguir. Não invente o que está na página.

## As 7 dimensões

Avalie cada uma de 1 a 5, com a pergunta-guia:

| # | Dimensão | Pergunta |
|---|---|---|
| 1 | Relevância | A proposta de valor ajuda a resolver as dores do cliente? |
| 2 | Confiança | São usadas celebridades ou autoridades como depoimentos? |
| 3 | Orientação | O CTA principal é visível e fácil de achar? |
| 4 | Estímulo | A percepção de preço e risco está bem projetada? |
| 5 | Segurança | Existe uma página de perguntas frequentes? |
| 6 | Conveniência | Os formulários realmente são convenientes? |
| 7 | Confirmação | A página mostra razões racionalmente boas para a decisão de compra? |

## Regras de avaliação

- Cada nota precisa citar **o que você viu na página**. "Nota 2 em Orientação"
  sem dizer qual CTA e onde ele está é uma nota inútil.
- Se você não consegue avaliar uma dimensão com o material fornecido, escreva
  `n/d` e diga o que precisaria para avaliar. Nunca chute uma nota.
- Não sugira solução ainda. Esta skill diagnostica. A hipótese vem depois.

## Output

| Dimensão | Nota (1-5) | Achado | Evidência na página |
|---|---|---|---|
| ... | ... | ... | ... |

**Score total:** X/Y (Z dimensões n/d) — Y é 5 × número de dimensões
avaliadas (35 menos 5 para cada dimensão marcada `n/d`). Uma dimensão n/d
sai do denominador: ela reflete falta de material do aluno, não falha da
página, e não pode ser contada como nota zero.

**As 2 dimensões mais fracas:** [nomes] — são as candidatas a virar hipótese.

Termine com: "Rode `hipotese-estruturada` sobre a dimensão mais fraca."

## Camada avançada (só no Claude Code)

Se `agent-browser` estiver disponível, capture a página em vez de pedir print:

    agent-browser open <url>
    agent-browser wait --load networkidle
    agent-browser screenshot /tmp/morys-desktop.png
    agent-browser snapshot -i

Se o comando não existir, siga com o print colado pelo usuário — a análise
das 7 dimensões não depende disso.

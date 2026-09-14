---
name: ice-score
description: Prioriza backlog de hipóteses de CRO com ICE Score (Impacto × Confiança × Facilidade, 1-10 cada). Penaliza hipóteses sem evidência. Use quando o usuário disser "priorizar", "o que testar primeiro", "ICE", "backlog de testes".
---

# ICE Score — priorização de backlog

Prioriza hipóteses de CRO com ICE Score. Uma lista de ideias sem prioridade
é só uma lista de desejos.

## A fórmula

    ICE = Impacto × Confiança × Facilidade

Cada eixo vai de 1 a 10. Score final vai de 1 a 1000.

| Eixo | Pergunta | Nota 1 | Nota 10 |
|---|---|---|---|
| Impacto | Se der certo, quanto move a métrica de negócio? | mexe em métrica secundária | mexe em receita direta |
| Confiança | Quão forte é a evidência de que vai dar certo? | achismo | teste anterior no mesmo funil |
| Facilidade | Quanto custa colocar no ar? | precisa de time, sprint, backend | troca de copy no CMS |

## Regras

- **Hipótese com `⚠️ FALTA EVIDÊNCIA` tem Confiança no máximo 3.** Sem dado,
  a confiança é opinião. Marque isso na tabela e diga por quê.
- Peça ao usuário a nota de **Facilidade** — só quem conhece a stack sabe o
  custo real. Se ele não souber, marque `?` e diga que o dev precisa estimar.
- Impacto e Confiança você pode propor, mas justificando cada nota em uma linha.

## Aviso obrigatório no output

Termine sempre com esta citação literal do material de referência (Taciana
Serafim, CRO AI DAY):

> "O score explicita critérios e organiza o backlog — use para ranking
> relativo, não como veredito. O Dev participa estimando esforço e risco
> técnico."

## Output

| # | Hipótese | I | C | F | ICE | Status da evidência |
|---|---|---|---|---|---|---|
| 1 | ... | 8 | 6 | 7 | 336 | ✅ evidência real |
| 2 | ... | 9 | 3 | 4 | 108 | ⚠️ FALTA EVIDÊNCIA |

**Recomendação:** comece pela #1. Justificativa em uma linha.

## Persistência (só no Claude Code)

Salve o backlog ranqueado em `backlog-cro.md` no diretório atual, com a data
de geração no topo. Se o arquivo já existir, acrescente uma nova seção datada
em vez de sobrescrever — o histórico de priorização é o que mostra se a
Confiança das hipóteses melhorou com o tempo.

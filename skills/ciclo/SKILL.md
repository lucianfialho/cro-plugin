---
name: ciclo
description: Roda o ciclo de CRO como orquestração — despacha os sub-agentes analista, QA e dev em sequência, cada um num contexto isolado, e junta os três relatórios. Use quando o usuário disser "roda o ciclo", "quero testar essa página", "passa pelo time", "do diagnóstico ao teste" ou rodar /cro-ai-day:ciclo.
context: fork
agent: cro-ai-day:orquestrador
background: false
argument-hint: [página ou etapa da jornada, URL opcional]
---
Rode o ciclo para: $ARGUMENTS

Você é o agente `orquestrador` do plugin cro-ai-day, em Haiku, num contexto
isolado da conversa. Siga o seu próprio prompt de sistema: Passo 0 (existe
CRO.md?), Passo 1 (o alvo acima), Passos 2 a 4 (analista → qa → dev, um por
vez, briefs de até 10 linhas apontando pra arquivos) e Passo 5 (resumo de até
10 linhas com os três caminhos de relatório). Devolva só o resumo.

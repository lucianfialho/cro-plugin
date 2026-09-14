---
name: metodologia-exemplo
description: Exemplo de skill de metodologia — o processo de CRO da Loja Aurora (fictícia) descrito como receita, com papéis, handoffs e entregáveis em cada um dos 7 passos do ciclo. Serve de modelo do que você vai escrever para o seu time. Use quando o usuário disser "como é o processo de CRO", "rodar o ciclo", "qual a metodologia do time" ou "me mostra um exemplo de skill de metodologia".
---

# Metodologia de CRO — Loja Aurora (exemplo)

> **Este é o slot da sua skill.** A Loja Aurora não existe: é um time fictício
> de e-commerce de moda. Substitua esta pasta pela skill de metodologia do seu
> próprio time (veja o README do plugin) e rode `valida-skill-cro` nela.

## O time — 4 posições, um mesmo gol

| Papel | Pergunta que faz | Nome do cargo na Aurora |
|---|---|---|
| Digital Analytics | "O que está acontecendo e onde está o problema?" | Analista de dados |
| Estratégia de CRO | "Por que isso acontece e o que podemos mudar?" | Analista de CRO |
| Dev / Experimentação | "Como tornar isso tecnicamente testável?" | Dev de front |
| QA | "A implementação está correta antes de subir?" | QA de experimentação |
| Negócio | "Implementar, iterar, investigar, abandonar ou nova hipótese?" | Gestor de e-commerce |

Analytics transforma comportamento em evidência; CRO transforma evidência em
hipótese; Dev transforma hipótese em experimento. Não são fronteiras rígidas.

## O ciclo — 7 passos, com handoff e entregável

| # | Passo | Quem executa | Entregável | Passa para |
|---|---|---|---|---|
| 1 | Coleta de Dados | Analista de dados | Extração quanti (GA4, últimos 28 dias) + quali (12 sessões do Clarity, 1 pesquisa on-site) | Analista de CRO |
| 2 | Análise | Analista de dados + Analista de CRO | Lista de achados com fonte nomeada e recorte de segmento | Analista de CRO |
| 3 | Hipóteses | Analista de CRO | Hipóteses no template `Se [mudarmos X], para [segmento Y], então [resultado Z], porque [evidência]` | Time (reunião de priorização) |
| 4 | Priorização | Analista de CRO + time | Backlog ranqueado por ICE (Impacto × Confiança × Facilidade); Dev estima esforço e risco técnico | Dev de front |
| 5 | Testes | Analista de CRO + Dev + QA | Variante B no ar: código, audiência, distribuição, eventos e checklist pré-Start aprovado pelo QA | Analista de dados |
| 6 | Relatórios | Analista de dados + Analista de CRO | Leitura validada (SRM checado) + segmentos + uma das 5 decisões escrita | Gestor de e-commerce |
| 7 | Escala | Gestor de e-commerce + Dev | Mudança implementada em produção e aprendizado no repositório de testes | Analista de dados (volta ao passo 1) |

O passo 7 alimenta o passo 1: o aprendizado de uma rodada define onde a
próxima começa.

## Ingredientes — de onde vem cada dado

| Fonte | Alimenta o passo | Quem tem acesso |
|---|---|---|
| GA4 (propriedade "Aurora Web") | 1, 2, 6 | Analista de dados |
| Microsoft Clarity (gravações e heatmaps) | 1, 2 | Analista de dados, Analista de CRO |
| Pesquisa on-site (Hotjar, 1 pergunta no checkout) | 1, 3 | Analista de CRO |
| Ferramenta de experimentação (VWO) | 5, 6 | Dev de front, QA |
| Planilha "Backlog CRO Aurora" | 3, 4, 7 | Todos |

Sem fonte nomeada, o achado não vira hipótese: volta para o passo 1.

## Modo de preparo — a rodada quinzenal

1. **Segunda, semana 1** — Analista de dados exporta o funil do GA4 do período
   e marca as 3 maiores quedas por etapa e por device.
2. **Terça** — Analista de dados e Analista de CRO cruzam as quedas com as
   gravações do Clarity e fecham a lista de achados com fonte.
3. **Quarta** — Analista de CRO escreve as hipóteses no template. Achado sem
   evidência de dado real não vira hipótese.
4. **Quinta** — reunião de priorização com o time: ICE de cada hipótese; o Dev
   estima esforço e risco. Sai o top 3 do backlog.
5. **Sexta a terça, semana 2** — Dev constrói a variante, configura audiência e
   distribuição e instrumenta os eventos nas duas versões.
6. **Quarta, semana 2** — QA roda o checklist dos 8 itens pré-Start. Não existe
   "quase pronto": ou pode subir, ou não pode. Só então: START.
7. **Ao fim do teste** — Analista de dados valida SRM antes de qualquer leitura,
   quebra por segmento e escreve o relatório. O Gestor escolhe uma das 5
   decisões: implementar, iterar, investigar, abandonar ou nova hipótese.
8. **Escala** — o que foi implementado vira linha no repositório de aprendizados
   e insumo do próximo passo 1.

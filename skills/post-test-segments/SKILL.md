---
name: post-test-segments
description: Análise pós-teste A/B segmentada por device, novo vs recorrente e canal de aquisição. Revela onde o lift realmente aconteceu, em vez de ler só o agregado. Use quando o usuário disser "onde o lift aconteceu", "segmentar resultado", "análise pós-teste", "quebrar por device".
---

# Post-test segments — análise pós-teste segmentada

## Pré-condição obrigatória

Rode `srm-check` primeiro. Se o veredito for 🔴 **SRM DETECTADO**, **pare** e diga:

> Esse teste tem SRM. Segmentar um resultado inválido só produz conclusões
> inválidas mais detalhadas. Corrija a distribuição antes.

Só siga se o veredito for 🟢 **SEM SRM** ou se o usuário apontar explicitamente
um dataset válido.

## Passo 1 — resultado agregado

    duckdb data/cro-clean.db -c "
    SELECT experiment_variant,
           COUNT(DISTINCT user_pseudo_id) AS users,
           COUNT(DISTINCT CASE WHEN converted=1 THEN user_pseudo_id END) AS conv,
           ROUND(100.0*COUNT(DISTINCT CASE WHEN converted=1 THEN user_pseudo_id END)
                 /COUNT(DISTINCT user_pseudo_id),2) AS cr
    FROM events_clean WHERE experiment_variant IS NOT NULL
    GROUP BY 1 ORDER BY 1;"

## Passo 2 — por device

    duckdb data/cro-clean.db -c "
    SELECT device_category, experiment_variant,
           COUNT(DISTINCT user_pseudo_id) AS users,
           ROUND(100.0*COUNT(DISTINCT CASE WHEN converted=1 THEN user_pseudo_id END)
                 /COUNT(DISTINCT user_pseudo_id),2) AS cr
    FROM events_clean WHERE experiment_variant IS NOT NULL
    GROUP BY 1,2 ORDER BY 1,2;"

## Passo 3 — novo vs recorrente

Mesma query trocando `device_category` por `is_new_user`.

## Passo 4 — canal

Mesma query trocando `device_category` por `traffic_source`.

## Regras de leitura

- Calcule o **lift relativo** por célula: `(cr_variant - cr_control) / cr_control`.
- Uma célula com menos de 300 usuários por braço não sustenta conclusão —
  marque como `amostra insuficiente` em vez de reportar o lift.
- **Segmento com lift negativo é achado, não ruído.** Reporte junto. Um teste
  que ganha no mobile e perde no tablet é uma decisão de rollout segmentado,
  não um vencedor.
- Nunca conclua "vencedor". Conclua o que a evidência sustenta e qual decisão
  ela permite.

## Output

    ## Agregado
    | Variante | Users | Conv | CR |

    ## Por device
    | Device | Control CR | Variant CR | Lift | Amostra |

    ## Por tipo de usuário
    ...
    ## Por canal
    ...

    ## Leitura
    O ganho está concentrado em [segmento]. [Segmento] mostra perda.

    ## Decisão possível
    Winner e loser é uma leitura pobre do resultado. Todo experimento termina
    em uma decisão — e nem toda decisão é implementar. Escolha uma das cinco:

    | Decisão | Quando |
    |---|---|
    | Implementar | A evidência sustenta a mudança e os guardrails ficaram estáveis. |
    | Iterar | A direção parece certa, mas a execução pode melhorar. |
    | Investigar | A evidência não é suficiente. Precisamos entender melhor. |
    | Abandonar | A hipótese não se sustentou. Aprendemos algo sobre o usuário. |
    | Nova hipótese | O resultado revelou um comportamento que não esperávamos. |

    Recomende uma e justifique em uma linha. As cinco decisões são vocabulário
    da Taciana (slide 42) — use os nomes exatos, não sinônimos.

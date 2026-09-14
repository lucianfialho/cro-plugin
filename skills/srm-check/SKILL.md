---
name: srm-check
description: Valida Sample Ratio Mismatch em teste A/B antes de declarar resultado. Roda chi-quadrado sobre a distribuição de usuários por variante no DuckDB local. Use quando o usuário disser "SRM", "validar teste", "o teste é confiável", "posso declarar vencedor".
---

# SRM Check — validação de Sample Ratio Mismatch

## Tarefa

Verificar se o teste A/B tem SRM antes de qualquer leitura de resultado. Um
teste com SRM não tem resultado — tem um bug de distribuição.

## Passo 1 — distribuição observada

    duckdb data/cro.db -c "
    SELECT experiment_variant,
           COUNT(DISTINCT user_pseudo_id) AS users
    FROM events_clean
    WHERE event_name = 'session_start'
      AND experiment_variant IS NOT NULL
    GROUP BY 1 ORDER BY 1;"

## Passo 2 — chi-quadrado

Assumindo alocação pretendida de 50/50 (confirme com o usuário se for outra):

    python3 -c "
    obs = [<users_control>, <users_variant>]
    n = sum(obs); exp = [n/2, n/2]
    chi2 = sum((o-e)**2/e for o,e in zip(obs,exp))
    # p-valor para 1 grau de liberdade, sem dependência externa
    import math
    p = math.erfc(math.sqrt(chi2/2))
    print(f'chi2={chi2:.2f}  p={p:.6f}')
    "

## Passo 3 — veredito

| p-valor | Veredito | O que fazer |
|---|---|---|
| p < 0,01 | 🔴 **SRM DETECTADO** | Não leia o resultado. Investigue a instrumentação. |
| 0,01 ≤ p < 0,05 | 🟡 **Suspeito** | Investigue antes de decidir. |
| p ≥ 0,05 | 🟢 **SEM SRM** | Pode seguir para a análise segmentada. |

## Passo 4 — gravar o marcador (libera o hook)

O hook `sem-srm-sem-resultado` bloqueia qualquer leitura de conversão/lift
enquanto não existir `.cro/srm-ok` no projeto. **Só grave o marcador quando o
veredito for 🟢.**

    # veredito 🟢 — libera a leitura de resultado
    mkdir -p .cro
    printf 'SRM_OK  chi2=%s  p=%s  %s\n' "<chi2>" "<p>" "$(date '+%Y-%m-%d %H:%M')" > .cro/srm-ok

Se o veredito for 🟡 ou 🔴, faça o contrário — apague o marcador, porque um
teste que passou a ter SRM não pode continuar liberado:

    rm -f .cro/srm-ok

Diga ao usuário qual dos dois você fez.

## Passo 5 — se detectou SRM

Liste as causas mais comuns, nesta ordem:
1. Redirect na variante B perdendo usuários no caminho
2. Bots contados só de um lado
3. Flicker / tag disparando antes do bucketing
4. Filtro de audiência aplicado depois da alocação

Diga explicitamente: **"Esse teste não tem resultado para ler. Corrigir a
distribuição vem antes de qualquer análise de lift."**

## Output

    ## SRM Check
    | Variante | Usuários | % observado | % esperado |
    |---|---|---|---|

    chi2 = X.XX · p = 0.XXXXXX
    Veredito: 🔴/🟡/🟢

    ## Próximo passo
    ...

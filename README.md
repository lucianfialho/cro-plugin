# Plugin CRO — skills por papel do time

Plugin gratuito de CRO para o Claude Code. Doze skills organizadas pelo papel de
quem usa (analista, QA, dev), mais **três sub-agentes** — um por papel — que a
skill `/cro-ai-day:ciclo` despacha em sequência. Uma das pastas de skill está vazia de
propósito: é o slot onde entra a metodologia do **seu** time.

Versão 0.1.0 · Lucian Fialho / Métricas Boss.

## 1. Instalar

Requer Claude Code 2.1 ou mais novo. Rode os comandos **fora** do Claude Code
(`/exit` primeiro) — o plugin só passa a valer na próxima vez que o Claude
Code abrir.

```bash
claude plugin marketplace add lucianfialho/cro-plugin
claude plugin install cro-ai-day@cro-plugin
```

Esperado:

```
✔ Successfully added marketplace: cro-plugin (declared in user settings)
✔ Successfully installed plugin: cro-ai-day@cro-plugin (scope: user)
```

Conferir:

```bash
claude plugin list
claude plugin details cro-ai-day@cro-plugin
```

O `details` deve mostrar `Skills (12)` e `Agents (3)`. Depois é só abrir o
`claude` e digitar `/` — as skills aparecem com o prefixo `cro-ai-day:`.

**Teste local (a partir da pasta, sem GitHub):**

```bash
claude plugin marketplace add ./cro-plugin
claude plugin install cro-ai-day@cro-plugin
```

**Desinstalar:**

```bash
claude plugin uninstall cro-ai-day@cro-plugin
claude plugin marketplace remove cro-plugin
```

## 2. As skills, por papel

| Papel | Skill | O que faz |
|---|---|---|
| Analista | `cro-ai-day:heuristica-morys` | Varre a página nas 7 dimensões de Morys e diz onde a conversão se perde. |
| Analista | `cro-ai-day:hipotese-estruturada` | Vira o achado em hipótese no template `Se [X], para [Y], então [Z], porque [evidência]` — e trava sem evidência. |
| Analista | `cro-ai-day:ice-score` | Ranqueia o backlog por ICE (Impacto × Confiança × Facilidade) e penaliza hipótese sem dado. |
| Analista | `cro-ai-day:post-test-segments` | Quebra o resultado do teste por device, novo vs recorrente e canal, para achar onde o lift aconteceu. |
| QA | `cro-ai-day:pre-flight-check` | Roda o checklist dos 8 itens antes do Start e dá veredito: sobe ou não sobe. |
| QA | `cro-ai-day:srm-check` | Valida Sample Ratio Mismatch (chi-quadrado) antes de qualquer leitura de resultado. |
| Dev | `cro-ai-day:variante-builder` | Transforma a hipótese fechada no código da variante B (JS/CSS) e na lista de eventos a instrumentar. |
| Dev | `cro-ai-day:detecta-design-system` | Lê o site e escreve um `DESIGN.md` com paleta, tipografia e componentes reais, para a variante sair com a cara certa. |
| Setup | `cro-ai-day:cro-md` | Entrevista guiada: pasta, loja, conectores, jornada, plano de mensuração e voz do cliente. Escreve o CRO.md com as respostas e registra `@CRO.md` no CLAUDE.md. Um hook do plugin impede rodar na home, Desktop ou Downloads. |
| Metodologia | `cro-ai-day:valida-skill-cro` | Dá nota em 5 critérios na skill de processo que você escreveu e aponta a lacuna sem preenchê-la. |
| Metodologia | `cro-ai-day:metodologia-exemplo` | Exemplo do que você vai escrever: o processo de CRO de um time fictício, com papéis, handoffs e entregáveis nos 7 passos do ciclo. |
| Orquestração | `cro-ai-day:ciclo` | Despacha os sub-agentes analista → QA → dev em sequência, lê só os relatórios e para se o QA disser "não pode subir". |

## 3. Sub-agentes por papel

As skills acima são o método. Os sub-agentes são o **time**: três papéis, cada um
num contexto isolado, lendo só o que o seu papel precisa e devolvendo **um
arquivo curto** em `relatorios/`.

| Agente | Lê | Entrega | Recusa |
|---|---|---|---|
| `cro-ai-day:analista` | `CRO.md` (e `DESIGN.md`, se existir) | `relatorios/analista.md`: as 7 dimensões de Morys com evidência e `n/d`, as 2 mais fracas, e de 1 a 3 hipóteses no template com ICE. | Não propõe variante, não dá veredito de subida. |
| `cro-ai-day:qa` | `CRO.md` + `relatorios/analista.md` | `relatorios/qa.md`: os 8 itens do pre-flight marcados `ok` / `falta` / `n/d`, e o veredito "pode subir" ou "não pode subir" com o motivo. | Não reescreve a hipótese. |
| `cro-ai-day:dev` | `CRO.md`, `DESIGN.md` e `relatorios/qa.md` | `relatorios/dev.md`: o que muda, onde, como medir — e os `variante-b.*`, se pedirem. | Não age sem o "pode subir". Sem `DESIGN.md`, para. |

O `/cro-ai-day:ciclo` encadeia os três: confere o `CRO.md`, pergunta **só** qual página
atacar, despacha um agente por vez com um brief de até 10 linhas que aponta para
os arquivos, lê entre eles apenas o relatório, e para o ciclo se o QA reprovar.

**Por que isso economiza contexto:** o orquestrador nunca carrega a página, o
`CRO.md` inteiro e os três métodos na mesma janela — cada papel abre o seu
contexto, gasta o que precisa e devolve um resumo de poucas linhas. O que sobe
de volta é o relatório, não a conversa.

```
/cro-ai-day:ciclo → analista → relatorios/analista.md
           → qa       → relatorios/qa.md  ──🔴 não pode subir? para aqui
           → dev      → relatorios/dev.md
```

## 4. Plugar a sua skill de metodologia

A `metodologia-exemplo` é um exemplo genérico — o processo da Loja Aurora, que
não existe. O valor do plugin aparece quando essa pasta vira o processo do seu
time.

1. **Escreva a sua.** Use o `skill-creator` (plugin oficial) ou copie
   `skills/metodologia-exemplo/SKILL.md` como molde. Nomeie os papéis, os
   handoffs, os entregáveis de cada um dos 7 passos, as fontes de dado
   (ingredientes) e a sequência executável (modo de preparo).
2. **Valide.** Dentro do Claude Code, rode `cro-ai-day:valida-skill-cro` na sua skill.
   Nota 8–10 significa que outra pessoa do time consegue rodar o processo sem
   perguntar de volta. Abaixo disso, a skill diz qual pergunta ficou sem
   resposta.
3. **Substitua a pasta.** Troque o conteúdo de `skills/metodologia-exemplo/`
   pela sua skill (ou renomeie a pasta para o nome do seu processo — a pasta
   precisa ter o mesmo nome do campo `name` do frontmatter). Reinstale o
   plugin e o time inteiro passa a rodar a sua metodologia com um comando.

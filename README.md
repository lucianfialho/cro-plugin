# Plugin CRO — skills por papel do time

Plugin gratuito de CRO para o Claude Code. Dez skills: nove prontas,
organizadas pelo papel de quem usa (analista, QA, dev), e uma pasta vazia de
propósito — o slot onde entra a skill de metodologia do **seu** time.

Versão 0.1.0 · Lucian Fialho / Métricas Boss.

## 1. Instalar

Requer Claude Code 2.1 ou mais novo. Rode os comandos **fora** do Claude Code
(`/exit` primeiro) — o plugin só passa a valer na próxima vez que o Claude
Code abrir.

```bash
claude plugin marketplace add lucianfialho/cro-plugin
claude plugin install cro@cro-plugin
```

Esperado:

```
✔ Successfully added marketplace: cro-plugin (declared in user settings)
✔ Successfully installed plugin: cro@cro-plugin (scope: user)
```

Conferir:

```bash
claude plugin list
claude plugin details cro@cro-plugin
```

O `details` deve mostrar `Skills (10)`. Depois é só abrir o `claude` e digitar
`/` — as skills aparecem com o prefixo `cro:`.

**Teste local (a partir da pasta, sem GitHub):**

```bash
claude plugin marketplace add ./cro-plugin
claude plugin install cro@cro-plugin
```

**Desinstalar:**

```bash
claude plugin uninstall cro@cro-plugin
claude plugin marketplace remove cro-plugin
```

## 2. As skills, por papel

| Papel | Skill | O que faz |
|---|---|---|
| Analista | `cro:heuristica-morys` | Varre a página nas 7 dimensões de Morys e diz onde a conversão se perde. |
| Analista | `cro:hipotese-estruturada` | Vira o achado em hipótese no template `Se [X], para [Y], então [Z], porque [evidência]` — e trava sem evidência. |
| Analista | `cro:ice-score` | Ranqueia o backlog por ICE (Impacto × Confiança × Facilidade) e penaliza hipótese sem dado. |
| Analista | `cro:post-test-segments` | Quebra o resultado do teste por device, novo vs recorrente e canal, para achar onde o lift aconteceu. |
| QA | `cro:pre-flight-check` | Roda o checklist dos 8 itens antes do Start e dá veredito: sobe ou não sobe. |
| QA | `cro:srm-check` | Valida Sample Ratio Mismatch (chi-quadrado) antes de qualquer leitura de resultado. |
| Dev | `cro:variante-builder` | Transforma a hipótese fechada no código da variante B (JS/CSS) e na lista de eventos a instrumentar. |
| Dev | `cro:detecta-design-system` | Lê o site e escreve um `DESIGN.md` com paleta, tipografia e componentes reais, para a variante sair com a cara certa. |
| Setup | `cro:cro-md` | Confirma a pasta do projeto, pergunta sobre a loja, cria o CRO.md com a seção Negócio preenchida e registra `@CRO.md` no CLAUDE.md. Um hook do plugin impede rodar na home, Desktop ou Downloads. |
| Metodologia | `cro:valida-skill-cro` | Dá nota em 5 critérios na skill de processo que você escreveu e aponta a lacuna sem preenchê-la. |
| Metodologia | `cro:metodologia-exemplo` | Exemplo do que você vai escrever: o processo de CRO de um time fictício, com papéis, handoffs e entregáveis nos 7 passos do ciclo. |

## 3. Plugar a sua skill de metodologia

A `metodologia-exemplo` é um exemplo genérico — o processo da Loja Aurora, que
não existe. O valor do plugin aparece quando essa pasta vira o processo do seu
time.

1. **Escreva a sua.** Use o `skill-creator` (plugin oficial) ou copie
   `skills/metodologia-exemplo/SKILL.md` como molde. Nomeie os papéis, os
   handoffs, os entregáveis de cada um dos 7 passos, as fontes de dado
   (ingredientes) e a sequência executável (modo de preparo).
2. **Valide.** Dentro do Claude Code, rode `cro:valida-skill-cro` na sua skill.
   Nota 8–10 significa que outra pessoa do time consegue rodar o processo sem
   perguntar de volta. Abaixo disso, a skill diz qual pergunta ficou sem
   resposta.
3. **Substitua a pasta.** Troque o conteúdo de `skills/metodologia-exemplo/`
   pela sua skill (ou renomeie a pasta para o nome do seu processo — a pasta
   precisa ter o mesmo nome do campo `name` do frontmatter). Reinstale o
   plugin e o time inteiro passa a rodar a sua metodologia com um comando.

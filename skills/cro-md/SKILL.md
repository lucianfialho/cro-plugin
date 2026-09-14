---
name: cro-md
description: Entrevista guiada que monta o CRO.md do projeto (o contexto da loja pro Claude) — pasta, loja, conectores, jornada, plano de mensuração e voz do cliente — e registra @CRO.md no CLAUDE.md. Use quando o usuário disser "cria o CRO.md", "inicia o contexto da loja", "monta o arquivo de contexto de CRO" ou rodar /cro-ai-day:cro-md.
---

# CRO.md — o contexto da loja, numa conversa

Você conduz. Uma etapa por vez, uma mensagem por etapa, sempre em pt-BR. O usuário pode
responder "pula" em qualquer etapa: a seção fica com `_a preencher_` e o exemplo no comentário.
Não invente nada que ele não disse. Não preencha por ele. Guarde as respostas e só escreva
os arquivos na etapa 7.

## Etapa 0 — a pasta
Diga o caminho completo do diretório atual e pergunte: "É a pasta do projeto? Se não, me diz
qual." Só siga com um sim. Se já existe `CRO.md` aqui, pare: diga que existe e ofereça abrir
uma seção específica pra completar, em vez de criar outro.

## Etapa 1 — a loja
Pergunte numa mensagem só: nome da loja · endereço do site · o que vende, em uma frase ·
ticket médio, se souber · plataforma (VTEX, Shopify, Nuvemshop, Magento, própria…).

## Etapa 2 — os conectores
Explique em uma linha: "conector é de onde eu vou puxar dado sem você exportar planilha".
Pergunte, item a item, e ofereça a opção certa pra cada resposta:
- **Comportamento no site:** GA4? → conector `google-analytics-mcp` (oficial do Google) ou o
  `gmp-cli`. Outro? Anote qual.
- **SAC:** Zendesk, WhatsApp, e-mail, outro? Anote o canal e o volume aproximado por mês.
- **Backlog e documentação do time:** Notion, planilha, Jira, nada? → conector `notion-mcp-server`
  se for Notion.
- **Navegar o site como usuário:** a extensão Claude in Chrome (anote "sim" ou "ainda não").
Registre o resultado na seção **Conectores** do arquivo. O que ele não tem, escreva "não tem".

## Etapa 3 — a jornada
Peça a lista das etapas que o usuário percorre, na ordem, com o nome que o time usa. Se ele fez
o exercício dos 5 minutos no site, peça as anotações: onde travou, onde pensou, onde quase
desistiu. Vai pra seção 2.

## Etapa 4 — o plano de mensuração
Primeiro: KPI primário (um só) e guardrail (o número que não pode piorar). Depois, **para cada
etapa da jornada** que ele deu na etapa 3, pergunte: qual evento marca essa etapa e onde você lê
esse número. Sugira os nomes padrão do GA4 quando couber (`view_item`, `add_to_cart`,
`begin_checkout`, `purchase`, `refund`) sem impor. Monte a tabela da seção 3.

## Etapa 5 — a voz do cliente
Três perguntas: qual é a reclamação mais comum no SAC (e a fonte) · qual objeção o time de vendas
mais ouve · existe pesquisa onsite? Onde e o que pergunta? Vai pra seção 5, sempre com a fonte.

## Etapa 6 — o que fica pra depois
Diga que as seções 4 (Segmentos), 6 (Perfil demográfico) e 7 (Testes e backlog) ficam com
`_a preencher_` e o exemplo no comentário, e que o 8 (Design) aponta pro `DESIGN.md` que a
skill `detecta-design-system` gera. Não pergunte sobre elas agora.

## Etapa 7 — escrever
1. `CRO.md` na pasta, a partir do template abaixo: primeira linha `# CRO.md — contexto da loja
   <nome>`, segunda `Site: <URL>`; seções 1, 2, 3, 5 e **Conectores** com as respostas; 4, 6, 7
   com `_a preencher_` e o exemplo em comentário; 8 como está. Mantenha os comentários HTML.
2. `CLAUDE.md` na pasta: se existir e não tiver `@CRO.md`, acrescente ao final
   `Loja: <nome>. Contexto do negócio e da mensuração: @CRO.md`; se não existir, crie com
   `# Projeto: <nome>` e essa linha.
3. Feche em 3 linhas: onde estão os arquivos, o que ficou `_a preencher_`, e que o Claude só
   passa a ler o CRO.md na próxima sessão: sair e entrar de novo.

## Template

```markdown
# CRO.md — contexto da loja
Site:

<!-- Convenção deste workshop (não é padrão de mercado). O Claude lê isto via CLAUDE.md. -->
<!-- Feito na entrevista do /cro-ai-day:cro-md. Seções com _a preencher_ têm o exemplo no comentário. -->

## Conectores
<!-- De onde o Claude puxa dado. Exemplo: GA4 via google-analytics-mcp · SAC no Zendesk (~400 tickets/mês)
     · backlog no Notion via notion-mcp-server · Claude in Chrome: sim -->

## 1. Negócio
<!-- Produto, ticket médio, plataforma e o funil inteiro em uma linha.
     Exemplo: Moda básica em malha, venda direta. Ticket médio R$ 189. VTEX.
     Funil: anúncio/busca → listagem → produto → carrinho → checkout → pedido. -->

## 2. Jornada em etapas
<!-- As etapas na ordem, com o nome que o time usa, e onde dói.
     Exemplo: 1. Descoberta  2. Listagem  3. Página de produto  4. Escolha de tamanho
     5. Carrinho  6. Identificação e frete  7. Pagamento  8. Pós-compra -->

## 3. Plano de mensuração
<!-- KPI primário e guardrail; um evento por etapa e onde se lê.
     Exemplo: KPI primário: conversão sessão→pedido. Guardrail: refund.
     | Página de produto | view_item · add_to_cart | GA4 | -->
KPI primário:            Guardrail:

| Etapa | Evento | Onde mede |
|---|---|---|

## 4. Segmentos que importam
<!-- 3 ou 4 recortes que se comportam diferente. Exemplo: Mobile primeira compra — 54% das
     sessões, converte 0,8% · Recorrente que já sabe o tamanho — converte 4x mais -->
_a preencher_

## 5. Voz do cliente
<!-- O que o SAC ouve, a objeção de vendas, a pesquisa onsite — sempre com a fonte.
     Exemplo: SAC (Zendesk, 412 tickets/mês): "veio menor que eu esperava" = 31% das trocas. -->

## 6. Perfil demográfico
<!-- Quem JÁ compra, puxado da própria base. Exemplo: 68% mulheres, 28–44, SP/MG/PR;
     recompra em 94 dias. Fonte: banco de pedidos cruzado com GA4. -->
_a preencher_

## 7. Testes e backlog
<!-- Testes rodados com resultado, e hipóteses na fila no template da Taciana:
     Se [mudarmos X], para [segmento Y], então [resultado Z], porque [evidência]. ICE. -->
_a preencher_

## 8. Design
<!-- O contexto visual mora em outro arquivo, gerado pela skill detecta-design-system. -->
Ver `DESIGN.md`.
```

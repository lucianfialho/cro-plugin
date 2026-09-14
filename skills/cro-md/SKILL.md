---
name: cro-md
description: Cria o CRO.md do projeto (o contexto da loja pro Claude) a partir do template do workshop, preenche a seção Negócio com o que o usuário responder e registra @CRO.md no CLAUDE.md. Use quando o usuário disser "cria o CRO.md", "inicia o contexto da loja", "monta o arquivo de contexto de CRO" ou rodar /cro:cro-md.
---

# CRO.md — o contexto da loja, num arquivo

## Tarefa

1. **Confirme a pasta.** Diga em uma linha onde você está (o caminho completo do diretório
   atual) e pergunte: "É a pasta do projeto? Se não, me diz qual." Só siga com um sim.
   Se o usuário indicar outra pasta, escreva os arquivos lá e avise que ele precisa abrir
   o Claude nessa pasta pra o contexto valer.
2. Se já existe `CRO.md` na pasta, **pare** e diga que ele existe. Não sobrescreva.
3. **Pergunte, numa mensagem só**, e aceite resposta parcial (o que não vier, deixe em branco):
   - nome da loja
   - endereço do site (URL)
   - o que vende, em uma frase
   - ticket médio, se souber
   - plataforma da loja (VTEX, Shopify, Nuvemshop, Magento, própria…)
   - onde estão os dados de comportamento (GA4? outro?)
   - por onde chega o SAC (Zendesk, WhatsApp, e-mail…)
4. Escreva `CRO.md` na pasta com o template abaixo:
   - primeira linha: `# CRO.md — contexto da loja <nome>`, e logo abaixo `Site: <URL>`
   - **seção 1. Negócio** preenchida com o que veio das respostas, no lugar do exemplo
     (o que vende, ticket, plataforma, analytics, SAC). O que ficou em branco, deixe
     como linha `_a preencher_`.
   - as demais seções exatamente como no template. Mantenha os comentários HTML: são as
     instruções de preenchimento e não entram no contexto.
5. No `CLAUDE.md` da pasta:
   - se existir e ainda não tiver `@CRO.md`, acrescente ao final:
     `Loja: <nome>. Contexto do negócio e da mensuração: @CRO.md`
   - se não existir, crie com o título `# Projeto: <nome da loja>` e essa mesma linha.
6. Termine dizendo, em 3 linhas: onde os arquivos estão, quais 3 seções preenchemos hoje
   (2. Jornada, 3. Plano de mensuração, 5. Voz do cliente) e que o Claude só passa a ler
   o CRO.md na próxima sessão: sair e entrar de novo.

Não preencha as seções 2, 3 e 5 pelo usuário. O template vem com exemplo em comentário;
a lição é o aluno escrever o dele.

## Template (copiar na íntegra, trocando só o que o passo 4 manda)

```markdown
# CRO.md — contexto da loja

<!-- Convenção deste workshop (não é padrão de mercado). O Claude lê isto via CLAUDE.md. -->
<!-- Você preenche AO VIVO: 2. Jornada, 3. Plano de mensuração, 5. Voz do cliente (vêm vazias, com exemplo no comentário). -->
<!-- Leva para preencher depois: 1. Negócio, 4. Segmentos, 6. Perfil, 7. Testes, 8. Design. -->
<!-- Tudo abaixo é exemplo de uma loja fictícia (Malha Viva, moda básica). Troque pelo seu. -->

## 1. Negócio
<!-- Produto, ticket médio e o funil inteiro em uma linha. -->
Moda básica em malha, venda direta ao consumidor. Ticket médio R$ 189, 2,3 itens por pedido.
Funil: anúncio/busca → listagem → produto → carrinho → checkout em 3 passos → pedido.
72% do tráfego é mobile, e a conversão mobile é metade da de desktop.

## 2. Jornada em etapas
<!-- AO VIVO. As etapas que o usuário percorre, na ordem, com o nome que VOCÊ usa internamente.
     Exemplo: 1. Descoberta (anúncio, busca, e-mail)  2. Listagem  3. Página de produto
     4. Escolha de tamanho  5. Carrinho  6. Identificação e frete  7. Pagamento  8. Pós-compra -->

## 3. Plano de mensuração
<!-- AO VIVO. KPI primário e guardrail; depois um evento por etapa e onde você lê o número.
     Exemplo:  KPI primário: conversão sessão→pedido. Guardrail: taxa de troca por tamanho.
     | Página de produto | `view_item` | GA4 |
     | Escolha de tamanho | `select_size` (custom) | GA4 via GTM |
     | Checkout | `begin_checkout` → `purchase` | GA4 + backoffice | -->
KPI primário:            Guardrail:

| Etapa | Evento | Onde mede |
|---|---|---|

## 4. Segmentos que importam
<!-- 3 ou 4 recortes que se comportam de forma diferente — não demografia genérica. -->
- Mobile primeira compra — 54% das sessões, converte 0,8%
- Recorrente que já sabe o tamanho — converte 4x mais, ignora a tabela de medidas
- Tráfego de e-mail promocional — muito add-to-cart, abandona no frete
- Desktop pesquisando preço — volta em até 7 dias

## 5. Voz do cliente
<!-- O que o SAC ouve e as objeções que vendas escuta, sempre com a fonte do dado.
     Exemplo: SAC (Zendesk, 412 tickets/mês): "a peça veio menor que eu esperava" = 31% das trocas.
     Objeção de vendas (WhatsApp): frete acima de R$ 30 para o Nordeste derruba o fechamento.
     Pesquisa onsite na saída do carrinho (n=380): 44% marcam "quero ver o frete antes de me cadastrar". -->

## 6. Perfil demográfico
<!-- Quem JÁ compra, puxado da sua própria base — não o público que você gostaria de ter. -->
Compradores de 2026: 68% mulheres, 28–44 anos, concentradas em SP, MG e PR.
Recompra média em 94 dias, e o ticket sobe 22% no segundo pedido.
Fonte: export do banco de pedidos cruzado com GA4 (não é persona de agência).

## 7. Testes e backlog
<!-- Testes já rodados com o resultado, e as hipóteses na fila no template da Taciana. -->
Rodado: frete grátis acima de R$ 199 exibido no carrinho — +6,1% de pedidos, guardrail estável, implementado.
Backlog: Se abrirmos a tabela de medidas na página de produto, para mobile primeira compra, então a
troca por tamanho cai 15%, porque 31% dos tickets do SAC são "veio menor". ICE: 8 × 7 × 6.

## 8. Design
<!-- Uma linha só: o contexto visual mora em outro arquivo. -->
Ver `DESIGN.md`.
```

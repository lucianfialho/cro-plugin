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

---
version: alpha
name: Insider
description: E-commerce brasileiro de vestuário com tecnologia têxtil. Identidade monocromática (preto sobre branco), tipografia Manrope, geometria reta e sem sombra.
colors:
  primary: "#000000"
  on-primary: "#ffffff"
  secondary: "#121212"
  surface: "#ffffff"
  surface-container: "#f3f3f3"
  surface-dim: "#eeeeee"
  on-surface: "#3d3d3d"
  on-surface-variant: "#666666"
  outline: "#dddddd"
  scrim: "#00000066"
typography:
  body-md:
    fontFamily: Manrope
    fontSize: 16.1px
    fontWeight: 400
    lineHeight: 27.3px
    letterSpacing: 0.69px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: 400
    lineHeight: 23.74px
    letterSpacing: 0.69px
  body-xs:
    fontFamily: Manrope
    fontSize: 13px
    fontWeight: 400
    lineHeight: 22.04px
    letterSpacing: 0.69px
  title-md:
    fontFamily: Manrope
    fontSize: 16.1px
    fontWeight: 600
    lineHeight: 20.93px
    letterSpacing: 0.6px
  title-sm:
    fontFamily: Manrope
    fontSize: 15px
    fontWeight: 700
    lineHeight: 19.5px
    letterSpacing: 0.6px
  label-cta:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: 700
    lineHeight: 15.62px
    letterSpacing: 1px
  label-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: 500
    lineHeight: 14px
    letterSpacing: 0.69px
  label-sm:
    fontFamily: Manrope
    fontSize: 11px
    fontWeight: 400
    lineHeight: 11px
    letterSpacing: 0.805px
  label-badge:
    fontFamily: Manrope
    fontSize: 10px
    fontWeight: 900
    lineHeight: 16.96px
    letterSpacing: 0.69px
rounded:
  none: 0px
  sm: 4px
  md: 6px
  lg: 15px
  pill: 50px
spacing:
  xs: 4px
  sm: 8px
  md: 14px
  lg: 24px
  xl: 28px
  gutter: 20px
  gutter-mobile: 10px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.label-cta}"
    rounded: "{rounded.none}"
    padding: 14px
  card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface}"
    typography: "{typography.body-md}"
    rounded: "{rounded.sm}"
    padding: 0px
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface}"
    rounded: "{rounded.none}"
    padding: 17.25px
---

# DESIGN.md — Insider

Extraído de `https://www.insiderstore.com.br/` (home, viewport 1280x720) em
2026-09-13, a partir de 2.157 elementos visíveis. Cada valor abaixo diz de onde
veio. O que não foi possível extrair está marcado como **não encontrado** —
nenhum campo foi preenchido por suposição.

## Overview

Identidade monocromática: fundo branco, preto puro como única cor de ação,
cinza-chumbo (`#3d3d3d`) para o texto corrido. Não há cor de marca cromática —
o contraste é o recurso de hierarquia. A geometria é reta (botões com raio 0) e
totalmente plana: nenhum dos 2.157 elementos analisados tinha `box-shadow`
diferente de `none`. A cor entra pela foto do produto, não pela interface.

**Evidência:** `--color-base-accent-1: 0, 0, 0` e `--color-base-text: 61, 61, 61`
declaradas em `:root`; `#ffffff` ocupa 6.400.243 px² de área pintada contra
1.618.464 px² de `#000000` (relação ~4:1).

**Base técnica detectada:** tema Shopify da família Dawn — as variáveis CSS
seguem a nomenclatura `--color-base-*`, `--buttons-radius`, `--inputs-radius`.
Isso importa para o CRO: variável nomeada é ponto de alteração barato.

## Colors

| Token | Hex | De onde veio |
|---|---|---|
| `primary` | `#000000` | variável CSS `--color-base-accent-1: 0, 0, 0` + fundo do botão dominante (24 ocorrências) |
| `on-primary` | `#ffffff` | variável CSS `--color-base-solid-button-labels: 255, 255, 255` |
| `secondary` | `#121212` | variável CSS `--color-base-accent-2: 18, 18, 18` (usada em `--color-link`) |
| `surface` | `#ffffff` | variável CSS `--color-base-background-1` + maior área pintada da página |
| `surface-container` | `#f3f3f3` | variável CSS `--color-base-background-2: 243, 243, 243` |
| `surface-dim` | `#eeeeee` | 3ª maior área pintada (325.106 px²) |
| `on-surface` | `#3d3d3d` | variável CSS `--color-base-text: 61, 61, 61` + 166 ocorrências em texto |
| `on-surface-variant` | `#666666` | CSS computado, 19 ocorrências em texto |
| `outline` | `#dddddd` | CSS computado, 8 ocorrências em texto/borda |
| `scrim` | `#00000066` | overlay de 921.600 px² (tela cheia) sobre o banner |

**Observado e não promovido a token:** `#33405b`, `#572531`, `#005183`,
`#7b594f`, `#273636`, `#4b2137`, `#6b4e50` — de 4 a 8 ocorrências cada. São
amostras de cor de variante de produto (swatches), não cores de interface. Não
entram na paleta.

**Não encontrado:** cores de estado (`error`, `success`, `warning`). A home não
renderizou nenhuma mensagem de erro ou confirmação. Para extrair, rode a skill
de novo com a URL do carrinho ou do checkout.

## Typography

Uma família só: **Manrope**, em 460 dos 591 nós de texto medidos. É a fonte de
corpo e de título ao mesmo tempo — `--font-body-family` e
`--font-heading-family` apontam para a mesma declaração. A hierarquia é feita
por peso (400 / 600 / 700 / 900), não por família.

O tamanho de corpo é **16.1px**, não 16px: `--font-body-scale: 1.15` multiplica
a base. Todo texto corrido carrega `letter-spacing: 0.69px` — espaçamento
positivo sistemático, que é a assinatura tipográfica da marca.

**Atenção — ruído de terceiros:** 123 nós apareceram em `Arial 13.3333px`,
o padrão do navegador. São widgets de terceiros (avaliações, chat), não
decisão de design. **Não use Arial em variante nenhuma.**

**Não encontrado:** níveis de display/headline acima de 24px. O maior tamanho
medido na home foi 24px (10 ocorrências). Títulos de PDP ou de categoria podem
ter escala própria — rode a skill numa página de produto para completar.

## Layout

`--grid-desktop-horizontal-spacing: 20px` e `--grid-mobile-horizontal-spacing: 10px`
são os únicos valores de espaçamento declarados como variável — esses dois são
a régua real do grid.

**O site não tem uma escala de espaçamento consistente.** Os paddings mais
frequentes foram 1px (160x), 8px (101x), 14px (96x), 6px (94x), 7px (56x),
10px (54x), 17px (43x). Não há base de 4px nem de 8px que explique a
distribuição. Os tokens `spacing` no frontmatter registram os valores
observados com mais frequência — eles descrevem o que está no ar, não um
sistema. Se for gerar página nova, prefira `gutter: 20px` como unidade e
padronize o resto.

## Elevation & Depth

Plano, sem exceção. Zero elementos com `box-shadow`. As variáveis do tema
confirmam a intenção: `--buttons-shadow-visible: 0`,
`--product-card-shadow-blur-radius: 0.0rem`,
`--collection-card-shadow-opacity: 0.0`.

A profundidade vem de duas coisas: o overlay `#00000066` sobre a imagem do
banner e o contraste puro entre `#ffffff` e `#000000`.

## Shapes

Convivem três raios na mesma página, e um deles contradiz a variável do tema:

| Token | Valor | Onde |
|---|---|---|
| `none` | `0px` | botão dominante (medido) e `--inputs-radius: 0px` |
| `sm` | `4px` | card de produto (362 ocorrências — o raio mais comum da página) |
| `md` | `6px` | `--buttons-radius: 6px` e `--variant-pills-radius: 6px` |
| `lg` | `15px` | 246 ocorrências |
| `pill` | `50px` | 262 ocorrências (badges e pills) |

**Divergência registrada, não resolvida:** o tema declara `--buttons-radius: 6px`,
mas o botão "COMPRA RÁPIDA" renderiza com `border-radius: 0px` — alguma regra
CSS posterior sobrescreve a variável. O valor no token `button-primary` é o
**medido** (0px), porque é o que o usuário vê. A variável ficou registrada aqui
para quem for mexer no tema.

## Components

### button-primary

Fundo `#000000`, texto `#ffffff`, Manrope 14px/700, `letter-spacing: 1px`,
**caixa alta** (`text-transform: uppercase`), padding 14px em todos os lados,
raio 0, sem borda, sem sombra.

**Evidência:** 35 elementos clicáveis com fundo sólido e área > 400px²;
24 deles compartilham exatamente essa assinatura. Amostras: "COMPRA RÁPIDA".

### card

Fundo `#ffffff`, texto `#3d3d3dbf` (cinza a 75% de opacidade), raio 4px,
padding 0, sem borda, sem sombra. A separação entre cards vem do gutter de
20px, não de moldura.

**Evidência:** 28 candidatos a card; 24 com a mesma assinatura. Amostras
contêm o badge "Best Seller".

### input

Fundo `#ffffff`, texto `#3d3d3d`, raio 0, padding 17.25px, sem borda visível.

⚠️ **Baixa confiança.** Só 3 campos de input estavam visíveis na home, e a
assinatura dominante aparece 1 vez. A fonte medida foi Arial 18.4px, o que
sugere que o campo não herda Manrope — mas com n=1 isso pode ser um widget de
terceiro. **Rode a skill na página de checkout antes de gerar qualquer variante
com formulário.**

### Não encontrado

`nav`, `chip`, `tooltip`, `checkbox`, `radio`, estados de `hover` e `focus`.
A extração lê um único estado estático da página. Estados interativos exigem
navegação passo a passo — fora do escopo desta rodada.

## Do's and Don'ts

- **Do** usar `#000000` só para a ação principal da tela. É a única cor de
  ação que o site tem — gastá-la em dois lugares mata a hierarquia.
- **Do** manter `letter-spacing: 0.69px` no corpo e `1px` no CTA. É o que faz
  o texto "parecer Insider".
- **Do** escrever CTA em caixa alta, Manrope 700.
- **Don't** usar Arial. Os 123 nós em Arial são widget de terceiro, não design.
- **Don't** adicionar `box-shadow`. A página inteira é plana — uma sombra
  denuncia a variante como enxerto.
- **Don't** inventar cor de erro ou de sucesso. Não foi extraída. Rode a skill
  no checkout antes.
- **Don't** tratar os tokens de `spacing` como sistema. São frequência medida,
  não escala declarada.

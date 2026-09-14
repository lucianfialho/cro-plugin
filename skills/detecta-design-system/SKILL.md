---
name: detecta-design-system
description: Lê o site do aluno e escreve um DESIGN.md no formato da especificação do Google — paleta com os hex reais, tipografia, espaçamento, raio de borda e os componentes recorrentes (botão primário, card, input), cada valor com a fonte de onde saiu. Use quando o usuário disser "extrair o design do meu site", "gerar design.md", "detectar design system", "dar o contexto visual pro Claude" ou "as variantes estão saindo com a cara errada".
---

# Detecta Design System — do site do aluno para um `DESIGN.md`

Você é um design systems lead. Recebe a URL de um site, mede o que está no ar e
escreve um `DESIGN.md` — o arquivo que dá ao Claude o contexto visual da
empresa, para que qualquer variante de página gerada depois saia com a cara
certa em vez de sair com a cara do Claude.

## Dependência — leia antes de começar

Esta skill **mede a página renderizada**, não o código-fonte. Ela precisa de um
navegador controlável:

| Ferramenta | Como checar | Preferência |
|---|---|---|
| `agent-browser` | `agent-browser --version` | 1ª opção |
| Claude in Chrome | `claude --chrome`, ou as ferramentas `mcp__claude-in-chrome__*` no ambiente | 2ª opção |

**Se nenhuma estiver disponível, pare.** Diga ao usuário: "Não tenho navegador
neste ambiente. Instale com `npm i -g agent-browser` ou rode `claude --chrome`."
Não tente adivinhar o design a partir do HTML bruto baixado com `curl` — CSS
externo, variáveis CSS e estilo computado não existem no HTML cru, e o
resultado seria chute.

O validador oficial (`npx @google/design.md lint`) é opcional mas recomendado.
Se não houver rede para o `npx`, siga sem ele e diga que o arquivo não foi
validado.

## Input necessário

Peça ao usuário:

1. **A URL.** Uma página que represente a marca — a home, ou a página de
   produto se o teste for de PDP.
2. **O que ele vai gerar depois** (variante de PDP, landing, checkout). Isso
   decide se vale rodar em mais de uma URL.

Se ele der só a URL, siga. Uma URL já produz um `DESIGN.md` útil.

## O formato de saída — a especificação

O `DESIGN.md` é a especificação aberta do Google Labs para descrever uma
identidade visual para agentes de código.

- Spec: <https://github.com/google-labs-code/design.md> (`docs/spec.md`, versão `alpha`, Apache-2.0)
- Validador: `npx @google/design.md lint DESIGN.md`

O arquivo tem duas camadas:

- **Front matter YAML** — os tokens, em valores exatos. É o que a máquina lê.
- **Corpo Markdown** — a razão de cada escolha, em prosa. É o que explica ao
  agente *quando* usar cada token.

Esquema do front matter (só o que esta skill preenche):

```yaml
version: alpha
name: <nome da marca>
description: <uma frase>
colors:
  <token>: "#rrggbb"
typography:
  <nível>:
    fontFamily: <string>
    fontSize: <px|em|rem>
    fontWeight: <número>
    lineHeight: <px|em|rem|número>
    letterSpacing: <px|em|rem>
rounded:
  <nível>: <px|em|rem>
spacing:
  <nível>: <px|em|rem|número>
components:
  <componente>:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.label-cta}"
    rounded: "{rounded.none}"
    padding: <px|em|rem>
```

Seções do corpo, **nesta ordem** (pode pular as que não se aplicam, mas não
reordenar): `Overview`, `Colors`, `Typography`, `Layout`, `Elevation & Depth`,
`Shapes`, `Components`, `Do's and Don'ts`.

Regras do formato que quebram o validador se você errar:

- `lineHeight: normal` é inválido. Só `px`, `em`, `rem` ou número puro. Se o
  valor medido for `normal`, **omita o campo**.
- `letterSpacing: normal` idem — omita.
- Duas seções `## Colors` no mesmo arquivo = erro fatal.
- Referência de token entre chaves e com caminho completo: `{colors.primary}`,
  nunca `{primary}`.
- Nome de token é livre. Não force nomes que o site não tem.

## Modo de preparo

### Passo 1 — abrir a página

```bash
agent-browser open <url>
agent-browser wait 3000
```

Se a página tiver banner de cookie ou popup de newsletter cobrindo a tela,
feche antes de medir — overlay em tela cheia distorce a medição de área:

```bash
agent-browser snapshot -i          # achar o botão de fechar
agent-browser click "@<ref>"
```

### Passo 2 — medir

```bash
agent-browser eval "$(cat extrair-base.js extrair-tokens.js)" > /tmp/tokens.json
```

Os dois arquivos ficam no diretório desta skill e **precisam ser
concatenados nessa ordem** — `extrair-base.js` define os helpers,
`extrair-tokens.js` mede e devolve o JSON. A saída tem:

| Chave | O que é | De onde tirou |
|---|---|---|
| `cssVars` | variáveis CSS declaradas em `:root` / `html` / `body` | folhas de estilo do próprio site |
| `cores.fundo` | cores de fundo por frequência | `getComputedStyle().backgroundColor` |
| `cores.fundoPorArea` | cores de fundo por área pintada em px² | idem, ponderado por `getBoundingClientRect()` |
| `cores.texto` | cores de texto por frequência | `getComputedStyle().color`, só em nós com texto próprio |
| `tipografia.familias` / `.tamanhos` / `.pesos` | contagem por valor | CSS computado |
| `tipografia.niveis` | assinaturas completas (família+tamanho+peso+entrelinha+tracking) por frequência | CSS computado |
| `rounded` | raios de borda por frequência | `borderTopLeftRadius` |
| `spacing` | paddings e gaps por frequência | CSS computado |
| `componentes` | assinatura dominante de botão, card e input | agrupamento por estilo idêntico |

Se o site tiver mais de uma página relevante, repita o passo 2 em cada URL e
some as evidências. Diga no arquivo de qual URL veio cada coisa.

### Passo 3 — decidir os tokens, nesta ordem de autoridade

1. **Variável CSS nomeada vence.** Se existe `--color-base-accent-1: 0, 0, 0`,
   o `primary` é `#000000` e a evidência é a variável. Alguém escreveu aquele
   nome de propósito.
2. **Área pintada vence frequência, para superfícies.** A cor de fundo da
   página é a que ocupa mais px², não a que aparece em mais elementos.
3. **Frequência vence, para texto e componente.** A cor de texto do site é a
   que aparece em mais nós de texto.
4. **Medido vence declarado, quando divergem.** Se `--buttons-radius: 6px` mas
   o botão renderiza com `0px`, o token do componente é `0px` — é o que o
   usuário vê. **Registre a divergência na prosa**, não a esconda.

### Passo 4 — separar sinal de ruído

Três coisas aparecem na medição e **não** são o design system:

- **Swatch de variante de produto.** Dezenas de cores com 3 a 8 ocorrências
  cada, sem parentesco entre si, são amostras de cor de produto. Liste na
  prosa como "observado e não promovido a token" — não coloque na paleta.
- **Widget de terceiro.** `Arial 13.3333px` é o padrão do navegador. Se
  aparecer em volume, é chat, avaliação ou pixel de terceiro. Registre e
  mande explicitamente **não usar**.
- **Overlay de tela cheia.** Uma cor com área exatamente igual à viewport é
  scrim de banner, não superfície.

### Passo 5 — escrever o arquivo

Escreva `DESIGN.md` na raiz do projeto do aluno (ou onde ele pedir). Abra o
corpo com uma linha dizendo **de qual URL, em qual viewport, em que data e
sobre quantos elementos** a medição foi feita.

Em cada seção, diga de onde veio o valor. Uma tabela `Token | Valor | De onde veio`
resolve as seções de cor e de forma. Nas outras, prosa curta citando a
evidência.

### Passo 6 — validar

```bash
npx @google/design.md lint DESIGN.md
```

Erro = conserte e rode de novo. Aviso de `orphaned-tokens` (token definido e
nunca referenciado por componente) é aceitável — diga ao usuário que é
esperado quando o token existe para uso direto, não dentro de componente.

## O que esta skill recusa

Esta é a regra que vale mais que todas as outras: **o que não foi medido não
entra no arquivo.**

- Não preencha `error`, `success` ou `warning` porque "todo e-commerce tem". Se
  a página não renderizou mensagem de erro, escreva
  **"Não encontrado — rode a skill no checkout"**.
- Não arredonde `16.1px` para `16px`. O `16.1` é real e veio de
  `--font-body-scale: 1.15`. Se você arredondar, a variante fica visivelmente
  diferente do site.
- Não invente uma escala de espaçamento. Se os paddings medidos forem
  1px, 8px, 14px, 6px, 7px, 10px, o site **não tem** escala de 4 ou 8. Escreva
  isso. Tokens de `spacing` nesse caso são frequência observada, não sistema —
  diga a frase na seção `Layout`.
- Não descreva a marca com adjetivo sem número atrás. "Moderno e limpo" não é
  extração. "Zero elementos com `box-shadow` em 2.157 medidos" é.
- Não avalie se o design é bom. Esta skill fotografa; quem julga é a
  `heuristica-morys`.
- Quando um componente tiver poucas amostras (menos de 3), marque
  **⚠️ baixa confiança** com o número de candidatos, e diga em qual página
  rodar de novo para confirmar.

## Output

Entregue ao usuário, nesta ordem:

1. **O caminho do `DESIGN.md`** gerado.
2. **Resultado do lint** — número de erros e avisos.
3. **Tabela de confiança:**

| Dimensão | Confiança | Base |
|---|---|---|
| Cores | alta / média / baixa | variável CSS nomeada / só medição / poucas amostras |
| Tipografia | ... | ... |
| Espaçamento | ... | ... |
| Formas | ... | ... |
| Componentes | ... | ... |

4. **O que ficou como "não encontrado"** e em qual URL rodar para completar.

Termine com: "Coloque o `DESIGN.md` na raiz do projeto. A partir daqui, toda
variante que o Claude gerar usa esses tokens — e o que não estiver aqui, ele
vai perguntar em vez de inventar."

## Skills relacionadas

- Base de referência: `extract-design-md` do
  [`google-labs-code/stitch-skills`](https://github.com/google-labs-code/stitch-skills)
  — extrai de código-fonte, não de URL. Esta skill é a versão para quem tem o
  site no ar e não tem o repositório.
- Depois do `DESIGN.md`, a `variante-builder` gera o código da variante B já
  dentro desses tokens.

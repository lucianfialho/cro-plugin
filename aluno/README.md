# Pasta do aluno

O kit que você leva do workshop. Três arquivos, nenhum código:

- `CLAUDE.md` — diz ao Claude que projeto é este e importa os outros dois
- `CRO.md` — tudo que você sabe da sua loja: jornada, mensuração, segmentos, voz do cliente
- `DESIGN.md` — o contexto visual, gerado pela skill `detecta-design-system` (nó 8)

## Como usar

1. Renomeie a pasta com o nome da sua loja e abra o terminal dentro dela.
2. Rode `claude`.
3. Pronto: o Claude lê o `CLAUDE.md`, que importa o `CRO.md` e o `DESIGN.md`.

Não precisa colar contexto no chat: ele já entra sabendo da loja. Quando a loja
mudar, edite o `CRO.md` — é lá que o contexto vive.

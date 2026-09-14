# Hooks de processo de CRO

Três hooks para Claude Code. Eles não são de segurança — são de
**processo**. Cada um é a etapa anterior cobrando a conta: o Claude não
consegue pular uma etapa do ciclo de CRO porque um script bloqueia.

| Hook | Bloqueia | Exige |
|---|---|---|
| `sem-plano-sem-hipotese.sh` | a skill `hipotese-estruturada` | `CRO.md` com a seção "Plano de mensuração" preenchida |
| `sem-srm-sem-resultado.sh` | comandos que leem resultado de teste A/B (`converted`, conversão, `lift`, `cro-clean.db`) | a skill `srm-check` ter dado 🟢 e gravado `.cro/srm-ok` |
| `sem-design-sem-variante.sh` | a skill `variante-builder` e a escrita de `variante*.html/.css/.js` | `DESIGN.md` no projeto |

Quando bloqueia, a mensagem diz o que falta e como resolver. Não é sermão,
é o caminho de volta.

Os dois hooks de skill (`sem-plano-sem-hipotese` e `sem-design-sem-variante`)
escutam **dois eventos**, `UserPromptSubmit` e `PreToolUse`, porque há dois
caminhos até a mesma skill: quando o modelo decide invocá-la, o Claude Code
chama a ferramenta `Skill` e o `PreToolUse` dispara; mas quando **você digita**
`/cro-ai-day:hipotese-estruturada`, a skill é expandida direto no prompt, a ferramenta
`Skill` nunca é chamada e só o `UserPromptSubmit` vê a jogada — se o hook
escutasse apenas `PreToolUse`, bastaria digitar o comando para passar por cima
do guardrail. (O `sem-srm-sem-resultado` olha `Bash`/`Read`, não skill, e por
isso continua só em `PreToolUse`.)

## Instalar em 3 passos

**1.** Copie os três `.sh` para a pasta de hooks do Claude:

```bash
mkdir -p ~/.claude/hooks
cp 05-imersao-cro/hooks/sem-plano-sem-hipotese.sh  ~/.claude/hooks/
cp 05-imersao-cro/hooks/sem-srm-sem-resultado.sh   ~/.claude/hooks/
cp 05-imersao-cro/hooks/sem-design-sem-variante.sh ~/.claude/hooks/
```

**2.** Registre os hooks. Se você **não tem** `~/.claude/settings.json`,
copie o daqui:

```bash
cp 05-imersao-cro/hooks/settings.json ~/.claude/settings.json
```

Se você **já tem** um `settings.json`, não sobrescreva: abra os dois e cole
os três blocos de dentro de `"PreToolUse"` no array `"PreToolUse"` que já
existe no seu arquivo. (Se o seu não tem `"hooks"`, cole o objeto `"hooks"`
inteiro.)

**3.** Reinicie o Claude Code. Hooks são lidos na abertura da sessão — se
você editar o `settings.json` com a sessão aberta, o hook antigo continua
valendo.

> Windows: funciona no Git Bash, que é o que o Claude Code usa para rodar
> hooks. Não precisa de `jq` nem de `chmod`.

## Testar que está funcionando

Sem abrir o Claude, os 17 casos dos três hooks — bloqueio, liberação,
regressão e comando digitado:

```bash
bash 05-imersao-cro/hooks/test.sh
```

Deve terminar com `FAIL: 0`.

Com o Claude aberto, num diretório vazio:

```
Rode a skill hipotese-estruturada
```

Tem que aparecer `BLOQUEADO pelo hook sem-plano-sem-hipotese`. Copie o
`aluno/CRO.md` para a pasta, preencha a seção "Plano de mensuração" e peça de
novo: passa.

## O que conta como "Plano de mensuração preenchido"

O hook procura um `CRO.md` até 2 níveis abaixo da raiz do projeto, lê da linha
`## ... Plano de mensuração ...` até o próximo heading e descarta linha em
branco, comentário HTML (`<!-- ... -->`), o cabeçalho da tabela e o separador
`|---|`. Se sobrar pelo menos uma linha de tabela, está preenchida.

Ou seja: o template recém-copiado, com o comentário de instrução e a tabela
vazia, ainda bloqueia. Basta uma linha `| etapa | evento | onde mede |` de
verdade para liberar. A checagem é feita em `awk` — sem `jq`, sem `python3`.

## Como o `sem-srm-sem-resultado` sabe que o SRM rodou

Pelo arquivo `.cro/srm-ok` no diretório do projeto. Quem grava é a skill
`srm-check`, e **só quando o veredito é 🟢** (ver Passo 4 da skill). Se o
veredito vira 🟡 ou 🔴, a skill apaga o marcador e o bloqueio volta.

O marcador vale por projeto, não por sessão: uma vez validado, o teste
continua liberado até alguém apagar `.cro/srm-ok`. Para forçar revalidação,
apague o arquivo.

O hook abre exceção para comandos que contêm `srm` ou `session_start` —
senão a própria skill `srm-check` seria bloqueada ao consultar o banco.

## Desligar um hook

Três opções, da mais reversível para a mais definitiva:

1. **Só neste projeto, agora:** crie o arquivo que falta. É a saída pretendida.
2. **Temporariamente:** apague o bloco do hook em `~/.claude/settings.json`
   e reinicie o Claude Code.
3. **De vez:** apague o `.sh` de `~/.claude/hooks/` e o bloco do
   `settings.json`.

Para conferir o que está ativo, rode `/hooks` dentro do Claude Code.

## Como isso funciona por dentro

O Claude Code manda um JSON no stdin do script antes de executar a
ferramenta. Os campos que usamos:

```json
{
  "cwd": "/caminho/do/projeto",
  "hook_event_name": "PreToolUse",
  "tool_name": "Skill",
  "tool_input": { "skill": "hipotese-estruturada" }
}
```

No `UserPromptSubmit` não existe `tool_name`: o que chega é o texto digitado.
Os scripts leem `hook_event_name` e escolhem o campo certo.

```json
{
  "cwd": "/caminho/do/projeto",
  "hook_event_name": "UserPromptSubmit",
  "prompt": "/cro-ai-day:hipotese-estruturada monta a hipótese"
}
```

Para **bloquear**, o script escreve a mensagem no **stderr** e sai com
**código 2**. Sair com 0 deixa passar. Confirmado na versão 2.1.268.

Os scripts não usam `jq`: leem o JSON com `python3`, e caem num
`sed` se `python3` não existir na máquina.

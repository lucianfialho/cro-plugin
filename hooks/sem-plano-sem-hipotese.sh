#!/bin/bash
# ---------------------------------------------------------------------------
# Hook UserPromptSubmit + PreToolUse: sem-plano-sem-hipotese
#
# Bloqueia a skill `hipotese-estruturada` enquanto o projeto nao tiver um
# `CRO.md` com a secao "Plano de mensuracao" preenchida.
#
# A regra: sem saber o que medir, hipotese e chute com template bonito.
#
# Protocolo (Claude Code 2.1.x): o payload chega em JSON no stdin. Quando o
# modelo chama a ferramenta, vem hook_event_name="PreToolUse", tool_name="Skill"
# e tool_input={"skill":"<nome>"}. Quando o aluno digita o comando, vem
# hook_event_name="UserPromptSubmit" e prompt="/cro-ai-day:<nome> ...". Para bloquear,
# escrevemos a mensagem no stderr e saimos com codigo 2 — vale nos dois eventos.
# ---------------------------------------------------------------------------

PAYLOAD=$(cat)

# --- extrator de JSON sem jq ------------------------------------------------
# Caminho 1: python3 (presente na maioria das maquinas).
# Caminho 2: sed, se python3 nao existir.
json_get() {
  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$PAYLOAD" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for k in sys.argv[1:]:
    if not isinstance(d, dict):
        sys.exit(0)
    d = d.get(k)
    if d is None:
        sys.exit(0)
print(d if isinstance(d, str) else "")
' "$@" 2>/dev/null
  else
    # ultima chave pedida vira a chave procurada no texto cru
    _k=""
    for _a in "$@"; do _k="$_a"; done
    printf '%s' "$PAYLOAD" \
      | sed -n 's/.*"'"$_k"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
      | head -n 1
  fi
}

# --- a skill esta prestes a rodar? ------------------------------------------
# Sao dois caminhos ate ela e o hook precisa cobrir os dois:
#   1. o aluno digita /cro-ai-day:hipotese-estruturada  -> UserPromptSubmit, campo prompt
#      (a skill e expandida no proprio prompt; a ferramenta Skill nunca e chamada)
#   2. o modelo decide invocar a skill           -> PreToolUse, tool_input.skill
EVENTO=$(json_get hook_event_name)

if [ "$EVENTO" = "UserPromptSubmit" ]; then
  PROMPT=$(json_get prompt)
  case "$PROMPT" in
    /cro-ai-day:hipotese-estruturada*|/hipotese-estruturada*) ;;
    *) exit 0 ;;
  esac
else
  [ "$(json_get tool_name)" = "Skill" ] || exit 0
  case "$(json_get tool_input skill)" in
    *hipotese-estruturada*) ;;
    *) exit 0 ;;
  esac
fi

# --- diretorio do projeto ---------------------------------------------------
PROJ=$(json_get cwd)
[ -n "$PROJ" ] || PROJ="${CLAUDE_PROJECT_DIR:-$PWD}"

# --- a secao "Plano de mensuracao" tem conteudo? ----------------------------
# Le do heading ate o proximo heading. Ignora linha em branco e comentario
# HTML (de uma ou varias linhas). Sobra alguma linha de tabela que nao seja o cabecalho nem o separador?
# Entao esta preenchida. So awk: nao depende de python3 nem de jq.
secao_preenchida() {
  awk '
    /^[[:space:]]*#/ {
      if (dentro) exit
      if (tolower($0) ~ /plano de mensura/) dentro = 1
      next
    }
    dentro {
      linha = $0
      if (linha ~ /^[[:space:]]*$/) next
      if (coment) { if (index(linha, "-->")) coment = 0; next }
      if (linha ~ /^[[:space:]]*<!--/) { if (!index(linha, "-->")) coment = 1; next }
      if (index(linha, "|") == 0) next
      nu = linha; gsub(/[ \t|:-]/, "", nu)
      if (nu == "") { sep = 1; next }   # separador |---|---|
      if (sep) { achou = 1; exit }      # primeira linha depois do separador
      linhas++
      if (linhas > 1) { achou = 1; exit }
    }
    END { exit (achou ? 0 : 1) }
  ' "$1"
}

# Procura o CRO.md ate 2 niveis abaixo da raiz do projeto.
CRO=""
for f in $(find "$PROJ" -maxdepth 2 -iname 'CRO.md' 2>/dev/null); do
  CRO="$f"
  if secao_preenchida "$f"; then
    exit 0
  fi
done

# --- bloqueio ---------------------------------------------------------------
{
  echo "BLOQUEADO pelo hook sem-plano-sem-hipotese."
  echo
  if [ -z "$CRO" ]; then
    echo "Nao existe CRO.md neste projeto ($PROJ)."
  else
    echo "O CRO.md existe ($CRO), mas a secao \"Plano de mensuracao\" esta vazia:"
    echo "so tem o comentario de instrucao e o cabecalho da tabela."
  fi
  echo "Sem saber o que medir, nao da pra gerar hipotese."
  echo
  echo "Como resolver:"
  echo "  1. Abra o CRO.md na raiz do projeto (o modelo esta em aluno/CRO.md)."
  echo "  2. Na secao \"Plano de mensuracao\", escreva o KPI primario e"
  echo "     preencha a tabela: etapa | evento | onde mede."
  echo "  3. Rode a skill hipotese-estruturada de novo."
} >&2
exit 2

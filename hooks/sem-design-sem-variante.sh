#!/bin/bash
# ---------------------------------------------------------------------------
# Hook UserPromptSubmit + PreToolUse: sem-design-sem-variante
#
# Bloqueia a skill `variante-builder` e a escrita de arquivos de variante
# (variante*.html / .css / .js) enquanto nao existir `DESIGN.md` no projeto.
#
# A regra: variante sem design system vira Frankenstein visual — o teste
# mede o estranhamento, nao a hipotese.
#
# Protocolo (Claude Code 2.1.x): payload JSON no stdin; bloqueio = mensagem
# no stderr + exit 2. Escuta UserPromptSubmit (aluno digita o comando, campo
# prompt) e PreToolUse (modelo chama a ferramenta, campo tool_name).
# ---------------------------------------------------------------------------

PAYLOAD=$(cat)

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
    _k=""
    for _a in "$@"; do _k="$_a"; done
    printf '%s' "$PAYLOAD" \
      | sed -n 's/.*"'"$_k"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
      | head -n 1
  fi
}

EVENTO=$(json_get hook_event_name)
MOTIVO=""

if [ "$EVENTO" = "UserPromptSubmit" ]; then
  # O aluno digitou o comando: a skill e expandida direto no prompt e a
  # ferramenta Skill nunca e chamada. Mesmo guardrail, outro evento.
  case "$(json_get prompt)" in
    /cro-ai-day:variante-builder*|/variante-builder*) MOTIVO="a skill variante-builder" ;;
  esac
else
  case "$(json_get tool_name)" in
    Skill)
      case "$(json_get tool_input skill)" in
        *variante-builder*) MOTIVO="a skill variante-builder" ;;
      esac
      ;;
    Write|Edit|NotebookEdit)
      ARQ=$(json_get tool_input file_path)
      BASE=$(basename "$ARQ" 2>/dev/null)
      # variante*.html, variante*.css, variante*.js (case-insensitive)
      if printf '%s' "$BASE" | grep -qiE '^variante.*\.(html|css|js)$'; then
        MOTIVO="escrever o arquivo de variante $BASE"
      fi
      ;;
  esac
fi

[ -n "$MOTIVO" ] || exit 0

# --- diretorio do projeto ---------------------------------------------------
PROJ=$(json_get cwd)
[ -n "$PROJ" ] || PROJ="${CLAUDE_PROJECT_DIR:-$PWD}"

DESIGN=$(find "$PROJ" -maxdepth 2 -iname 'DESIGN.md' 2>/dev/null | head -n 1)
[ -n "$DESIGN" ] && exit 0

# --- bloqueio ---------------------------------------------------------------
{
  echo "BLOQUEADO pelo hook sem-design-sem-variante."
  echo
  echo "Voce pediu $MOTIVO, mas nao existe DESIGN.md neste projeto ($PROJ)."
  echo "Sem o design system extraido, a variante sai com cor, fonte e espacamento"
  echo "que nao sao do site — e o teste passa a medir estranhamento."
  echo
  echo "Como resolver:"
  echo "  1. Rode a skill detecta-design-system na pagina do teste."
  echo "  2. Ela gera o DESIGN.md (tokens de cor, tipografia, espacamento, botoes)."
  echo "  3. Repita o que voce ia fazer."
} >&2
exit 2

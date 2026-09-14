#!/bin/bash
# ---------------------------------------------------------------------------
# Hook PreToolUse: sem-srm-sem-resultado
#
# Bloqueia qualquer comando que leia resultado de teste A/B (conversao, lift,
# coluna `converted`, banco `cro-clean.db`) enquanto a skill `srm-check` nao
# tiver rodado e dado veredito verde neste projeto.
#
# A regra: teste com Sample Ratio Mismatch nao tem resultado pra ler.
#
# Marcador: a skill srm-check grava `.cro/srm-ok` no diretorio do projeto
# quando o veredito e verde. Este hook so checa a existencia do arquivo.
#
# Protocolo (Claude Code 2.1.x): payload JSON no stdin; bloqueio = mensagem
# no stderr + exit 2.
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

TOOL=$(json_get tool_name)
case "$TOOL" in
  Bash) ALVO=$(json_get tool_input command) ;;
  Read|Grep) ALVO=$(json_get tool_input file_path)$(json_get tool_input path) ;;
  *) exit 0 ;;
esac

# Se a extracao falhou, usa o payload cru — so precisamos detectar palavras.
[ -n "$ALVO" ] || ALVO="$PAYLOAD"

# --- excecao: o proprio SRM check precisa poder ler o banco -----------------
# A consulta de distribuicao usa session_start; a skill tambem grava o
# marcador. Nenhum dos dois e leitura de resultado.
if printf '%s' "$ALVO" | grep -qiE 'srm|session_start'; then
  exit 0
fi

# --- o comando le resultado de teste? --------------------------------------
# grep -E so com ASCII (portatil); a palavra acentuada vai num grep -F a parte.
if ! printf '%s' "$ALVO" | grep -qiE 'converted|conversion|conversao|lift|cro-clean\.db' \
   && ! printf '%s' "$ALVO" | grep -qiF 'conversão'; then
  exit 0
fi

# --- o marcador existe? -----------------------------------------------------
PROJ=$(json_get cwd)
[ -n "$PROJ" ] || PROJ="${CLAUDE_PROJECT_DIR:-$PWD}"

if [ -f "$PROJ/.cro/srm-ok" ]; then
  exit 0
fi

# --- bloqueio ---------------------------------------------------------------
{
  echo "BLOQUEADO pelo hook sem-srm-sem-resultado."
  echo
  echo "Esse comando le resultado de teste A/B, mas o SRM ainda nao foi"
  echo "validado neste projeto ($PROJ). Teste com Sample Ratio Mismatch nao"
  echo "tem resultado pra ler — tem bug de distribuicao."
  echo
  echo "Como resolver:"
  echo "  1. Rode a skill srm-check."
  echo "  2. Se o veredito for verde, ela grava .cro/srm-ok e este hook libera."
  echo "  3. Se for amarelo ou vermelho, corrija a distribuicao antes."
} >&2
exit 2

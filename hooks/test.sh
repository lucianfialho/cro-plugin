#!/bin/bash
# ---------------------------------------------------------------------------
# test.sh — roda os casos de cada hook (bloqueio, liberacao e regressao).
# Nao precisa do Claude: manda o JSON no stdin do script, como o Claude faria.
# Uso: bash test.sh
# ---------------------------------------------------------------------------

HOOKS=$(cd "$(dirname "$0")" && pwd)
BOX=$(mktemp -d 2>/dev/null || mktemp -d -t crohooks)
OK=0
FALHOU=0

# Monta um projeto de mentira em $BOX/<nome> e ecoa o caminho.
projeto() { mkdir -p "$BOX/$1"; printf '%s' "$BOX/$1"; }

# checa <titulo> <script> <json> <esperado: 0=passa 2=bloqueia>
checa() {
  titulo="$1"; script="$2"; payload="$3"; esperado="$4"
  saida=$(printf '%s' "$payload" | bash "$HOOKS/$script" 2>&1)
  codigo=$?
  if [ "$codigo" = "$esperado" ]; then
    OK=$((OK+1)); printf 'PASS  %s\n' "$titulo"
  else
    FALHOU=$((FALHOU+1))
    printf 'FAIL  %s (esperava exit %s, veio %s)\n' "$titulo" "$esperado" "$codigo"
    printf '      saida: %s\n' "$(printf '%s' "$saida" | head -n 2 | tr '\n' ' ')"
  fi
}

echo "Sandbox: $BOX"
echo

# --- 1. sem-plano-sem-hipotese ----------------------------------------------
# O payload e sempre o mesmo; o que muda e o CRO.md dentro do projeto.
hipotese() { printf '{"cwd":"%s","hook_event_name":"PreToolUse","tool_name":"Skill","tool_input":{"skill":"hipotese-estruturada"}}' "$1"; }

P=$(projeto sem-cro)
checa "sem-plano-sem-hipotese  BLOQUEIA sem CRO.md" \
  sem-plano-sem-hipotese.sh "$(hipotese "$P")" 2

P=$(projeto cro-vazio)
cat > "$P/CRO.md" <<'FIM'
## 3. Plano de mensuracao
<!-- KPI primario e guardrail; depois um evento por etapa e onde voce le o numero. -->

| Etapa | Evento | Onde mede |
|---|---|---|

## 4. Segmentos que importam
FIM
checa "sem-plano-sem-hipotese  BLOQUEIA com a secao so no cabecalho" \
  sem-plano-sem-hipotese.sh "$(hipotese "$P")" 2

P=$(projeto cro-template-cru)
cat "$(dirname "$0")/../aluno/CRO.md" > "$P/CRO.md"
checa "sem-plano-sem-hipotese  BLOQUEIA com o template do aluno sem editar" \
  sem-plano-sem-hipotese.sh "$(hipotese "$P")" 2

P=$(projeto cro-preenchido)
cat > "$P/CRO.md" <<'FIM'
## 3. Plano de mensuracao
<!-- KPI primario e guardrail; depois um evento por etapa e onde voce le o numero. -->
KPI primario: conversao sessao->pedido.

| Etapa | Evento | Onde mede |
|---|---|---|
| Pagina de produto | view_item | GA4 |

## 4. Segmentos que importam
FIM
checa "sem-plano-sem-hipotese  PASSA com a secao preenchida" \
  sem-plano-sem-hipotese.sh "$(hipotese "$P")" 0

# --- 2. sem-srm-sem-resultado -----------------------------------------------
P=$(projeto sem-srm)
CMD="duckdb data/cro-clean.db -c 'SELECT variant, AVG(converted) FROM events'"
checa "sem-srm-sem-resultado   BLOQUEIA leitura de conversao sem .cro/srm-ok" \
  sem-srm-sem-resultado.sh \
  "{\"cwd\":\"$P\",\"hook_event_name\":\"PreToolUse\",\"tool_name\":\"Bash\",\"tool_input\":{\"command\":\"$CMD\"}}" 2

P=$(projeto com-srm); mkdir -p "$P/.cro"; echo "SRM_OK 2026-09-14" > "$P/.cro/srm-ok"
checa "sem-srm-sem-resultado   PASSA com .cro/srm-ok gravado" \
  sem-srm-sem-resultado.sh \
  "{\"cwd\":\"$P\",\"hook_event_name\":\"PreToolUse\",\"tool_name\":\"Bash\",\"tool_input\":{\"command\":\"$CMD\"}}" 0

# --- 3. sem-design-sem-variante ---------------------------------------------
P=$(projeto sem-design)
checa "sem-design-sem-variante BLOQUEIA variante-builder sem DESIGN.md" \
  sem-design-sem-variante.sh \
  "{\"cwd\":\"$P\",\"hook_event_name\":\"PreToolUse\",\"tool_name\":\"Skill\",\"tool_input\":{\"skill\":\"variante-builder\"}}" 2

P=$(projeto com-design); : > "$P/DESIGN.md"
checa "sem-design-sem-variante PASSA com DESIGN.md (Write de variante-b.js)" \
  sem-design-sem-variante.sh \
  "{\"cwd\":\"$P\",\"hook_event_name\":\"PreToolUse\",\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$P/variante-b.js\",\"content\":\"x\"}}" 0

# --- extras de regressao ----------------------------------------------------
P=$(projeto sem-design)
checa "sem-design-sem-variante BLOQUEIA Write de variante-b.js sem DESIGN.md" \
  sem-design-sem-variante.sh \
  "{\"cwd\":\"$P\",\"hook_event_name\":\"PreToolUse\",\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"$P/variante-b.js\",\"content\":\"x\"}}" 2

P=$(projeto sem-srm)
checa "sem-srm-sem-resultado   NAO atrapalha o proprio srm-check" \
  sem-srm-sem-resultado.sh \
  "{\"cwd\":\"$P\",\"hook_event_name\":\"PreToolUse\",\"tool_name\":\"Bash\",\"tool_input\":{\"command\":\"duckdb data/cro.db -c \\\"SELECT experiment_variant, COUNT(*) FROM events_clean WHERE event_name='session_start' GROUP BY 1\\\"\"}}" 0

checa "sem-plano-sem-hipotese  ignora skill que nao e a dele" \
  sem-plano-sem-hipotese.sh \
  "{\"cwd\":\"$P\",\"hook_event_name\":\"PreToolUse\",\"tool_name\":\"Skill\",\"tool_input\":{\"skill\":\"ice-score\"}}" 0

# --- 4. o aluno digita o comando (UserPromptSubmit) -------------------------
# A skill digitada e expandida no prompt: a ferramenta Skill nao e chamada e o
# PreToolUse nao dispara. O hook tem que pegar o prompt tambem, senao o aluno
# passa por cima do guardrail so por digitar o comando.
digitou() { printf '{"cwd":"%s","hook_event_name":"UserPromptSubmit","prompt":"%s"}' "$1" "$2"; }

P=$(projeto sem-cro)
checa "sem-plano-sem-hipotese  BLOQUEIA /cro-ai-day:hipotese-estruturada digitado sem CRO.md" \
  sem-plano-sem-hipotese.sh "$(digitou "$P" "/cro-ai-day:hipotese-estruturada")" 2

P=$(projeto cro-preenchido)
checa "sem-plano-sem-hipotese  PASSA /cro-ai-day:hipotese-estruturada digitado com a secao preenchida" \
  sem-plano-sem-hipotese.sh "$(digitou "$P" "/cro-ai-day:hipotese-estruturada")" 0

checa "sem-plano-sem-hipotese  ignora prompt comum (oi)" \
  sem-plano-sem-hipotese.sh "$(digitou "$(projeto sem-cro)" "oi")" 0

P=$(projeto sem-design)
checa "sem-design-sem-variante BLOQUEIA /cro-ai-day:variante-builder digitado sem DESIGN.md" \
  sem-design-sem-variante.sh "$(digitou "$P" "/cro-ai-day:variante-builder")" 2

P=$(projeto com-design)
checa "sem-design-sem-variante PASSA /cro-ai-day:variante-builder digitado com DESIGN.md" \
  sem-design-sem-variante.sh "$(digitou "$P" "/cro-ai-day:variante-builder")" 0

checa "sem-design-sem-variante ignora prompt comum (oi)" \
  sem-design-sem-variante.sh "$(digitou "$(projeto sem-design)" "oi")" 0

echo
echo "-----------------------------------------"
echo "PASS: $OK   FAIL: $FALHOU"
[ "$FALHOU" = 0 ] || exit 1

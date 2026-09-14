#!/usr/bin/env bash
# Hook PreToolUse do plugin cro: só age quando a skill cro-md vai rodar.
# Bloqueia se a pasta atual for a home, Desktop, Downloads, Documentos ou a raiz:
# o CRO.md tem que nascer dentro da pasta do projeto, não no meio dos seus arquivos.
# Sai com 2 + mensagem no stderr = Claude Code cancela a skill e mostra o motivo.

entrada="$(cat)"

campo() {
  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$entrada" | python3 -c '
import json,sys
d=json.load(sys.stdin); k=sys.argv[1]
v=d.get(k) if k!="skill" else (d.get("tool_input") or {}).get("skill","")
print(v if isinstance(v,str) else "")' "$1" 2>/dev/null
  else
    printf '%s' "$entrada" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -1
  fi
}

ferramenta="$(campo tool_name)"
skill="$(campo skill)"
pasta="$(campo cwd)"
[ -z "$pasta" ] && pasta="$PWD"

[ "$ferramenta" = "Skill" ] || exit 0
case "$skill" in *cro-md*) ;; *) exit 0 ;; esac

home="${HOME%/}"
nome="$(basename "$pasta")"
pai="$(dirname "$pasta")"

bloqueia=0
[ "$pasta" = "$home" ] && bloqueia=1
[ "$pasta" = "/" ] && bloqueia=1
if [ "$pai" = "$home" ]; then
  case "$nome" in
    Desktop|Downloads|Documents|Documentos|Transferências|"Área de Trabalho"|Library|Pictures|Music|Movies) bloqueia=1 ;;
  esac
fi

[ "$bloqueia" = 1 ] || exit 0

cat >&2 <<MSG
Você está em: $pasta
Essa não é a pasta de um projeto, é a pasta geral do seu computador. O CRO.md precisa
nascer dentro do projeto, pra o Claude ler ele toda vez que abrir ali.

O que fazer:
  1. sai do Claude (/exit)
  2. cria e entra na pasta do projeto:   mkdir meu-projeto  →  cd meu-projeto
  3. abre de novo:                     claude
  4. roda /cro:cro-md outra vez
MSG
exit 2

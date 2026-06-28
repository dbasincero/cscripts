#!/usr/bin/env bash
# summarize_errors.sh — resume erros ORA-/PLS-/SP2- dos logs do run_review.sh
# e gera um diff entre 19c e 26ai.
#
# Uso:
#   ./harness/summarize_errors.sh [dir_de_logs]      (default: reports)
#
# Espera logs nomeados:  <dir>/ora19c__<script>.log  e  <dir>/ora26ai__<script>.log
# Gera:  <dir>/SUMARIO_ORA.md  (e imprime na tela)
#
# Portatil (bash 3.2 do macOS): sem mapfile / arrays associativos; usa awk.
set -euo pipefail
DIR="${1:-reports}"
OUT="$DIR/SUMARIO_ORA.md"
RE='(ORA|PLS|SP2)-[0-9]+'

if ! ls "$DIR"/ora19c__*.log "$DIR"/ora26ai__*.log >/dev/null 2>&1; then
  echo "Nenhum log em '$DIR' (esperado ora19c__*.log / ora26ai__*.log)."
  echo "Rode primeiro:  ./harness/run_review.sh"
  exit 1
fi

# '|| true' evita que o pipefail aborte quando o grep nao encontra nada
count_glob() { { grep -hoE "$RE" "$@" 2>/dev/null || true; } | wc -l | tr -d ' '; }
codes_cc()   { { grep -hoE "$RE" "$@" 2>/dev/null || true; } | sort | uniq -c | awk '{print $2" "$1}'; }

T19=$(count_glob "$DIR"/ora19c__*.log)
T26=$(count_glob "$DIR"/ora26ai__*.log)
N19=$(ls "$DIR"/ora19c__*.log 2>/dev/null | wc -l | tr -d ' ')
N26=$(ls "$DIR"/ora26ai__*.log 2>/dev/null | wc -l | tr -d ' ')

tmp=$(mktemp -d)
codes_cc "$DIR"/ora19c__*.log  > "$tmp/c19"
codes_cc "$DIR"/ora26ai__*.log > "$tmp/c26"

# merge dos codigos (codigo | n19 | n26), classificado
MERGE=$(awk '
  NR==FNR{a[$1]=$2; next}
  {b[$1]=$2}
  END{ for(k in a)s[k]=1; for(k in b)s[k]=1;
       for(k in s) printf "%s %d %d\n", k, a[k]+0, b[k]+0 }
' "$tmp/c19" "$tmp/c26" | sort)

{
  echo "# Sumário de erros ORA-/PLS-/SP2- — 19c × 26ai"
  echo
  echo "| Versão | Logs | Ocorrências de erro |"
  echo "|--------|------|---------------------|"
  echo "| 19c    | $N19 | $T19 |"
  echo "| 26ai   | $N26 | $T26 |"
  echo
  echo "## Top códigos por versão"
  echo
  echo "### 19c (top 20)"
  echo '```'
  sort -k2 -rn "$tmp/c19" | head -20 | awk '{printf "%-12s %s\n",$1,$2}'
  echo '```'
  echo "### 26ai (top 20)"
  echo '```'
  sort -k2 -rn "$tmp/c26" | head -20 | awk '{printf "%-12s %s\n",$1,$2}'
  echo '```'
  echo
  echo "## Diff de códigos (foco em compatibilidade)"
  echo
  echo "### Só no 26ai (regressões potenciais ao migrar)"
  echo '```'
  echo "$MERGE" | awk '$2==0 && $3>0 {printf "%-12s 26ai=%s\n",$1,$3}'
  echo '```'
  echo "### Só no 19c (resolvidos/ausentes em 26ai)"
  echo '```'
  echo "$MERGE" | awk '$3==0 && $2>0 {printf "%-12s 19c=%s\n",$1,$2}'
  echo '```'
  echo "### Comuns às duas (código | 19c | 26ai)"
  echo '```'
  echo "$MERGE" | awk '$2>0 && $3>0 {printf "%-12s 19c=%-6s 26ai=%s\n",$1,$2,$3}'
  echo '```'
  echo
  echo "## Scripts com erro em só uma versão (possível diferença de comportamento)"
  echo '```'
  for f in "$DIR"/ora19c__*.log; do
    [ -e "$f" ] || continue
    s=$(basename "$f"); s=${s#ora19c__}; s=${s%.log}
    [ "$s" = "env_check" ] && continue
    e19=$(count_glob "$DIR/ora19c__$s.log")
    if [ -e "$DIR/ora26ai__$s.log" ]; then e26=$(count_glob "$DIR/ora26ai__$s.log"); else e26=0; fi
    if [ "${e19:-0}" != "${e26:-0}" ]; then
      printf "%-48s 19c=%-4s 26ai=%-4s\n" "$s" "${e19:-0}" "${e26:-0}"
    fi
  done
  echo '```'
  echo
  echo "_Gerado por summarize_errors.sh. Erros num banco novo são esperados"
  echo "(AWR/ASH vazios, objetos internos além dos stubs, Diagnostic Pack)._"
} | tee "$OUT"

rm -rf "$tmp"
echo
echo ">> Sumário salvo em: $OUT"

#!/usr/bin/env bash
# run_review.sh — aplica stubs, roda env-check e um smoke read-only dos cscripts
# nos dois bancos (19c e 26ai), capturando erros ORA-/SP2-/PLS- por versão.
#
# Uso (a partir de local/):
#   ./harness/run_review.sh            # smoke do conjunto representativo
#   ./harness/run_review.sh --all      # roda toda a lista autonomous_scripts.txt
#   ./harness/run_review.sh --stubs    # só (re)cria os stubs internos
#
# Requer: docker compose com os serviços ora19c/ora26ai no ar e saudáveis.
set -euo pipefail
cd "$(dirname "$0")/.."
[ -f .env ] && set -a && . ./.env && set +a

: "${ORACLE_PWD:?defina ORACLE_PWD no .env}"
OUT="reports"; mkdir -p "$OUT"
HARNESS=/cscripts/local/harness          # caminho DENTRO do container (repo montado em /cscripts)
STUBS=/cscripts/local/stubs

# serviço -> "serviço|service_name|pasta_scripts|pdb_service"
TARGETS=(
  "ora19c|ORCLCDB|/cscripts/19c|ORCLPDB1"
  "ora26ai|FREE|/cscripts/26ai|FREEPDB1"
)

# Conjunto representativo read-only (cobre v$, ASH, AWR, espaço, métricas).
SMOKE_SET=(
  hf_active_sessions.sql hf_ash_analytics.sql hf_top.sql hf_latency.sql
  hf_average_active_sessions.sql cdb_tablespace_usage_metrics.sql
  hf_pdbs.sql hf_cpu_demand.sql hf_maximum_active_sessions.sql hf_dg.sql
)

sqlp() { # sqlp <service> <connect_as: sysdba|app> <<<script
  local svc="$1" mode="$2"
  if [ "$mode" = "sysdba" ]; then
    docker compose exec -T "$svc" sqlplus -S -L "sys/${ORACLE_PWD}@//localhost:1521/$3" as sysdba
  else
    docker compose exec -T "$svc" sqlplus -S -L "system/${ORACLE_PWD}@//localhost:1521/$3"
  fi
}

apply_stubs() {
  local svc="$1" cdb="$2" pdb="$3"
  echo ">> stubs em $svc ($cdb e $pdb)"
  for srv in "$cdb" "$pdb"; do
    sqlp "$svc" sysdba "$srv" <<SQL || true
@${STUBS}/hf_internal_stubs.sql
EXIT
SQL
  done
}

run_one() { # run_one <svc> <pdb_service> <scripts_dir> <script>
  local svc="$1" srv="$2" dir="$3" scr="$4"
  local log="$OUT/${svc}__${scr}.log"
  # wrapper: pre-define variáveis comuns p/ evitar prompts; erros não abortam
  timeout 180 bash -c "docker compose exec -T $svc sqlplus -S -L system/${ORACLE_PWD}@//localhost:1521/$srv <<SQL > '$log' 2>&1
WHENEVER SQLERROR CONTINUE
WHENEVER OSERROR CONTINUE
SET ECHO OFF TERM ON TIMING OFF DEFINE ON
DEF cs_reference=LOCAL-LAB
DEF cs_sql_id=0000000000000
DEF 1=LOCAL-LAB
DEF 2=0000000000000
DEF cs_con_name=$( [ "$srv" = ORCLPDB1 ] && echo ORCLPDB1 || echo FREEPDB1 )
host cd $dir
@$dir/$scr
EXIT
SQL" || echo "  (timeout/erro de execução em $scr)"
  # conta erros
  local n; n=$(grep -cE 'ORA-|SP2-|PLS-' "$log" 2>/dev/null || true)
  printf '  %-45s erros=%s\n' "$scr" "${n:-0}"
}

# Modo padrao = --all (roda toda a lista autonomous_scripts.txt, ~225 read-only).
# Use --smoke p/ o conjunto representativo, --stubs p/ so (re)criar os stubs.
mode="${1:---all}"
# carrega a lista autonoma sem 'mapfile' (compativel com bash 3.2 do macOS)
LIST_ALL=()
while IFS= read -r line; do [ -n "$line" ] && LIST_ALL+=("$line"); done < harness/autonomous_scripts.txt

for t in "${TARGETS[@]}"; do
  IFS='|' read -r svc cdb dir pdb <<<"$t"
  echo "================ $svc ($dir) ================"
  apply_stubs "$svc" "$cdb" "$pdb"
  [ "$mode" = "--stubs" ] && continue
  echo ">> env-check"
  sqlp "$svc" sysdba "$pdb" <<SQL > "$OUT/${svc}__env_check.log" 2>&1 || true
@${HARNESS}/00_env_check.sql
EXIT
SQL
  if [ "$mode" = "--smoke" ]; then LIST=("${SMOKE_SET[@]}"); else LIST=("${LIST_ALL[@]}"); fi
  echo ">> executando ${#LIST[@]} scripts (modo $mode)"
  for scr in "${LIST[@]}"; do
    [ -n "$scr" ] && run_one "$svc" "$pdb" "$dir" "$scr"
  done
done

# Resumo + diff 19c x 26ai (gera reports/SUMARIO_ORA.md)
[ "$mode" = "--stubs" ] || ./harness/summarize_errors.sh "$OUT"

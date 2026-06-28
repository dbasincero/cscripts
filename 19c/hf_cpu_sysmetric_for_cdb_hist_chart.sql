--==========================================================================
-- Script    : hf_cpu_sysmetric_for_cdb_hist_chart.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Métricas de Sistema de CPU conforme View
--             DBA_HIST_SYSMETRIC_SUMMARY para um CDB (gráfico de série
--             temporal)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- hf_cpu_sysmetric_for_cdb_hist_chart.sql - CPU System Metrics as per DBA_HIST_SYSMETRIC_SUMMARY View for a CDB (time series chart)
@@hf_some_sysmetric_for_cdb_hist_chart.sql "" "" "CentiSeconds Per Second" "Database Time Per Sec" "Host CPU Usage Per Sec" "Background CPU Usage Per Sec" "CPU Usage Per Sec" "" "" "average" "Scatter" "none"

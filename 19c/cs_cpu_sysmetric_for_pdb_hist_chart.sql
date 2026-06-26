--==========================================================================
-- Script    : cs_cpu_sysmetric_for_pdb_hist_chart.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Métricas de Sistema de CPU conforme View
--             DBA_HIST_CON_SYSMETRIC_SUMM para um PDB (gráfico de série
--             temporal)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- cs_cpu_sysmetric_for_pdb_hist_chart.sql - CPU System Metrics as per DBA_HIST_CON_SYSMETRIC_SUMM View for a PDB (time series chart)
@@cs_some_sysmetric_for_pdb_hist_chart.sql "" "" "CentiSeconds Per Second" "CPU Usage Per Sec" "" "" "" "" "" "average" "Scatter" "none"
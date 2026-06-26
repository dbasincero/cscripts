--==========================================================================
-- Script    : cs_cpu_sysmetric_for_pdb_mem_chart.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Métricas de Sistema de CPU conforme View
--             V$CON_SYSMETRIC_HISTORY para um PDB (gráfico de série
--             temporal)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- cs_cpu_sysmetric_for_pdb_mem_chart.sql - CPU System Metrics as per V$CON_SYSMETRIC_HISTORY View for a PDB (time series chart)
@@cs_some_sysmetric_for_pdb_mem_chart.sql "CentiSeconds Per Second" "CPU Usage Per Sec" "" "" "" "" "" "Scatter"
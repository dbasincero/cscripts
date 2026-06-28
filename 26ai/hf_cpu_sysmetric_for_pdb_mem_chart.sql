--==========================================================================
-- Script    : hf_cpu_sysmetric_for_pdb_mem_chart.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Métricas de Sistema de CPU conforme View
--             V$CON_SYSMETRIC_HISTORY para um PDB (gráfico de série
--             temporal)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- hf_cpu_sysmetric_for_pdb_mem_chart.sql - CPU System Metrics as per V$CON_SYSMETRIC_HISTORY View for a PDB (time series chart)
@@hf_some_sysmetric_for_pdb_mem_chart.sql "CentiSeconds Per Second" "CPU Usage Per Sec" "" "" "" "" "" "Scatter"
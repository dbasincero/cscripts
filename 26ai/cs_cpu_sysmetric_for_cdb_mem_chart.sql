--==========================================================================
-- Script    : cs_cpu_sysmetric_for_cdb_mem_chart.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Métricas de Sistema de CPU conforme View V$SYSMETRIC_HISTORY
--             para um CDB (gráfico de série temporal)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- cs_cpu_sysmetric_for_cdb_mem_chart.sql - CPU System Metrics as per V$SYSMETRIC_HISTORY View for a CDB (time series chart)
@@cs_some_sysmetric_for_cdb_mem_chart.sql "CentiSeconds Per Second" "Database Time Per Sec" "Host CPU Usage Per Sec" "Background CPU Usage Per Sec" "CPU Usage Per Sec" "" "" "Scatter"
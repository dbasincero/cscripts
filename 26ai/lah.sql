--==========================================================================
-- Script    : lah.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Latência de SQL atual e histórica (tempo de CPU por execução)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
DEF cs_top = '20';
--
@@cs_internal/hf_latency_hist_internal_1.sql
@@cs_internal/hf_latency_hist_internal_2.sql
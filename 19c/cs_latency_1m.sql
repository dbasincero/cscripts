--==========================================================================
-- Script    : cs_latency_1m.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Latência de SQL do último 1m (tempo decorrido por execução)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
@@cs_latency_range_iod.sql "-1m" ""
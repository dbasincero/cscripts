--==========================================================================
-- Script    : cs_diag_trace.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Caminho do diretório para traces
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
select value from v$diag_info where name = 'Diag Trace';
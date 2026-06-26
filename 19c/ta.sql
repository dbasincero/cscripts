--==========================================================================
-- Script    : ta.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Top SQL ativo conforme Active Sessions History ASH - último
--             1m
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
DEF cs_minutes = '1';
DEF cs_top = '30';
@@cs_internal/cs_top_activity_internal.sql
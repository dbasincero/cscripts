--==========================================================================
-- Script    : cs_reset.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
--SET HEA ON LIN 270 PAGES 60 TAB ON FEED ON ECHO OFF VER ON TRIMS OFF TRIM ON TI OFF TIMI OFF LONG 24000 LONGC 240 SERVEROUT OFF;
SET TERM OFF;
@"/tmp/cs_store_set.sql"
CLEAR BREAK COLUMNS COMPUTE;
SET TERM ON;
--

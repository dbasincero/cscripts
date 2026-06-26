--==========================================================================
-- Script    : cs_primary.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- warn if executed not on MOUNTED or READ ONLY
SET TAB OFF FEED OFF ECHO OFF VER OFF;
COL open_mode NEW_V open_mode NOPRI;
COL database_role NEW_V database_role NOPRI;
COL dynamic_script NEW_V dynamic_script NOPRI;
SELECT open_mode, database_role, CASE WHEN open_mode = 'READ WRITE' AND database_role = 'PRIMARY' THEN 'cs_null.sql' ELSE 'cs_primary_warn.sql' END AS dynamic_script FROM v$database
/
@@&&dynamic_script.

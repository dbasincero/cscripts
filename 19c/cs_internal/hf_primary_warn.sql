--==========================================================================
-- Script    : hf_primary_warn.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO ***
PRO *** v$database.open_mode    : &&open_mode.
PRO *** v$database.database_role: &&database_role.
PRO *** 
PRO
PAUSE Hit "return" to continue; or "control-c" then "return" to exit: 
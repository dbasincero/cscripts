--==========================================================================
-- Script    : cs_spool_head.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Seguranca  : gera arquivo via SPOOL
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SELECT REPLACE('&&cs_file_name.', '$') AS cs_file_name FROM DUAL;
--
EXEC :cs_begin_elapsed_time := DBMS_UTILITY.get_time;
--
SPO &&cs_file_name..txt
PRO /* ---------------------------------------------------------------------------------------------- */
PRO &&cs_file_name..txt
PRO
--
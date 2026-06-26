--==========================================================================
-- Script    : cs_print_sql_text.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SET HEA OFF;
-- PRINT :cs_sql_text
PRINT :cs_zapper_managed_sql_banner
SET HEA ON;
--==========================================================================
-- Script    : cs_set_container_to_cdb_root.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
COMMIT;
ALTER SESSION SET container = CDB$ROOT;

--==========================================================================
-- Script    : cs_temp_dir_create.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
HOS mkdir -p &&cs_temp_dir.
CREATE OR REPLACE DIRECTORY CS_TEMP_DIR AS '&&cs_temp_dir.';

--==========================================================================
-- Script    : hf_set_container_to_curr_pdb.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : &&cs_con_name
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
COMMIT;
ALTER SESSION SET CONTAINER = &&cs_con_name.;
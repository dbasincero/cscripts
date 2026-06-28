--==========================================================================
-- Script    : hf_spool_id_list_sql_id.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : &&cs_signature, &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO SQL_ID       : &&cs_sql_id.
PRO SQL_HV       : &&cs_sql_hv.
PRO SIGNATURE    : &&cs_signature.
PRO SQL_HANDLE   : &&cs_sql_handle.
PRO APPLICATION  : &&cs_application_category.
PRO TABLE_OWNER  : &&table_owner.
PRO TABLE_NAME   : &&table_name.
PRO FIRST_ROWS   : &&cs_first_rows_candidacy. (Y=Good Candidate, N=Bad Candidate)
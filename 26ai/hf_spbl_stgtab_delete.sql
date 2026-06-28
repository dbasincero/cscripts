--==========================================================================
-- Script    : hf_spbl_stgtab_delete.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Exclui Tabela de Staging para SQL Plan Baselines
-- Variaveis  : posicionais &1; &&cs_signature, &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spbl_stgtab_delete.sql
--
-- Purpose:     Deletes Staging Table for SQL Plan Baselines
--
-- Author:      Carlos Sierra
--
-- Version:     2020/03/10
--
-- Usage:       Connecting into PDB.
--
--              Enter SQL_ID (opt) when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spbl_stgtab_delete.sql
--
-- Notes:       *** Requires Oracle Diagnostics Pack License ***
--
--              Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_primary.sql
@@cs_internal/hf_cdb_warn.sql
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
@@cs_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_spbl_stgtab_delete';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
PRO 1. SQL_ID (opt): 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
@@cs_internal/hf_signature.sql
--
PRO
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." 
@@cs_internal/hf_spool_id.sql
--
PRO SQL_ID       : &&cs_sql_id.
PRO SIGNATURE    : &&cs_signature.
PRO SQL_HANDLE   : &&cs_sql_handle.
--
@@cs_internal/hf_print_sql_text.sql
@@cs_internal/hf_spbl_internal_stgtab.sql
@@cs_internal/hf_spbl_internal_stgtab_delete.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." 
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

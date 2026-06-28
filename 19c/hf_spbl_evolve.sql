--==========================================================================
-- Script    : hf_spbl_evolve.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Evolui um SQL Plan Baseline para um dado SQL_ID
-- Variaveis  : posicionais &1; &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spbl_evolve.sql
--
-- Purpose:     Evolve a SQL Plan Baseline for given SQL_ID
--
-- Author:      Carlos Sierra
--
-- Version:     2023/04/27
--
-- Usage:       Connecting into PDB.
--
--              Enter SQL_ID when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spbl_evolve.sql
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
DEF cs_script_name = 'cs_spbl_evolve';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
@@cs_internal/hf_signature.sql
@@cs_internal/&&cs_zapper_managed.
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
-- preserves curren time since new baselines will have more recent creation than this:
COL creation_time NEW_V creation_time NOPRI;
SELECT TO_CHAR(SYSDATE, '&&cs_datetime_full_format.') AS creation_time FROM DUAL;
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id."  
@@cs_internal/hf_spool_id.sql
@@cs_internal/hf_spool_id_list_sql_id.sql
@@cs_internal/hf_print_sql_text.sql
@@cs_internal/hf_plans_performance.sql 
@@cs_internal/hf_spbl_internal_list.sql
--
PRO please wait... it may take several minutes!
@@cs_internal/hf_spbl_evolve_internal.sql
--
PRO
@@cs_internal/hf_spbl_internal_list.sql
@@cs_internal/hf_plans_performance.sql 
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." 
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

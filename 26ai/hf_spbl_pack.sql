--==========================================================================
-- Script    : hf_spbl_pack.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Empacota na tabela de staging um ou todos os SQL Plan
--             Baselines para um dado SQL_ID
-- Variaveis  : posicionais &1, &2; &&cs_signature, &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spbl_pack.sql
--
-- Purpose:     Packs into staging table one or all SQL Plan Baselines for given SQL_ID
--
-- Author:      Carlos Sierra
--
-- Version:     2023/02/28
--
-- Usage:       Connecting into PDB.
--
--              Enter SQL_ID when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spbl_pack.sql
--
-- Notes:       Accesses AWR data thus you must have an Oracle Diagnostics Pack License.
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
DEF cs_script_name = 'cs_spbl_pack';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_signature.sql
--
@@cs_internal/hf_plans_performance.sql
@@cs_internal/hf_spbl_internal_list.sql
--
PRO
PRO 2. PLAN_NAME (opt):
DEF cs_plan_name = '&2.';
UNDEF 2;
PRO
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_name."
@@cs_internal/hf_spool_id.sql
--
PRO SQL_ID       : &&cs_sql_id.
PRO SIGNATURE    : &&cs_signature.
PRO SQL_HANDLE   : &&cs_sql_handle.
PRO PLAN_NAME    : "&&cs_plan_name."
--
@@cs_internal/hf_print_sql_text.sql
@@cs_internal/hf_spbl_internal_list.sql
@@cs_internal/hf_plans_performance.sql
--
@@cs_internal/hf_spbl_internal_stgtab.sql
@@cs_internal/hf_spbl_internal_pack.sql
--
@@cs_internal/hf_spbl_internal_list.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_name."
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

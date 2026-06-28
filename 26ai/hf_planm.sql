--==========================================================================
-- Script    : hf_planm.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Planos de Execução em Memória para um dado SQL_ID
-- Atalhos    : pm.sql
-- Variaveis  : posicionais &1, &2; &&cs_plan_hash_value, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   pm.sql | hf_planm.sql
--
-- Purpose:     Execution Plans in Memory for a given SQL_ID
--
-- Author:      Carlos Sierra
--
-- Version:     2023/04/27
--
-- Usage:       Execute connected to PDB.
--
--              Enter SQL_ID when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_planx.sql
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
DEF cs_script_name = 'cs_planm';
DEF cs_script_acronym = 'pm.sql | ';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
DEF cs_plan_hash_value = '';
@@cs_internal/hf_plans_mem_1.sql
--
PRO
PRO 2. PLAN_HASH_VALUE (opt):
DEF cs_plan_hash_value = '&2.';
UNDEF 2;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_signature.sql
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_hash_value."
@@cs_internal/hf_spool_id.sql
@@cs_internal/hf_spool_id_list_sql_id.sql
--
PRO PLAN_HASH_VAL: &&cs_plan_hash_value.
--
@@cs_internal/hf_plans_mem_0.sql
@@cs_internal/hf_plans_mem_1.sql
@@cs_internal/hf_plans_mem_2.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_hash_value."
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--
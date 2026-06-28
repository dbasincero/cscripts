--==========================================================================
-- Script    : hf_planh.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Planos de Execução no AWR para um dado SQL_ID
-- Atalhos    : ph.sql
-- Variaveis  : posicionais &1, &2; &&cs_plan_hash_value, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   ph.sql | hf_planh.sql
--
-- Purpose:     Execution Plans in AWR for a given SQL_ID
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
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_planh';
DEF cs_script_acronym = 'ph.sql | ';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
DEF cs_plan_hash_value = '';
@@hf_internal/hf_plans_awr_1.sql
--
PRO
PRO 2. PLAN_HASH_VALUE (opt):
DEF cs_plan_hash_value = '&2.';
UNDEF 2;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_signature.sql
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_hash_value."
@@hf_internal/hf_spool_id.sql
@@hf_internal/hf_spool_id_list_sql_id.sql
--
PRO PLAN_HASH_VAL: &&cs_plan_hash_value.
--
@@hf_internal/hf_plans_awr_1.sql
@@hf_internal/hf_plans_awr_2.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_hash_value."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
--==========================================================================
-- Script    : hf_spbl_drop.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Remove um ou todos os SQL Plan Baselines para um dado SQL_ID
-- Variaveis  : posicionais &1, &2; &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spbl_drop.sql
--
-- Purpose:     Drop one or all SQL Plan Baselines for given SQL_ID
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
--              SQL> @hf_spbl_drop.sql
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
DEF cs_script_name = 'cs_spbl_drop';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_signature.sql
@@cs_internal/&&cs_zapper_managed.
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
@@cs_internal/hf_spool_id_list_sql_id.sql
--
PRO PLAN_NAME    : "&&cs_plan_name."
--
@@cs_internal/hf_print_sql_text.sql
@@cs_internal/hf_plans_performance.sql
@@cs_internal/hf_spbl_internal_list.sql
--
@@cs_internal/hf_spbl_internal_stgtab.sql
@@cs_internal/hf_spbl_internal_pack.sql
--
@@cs_internal/&&cs_spbl_validate.
--
PRO
PRO Drop plan: "&&cs_plan_name."
SET SERVEROUT ON;
WHENEVER SQLERROR EXIT FAILURE;
DECLARE
  l_plans INTEGER := 0;
BEGIN
  IF '&&cs_sql_handle.' IS NOT NULL OR '&&cs_plan_name.' IS NOT NULL THEN
    l_plans := DBMS_SPM.drop_sql_plan_baseline(sql_handle => '&&cs_sql_handle.', plan_name => '&&cs_plan_name.');
  END IF;
  DBMS_OUTPUT.put_line('Plans Dropped:'||l_plans);
END;
/
WHENEVER SQLERROR CONTINUE;
SET SERVEROUT OFF;
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

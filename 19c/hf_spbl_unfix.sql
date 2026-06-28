--==========================================================================
-- Script    : hf_spbl_unfix.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Desfixa um ou todos os SQL Plan Baselines para um dado SQL_ID
-- Variaveis  : posicionais &1, &2; &&cs_signature, &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spbl_unfix.sql
--
-- Purpose:     Unfix one or all SQL Plan Baselines for given SQL_ID
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
--              SQL> @hf_spbl_unfix.sql
--
-- Notes:       Accesses AWR data thus you must have an Oracle Diagnostics Pack License.
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
DEF cs_script_name = 'cs_spbl_unfix';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_signature.sql
--
@@hf_internal/hf_plans_performance.sql
@@hf_internal/hf_spbl_internal_list.sql
--
PRO
PRO 2. PLAN_NAME (opt):
DEF cs_plan_name = '&2.';
UNDEF 2;
PRO
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_name."
@@hf_internal/hf_spool_id.sql
--
PRO SQL_ID       : &&cs_sql_id.
PRO SIGNATURE    : &&cs_signature.
PRO SQL_HANDLE   : &&cs_sql_handle.
PRO PLAN_NAME    : "&&cs_plan_name."
--
@@hf_internal/hf_print_sql_text.sql
@@hf_internal/hf_spbl_internal_list.sql
@@hf_internal/hf_plans_performance.sql
--
PRO
PRO Unfix plan: "&&cs_plan_name."
DECLARE
  l_plans INTEGER;
BEGIN
  FOR i IN (SELECT sql_handle, signature, plan_name, description 
              FROM dba_sql_plan_baselines 
             WHERE signature = &&cs_signature.
               AND fixed = 'YES'
               AND plan_name = NVL('&&cs_plan_name.', plan_name)
             ORDER BY signature, plan_name)
  LOOP
    l_plans := DBMS_SPM.alter_sql_plan_baseline(sql_handle => i.sql_handle, plan_name => i.plan_name, attribute_name => 'FIXED', attribute_value => 'NO');
    l_plans := DBMS_SPM.alter_sql_plan_baseline(sql_handle => i.sql_handle, plan_name => i.plan_name, attribute_name => 'DESCRIPTION', attribute_value => TRIM(i.description||' &&cs_script_name..sql &&cs_reference_sanitized. &&who_am_i. UNFIXED='||TO_CHAR(SYSDATE, '&&cs_datetime_full_format.')));    
  END LOOP;
END;
/
--
@@hf_internal/hf_spbl_internal_list.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_plan_name."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--


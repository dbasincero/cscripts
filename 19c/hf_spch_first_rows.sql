--==========================================================================
-- Script    : hf_spch_first_rows.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Cria um SQL Patch com FIRST_ROWS para um dado SQL_ID, e
--             remove SQL Profile e SQL Plan Baselines
-- Variaveis  : posicionais &1; &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spch_first_rows.sql
--
-- Purpose:     Create a SQL Patch with FIRST_ROWS for given SQL_ID, and drops SQL Profile and SQL Plan Baselines
--
-- Author:      Carlos Sierra
--
-- Version:     2023/04/27
--
-- Usage:       Connecting into PDB.
--
--              Enter SQL_ID and PLAN_HASH_VALUE when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spch_first_rows.sql
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
DEF cs_script_name = 'cs_spch_first_rows';
--
DEF cs_sql_id_col = 'NOPRI';
DEF cs_uncommon_col = 'NOPRI';
DEF cs_delta_col = 'NOPRI';
-- DEF cs_sqlstat_days = '0.25';
-- @@hf_internal/hf_sample_time_boundaries.sql
-- @@hf_internal/hf_snap_id_from_and_to.sql
--
PRO 1. SQL_ID: 
DEF cs_sql_id = "&1.";
UNDEF 1;
DEF cs_filter_1 = 'sql_id = ''&&cs_sql_id.''';
DEF cs2_sql_text_piece = '';
--
@@hf_internal/hf_last_snap.sql
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_signature.sql
--
COL hints_text NEW_V hints_text NOPRI;
SELECT q'[&&hints_text.]'||CASE WHEN '&&cs_kiev_table_name.' IS NOT NULL THEN ' LEADING(@SEL$1 &&cs_kiev_table_name.)' END||q'[ OPT_PARAM('_b_tree_bitmap_plans' 'FALSE') OPT_PARAM('_no_or_expansion' 'TRUE')]' AS hints_text FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id."
@@hf_internal/hf_spool_id.sql
@@hf_internal/hf_spool_id_list_sql_id.sql
--
PRO CBO HINTS    : "&&hints_text."
--
@@hf_internal/hf_print_sql_text.sql
-- drop existing patch if any
@@hf_internal/hf_spch_internal_drop.sql
--
PRO
PRO Create name: "spch_&&cs_sql_id."
@@hf_internal/hf_spch_internal_create.sql
--
@@hf_internal/hf_spch_internal_list.sql
--
-- drop existing profile if any
@@hf_internal/hf_sprf_internal_stgtab.sql
@@hf_internal/hf_sprf_internal_pack.sql
@@hf_internal/hf_sprf_internal_drop.sql
--
-- drop existing baseline if any
DEF cs_plan_name = '';
@@hf_internal/hf_spbl_internal_stgtab.sql
@@hf_internal/hf_spbl_internal_pack.sql
DECLARE
  l_plans INTEGER := 0;
BEGIN
  IF '&&cs_sql_handle.' IS NOT NULL THEN
    l_plans := DBMS_SPM.drop_sql_plan_baseline(sql_handle => '&&cs_sql_handle.');
  END IF;
END;
/
--
DEF cs_scope_1 = '';
@@hf_internal/hf_gv_sql_global.sql 
@@hf_internal/hf_gv_sql_stability.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

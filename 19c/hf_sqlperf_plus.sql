--==========================================================================
-- Script    : hf_sqlperf_plus.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Métricas básicas de desempenho de SQL para um dado SQL_ID +
--             Top Keys
-- Atalhos    : pp.sql
-- Variaveis  : posicionais &1; &&cs_con_name, &&cs_sql_id
-- Seguranca  : gera arquivo via SPOOL
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   pp.sql | hf_sqlperf_plus.sql
--
-- Purpose:     Basic SQL performance metrics for a given SQL_ID + Top Keys
--
-- Author:      Carlos Sierra
--
-- Version:     2023/05/29
--
-- Usage:       Execute connected to PDB.
--
--              Enter SQL_ID when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_sqlperf_plus.sql
--
-- Notes:       *** Requires Oracle Diagnostics Pack License ***
--
--              Developed and tested on 12.1.0.2.
--
--              To further dive into SQL performance diagnostics use SQLd360.
--             
---------------------------------------------------------------------------------------
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn2.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_sqlperf_plus';
DEF cs_script_acronym = 'pp.sql | ';
--
DEF cs_sql_id_col = 'NOPRI';
DEF cs_uncommon_col = 'NOPRI';
DEF cs_delta_col = 'NOPRI';
--
DEF cs_binds_days = '1';
DEF cs_sqlstat_days = '14';
DEF cs_scope_1 = 'last &&cs_sqlstat_days. day(s)';
@@hf_internal/hf_sample_time_boundaries.sql
@@hf_internal/hf_snap_id_from_and_to.sql
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
DEF cs_filter_1 = 'sql_id = ''&&cs_sql_id.''';
DEF cs_filter_2 = '1 = 1';
DEF cs2_sql_text_piece = '';
--
@@hf_internal/hf_last_snap.sql
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_signature.sql
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id."
@@hf_internal/hf_spool_id.sql
@@hf_internal/hf_spool_id_list_sql_id.sql
@@hf_internal/hf_print_sql_text.sql
@@hf_internal/hf_plans_performance.sql 
DEF cs_scope_1 = 'last &&cs_sqlstat_days. day(s)';
@@hf_internal/hf_dba_hist_sqlstat_global.sql
DEF cs_scope_1 = '';
@@hf_internal/hf_gv_sqlstat_global.sql
--
-- @@hf_internal/&&cs_set_container_to_cdb_root.
-- DEF cs_scope_1 = '- SCOPE CDB$ROOT';
-- DEF cs_filter_1 = 'get_sql_hv(sql_text) = ''&&cs_sql_hv.'' AND sql_text LIKE SUBSTR(:cs_sql_text_1000, 1, 40)||''%''';
-- DEF cs_sql_id_col = 'PRI';
-- @@hf_internal/hf_gv_sql_global.sql 
-- DEF cs_sql_id_col = 'NOPRI';
-- DEF cs_filter_1 = 'sql_id = ''&&cs_sql_id.''';
-- @@hf_internal/&&cs_set_container_to_curr_pdb.
--
-- DEF cs_scope_1 = '- SCOPE &&cs_con_name.';
DEF cs_scope_1 = '';
@@hf_internal/hf_gv_sql_global.sql 
@@hf_internal/hf_gv_sql_stability.sql
-- @@hf_internal/hf_cursors_not_shared.sql
--
DEF cs_scope_1 = '- last &&cs_sqlstat_days. day(s)';
@@hf_internal/hf_dba_hist_sqlstat_daily.sql
--
SPO OFF;
DEF cs_sqlstat_days = '1';
DEF cs_scope_1 = '- last &&cs_sqlstat_days. day(s)';
@@hf_internal/hf_sample_time_boundaries.sql
@@hf_internal/hf_snap_id_from_and_to.sql
SPO &&cs_file_name..txt APP;
@@hf_internal/hf_dba_hist_sqlstat_hourly.sql
--
SPO OFF;
DEF cs_sqlstat_days = '0.5';
DEF cs_scope_1 = '- last &&cs_sqlstat_days. day(s)';
@@hf_internal/hf_sample_time_boundaries.sql
@@hf_internal/hf_snap_id_from_and_to.sql
SPO &&cs_file_name..txt APP;
@@hf_internal/hf_dba_hist_sqlstat_detailed.sql
--
-- PRO
-- PRO ********************************************************************************************************************************************************************************************************
-- PRO
-- @@hf_internal/hf_sqlmon_hist_internal.sql
-- @@hf_internal/hf_sqlmon_mem_internal.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
-- @@hf_internal/hf_binds_xml.sql
-- @@hf_internal/hf_bind_capture_hist.sql
@@hf_internal/hf_bind_capture_mem.sql
-- @@hf_internal/hf_acs_internal.sql
-- PRO
-- PRO ********************************************************************************************************************************************************************************************************
-- PRO
@@hf_internal/hf_plans_mem_0.sql
-- @@hf_internal/hf_plans_mem_1.sql
-- @@hf_internal/hf_plans_mem_2.sql
-- @@hf_internal/hf_plans_awr_1.sql
-- @@hf_internal/hf_plans_awr_2.sql
-- @@hf_internal/hf_spbl_internal_plan.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@hf_internal/hf_recent_sessions.sql
@@hf_internal/hf_active_sessions.sql
-- @@hf_internal/hf_load_per_machine.sql
-- @@hf_internal/hf_sql_ash.sql
-- PRO
-- PRO ********************************************************************************************************************************************************************************************************
-- PRO
-- @@hf_internal/hf_spch_internal_list.sql
-- @@hf_internal/hf_sprf_internal_list.sql
-- @@hf_internal/hf_spbl_internal_list.sql
-- PRO
-- PRO ********************************************************************************************************************************************************************************************************
-- PRO
-- @@hf_internal/&&zapper_19_actions_script.
-- PRO
-- PRO ********************************************************************************************************************************************************************************************************
-- PRO
-- @@hf_internal/&&oem_me_sqlperf_script.
-- PRO
-- PRO ********************************************************************************************************************************************************************************************************
-- PRO
-- @@hf_internal/hf_dependency_segments.sql
-- @@hf_internal/hf_dependency_tables.sql
-- @@hf_internal/hf_dependency_indexes.sql
-- @@hf_internal/hf_dependency_part_keys.sql
-- @@hf_internal/hf_dependency_index_columns.sql
-- @@hf_internal/hf_dependency_table_columns.sql
-- @@hf_internal/hf_dependency_lobs.sql
-- PRO
-- PRO ********************************************************************************************************************************************************************************************************
-- PRO
-- @@hf_internal/hf_dependency_metadata.sql
-- @@hf_internal/hf_dependency_kievlive.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
DEF cs_num_rows_limit_display = '100M';
DEF cs_num_rows_limit_number = '1e8';
@@hf_internal/hf_top_primary_keys_table.sql
-- @@hf_internal/hf_top_keys_sql.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
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
@@hf_internal/hf_cdb_warn2.sql
--
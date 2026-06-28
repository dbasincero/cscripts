--==========================================================================
-- Script    : hf_planx.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Planos de Execução e métricas de desempenho de SQL para um
--             dado SQL_ID
-- Atalhos    : x.sql
-- Variaveis  : posicionais &1; &&cs_sql_id
-- Seguranca  : gera arquivo via SPOOL
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   x.sql | hf_planx.sql
--
-- Purpose:     Execution Plans and SQL performance metrics for a given SQL_ID
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
--              SQL> @hf_planx.sql
--
-- Notes:       *** Requires Oracle Diagnostics Pack License ***
--
--              Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_primary.sql
@@cs_internal/hf_cdb_warn2.sql
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
@@cs_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_planx';
DEF cs_script_acronym = 'x.sql | ';
--
DEF cs_sql_id_col = 'NOPRI';
DEF cs_uncommon_col = 'NOPRI';
DEF cs_delta_col = 'NOPRI';
--
DEF cs_binds_days = '1';
DEF cs_sqlstat_days = '61';
DEF cs_scope_1 = 'last &&cs_sqlstat_days. day(s)';
@@cs_internal/hf_sample_time_boundaries.sql
@@cs_internal/hf_snap_id_from_and_to.sql
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
DEF cs_filter_1 = 'sql_id = ''&&cs_sql_id.''';
DEF cs_filter_2 = '1 = 1';
DEF cs2_sql_text_piece = '';
--
@@cs_internal/hf_last_snap.sql
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_signature.sql
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id."
@@cs_internal/hf_spool_id.sql
@@cs_internal/hf_spool_id_list_sql_id.sql
@@cs_internal/hf_print_sql_text.sql
@@cs_internal/hf_plans_performance.sql 
DEF cs_scope_1 = 'last &&cs_sqlstat_days. day(s)';
@@cs_internal/hf_dba_hist_sqlstat_global.sql
DEF cs_scope_1 = '';
@@cs_internal/hf_gv_sqlstat_global.sql
--
@@cs_internal/&&cs_set_container_to_cdb_root.
DEF cs_scope_1 = '- SCOPE CDB$ROOT';
DEF cs_filter_1 = 'get_sql_hv(sql_text) = ''&&cs_sql_hv.'' AND sql_text LIKE SUBSTR(:cs_sql_text_1000, 1, 40)||''%''';
DEF cs_sql_id_col = 'PRI';
@@cs_internal/hf_gv_sql_global.sql 
PRO
PRO 1. Include SQL matching SQL Hash Value (HV) on any PDB within CDB, even if SQL_ID (and Text) were different (e.g.: different KIEV bucket_id)
PRO
DEF cs_sql_id_col = 'NOPRI';
DEF cs_filter_1 = 'sql_id = ''&&cs_sql_id.''';
@@cs_internal/&&cs_set_container_to_curr_pdb.
--
DEF cs_scope_1 = '';
@@cs_internal/hf_gv_sql_global.sql 
@@cs_internal/hf_gv_sql_stability.sql
@@cs_internal/hf_cursors_not_shared.sql
--
DEF cs_scope_1 = '- last &&cs_sqlstat_days. day(s)';
@@cs_internal/hf_dba_hist_sqlstat_daily.sql
--
SPO OFF;
DEF cs_sqlstat_days = '14';
DEF cs_scope_1 = '- last &&cs_sqlstat_days. day(s)';
@@cs_internal/hf_sample_time_boundaries.sql
@@cs_internal/hf_snap_id_from_and_to.sql
SPO &&cs_file_name..txt APP;
@@cs_internal/hf_dba_hist_sqlstat_hourly.sql
--
SPO OFF;
DEF cs_sqlstat_days = '7';
DEF cs_scope_1 = '- last &&cs_sqlstat_days. day(s)';
@@cs_internal/hf_sample_time_boundaries.sql
@@cs_internal/hf_snap_id_from_and_to.sql
SPO &&cs_file_name..txt APP;
@@cs_internal/hf_dba_hist_sqlstat_detailed.sql
--
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/hf_sqlmon_hist_internal.sql
@@cs_internal/hf_sqlmon_mem_internal.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/hf_binds_xml.sql
@@cs_internal/hf_bind_capture_hist.sql
@@cs_internal/hf_bind_capture_mem.sql
@@cs_internal/hf_acs_internal.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/hf_plans_mem_0.sql
@@cs_internal/hf_plans_mem_1.sql
@@cs_internal/hf_plans_mem_2.sql
@@cs_internal/hf_plans_awr_1.sql
@@cs_internal/hf_plans_awr_2.sql
@@cs_internal/hf_spbl_internal_plan.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/hf_recent_sessions.sql
@@cs_internal/hf_active_sessions.sql
@@cs_internal/hf_load_per_machine.sql
@@cs_internal/hf_sql_ash.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/hf_spch_internal_list.sql
@@cs_internal/hf_sprf_internal_list.sql
@@cs_internal/hf_spbl_internal_list.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/&&zapper_19_actions_script.
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/&&oem_me_sqlperf_script.
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/hf_dependency_segments.sql
@@cs_internal/hf_dependency_tables.sql
@@cs_internal/hf_dependency_indexes.sql
@@cs_internal/hf_dependency_part_keys.sql
@@cs_internal/hf_dependency_index_columns.sql
@@cs_internal/hf_dependency_table_columns.sql
@@cs_internal/hf_dependency_lobs.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
@@cs_internal/hf_dependency_metadata.sql
@@cs_internal/hf_dependency_kievlive.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
DEF cs_num_rows_limit_display = '10B';
DEF cs_num_rows_limit_number = '1e10';
@@cs_internal/hf_top_primary_keys_table.sql
@@cs_internal/hf_top_keys_sql.sql
PRO
PRO ********************************************************************************************************************************************************************************************************
PRO
DEF cs_scope_1 = '';
@@cs_internal/hf_gv_sql_global.sql 
@@cs_internal/hf_gv_sql_stability.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id."
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
@@cs_internal/hf_cdb_warn2.sql
--
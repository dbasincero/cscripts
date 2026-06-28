--==========================================================================
-- Script    : hf_spch_category.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Altera a categoria de um SQL Patch para um dado SQL_ID
-- Variaveis  : posicionais &1, &2, &3; &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spch_category.sql
--
-- Purpose:     Changes category for a SQL Patch for given SQL_ID
--
-- Author:      Carlos Sierra
--
-- Version:     2023/04/27
--
-- Usage:       Connecting into PDB.
--
--              Enter SQL_ID and name when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spch_category.sql
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
DEF cs_script_name = 'cs_spch_category';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_signature.sql
@@hf_internal/hf_plans_performance.sql 
@@hf_internal/hf_spch_internal_list.sql
--
PRO
PRO 2. NAME (req):
DEF cs_name = '&2.';
UNDEF 2;
PRO
--
PRO 3. Enter CATEGORY (opt) [{DEFAULT}|DISABLED|<string>]:
DEF category_passed = "&3.";
UNDEF 3;
--
COL cs_category NEW_V cs_category;
SELECT CASE WHEN UPPER(NVL('&&category_passed.','DEFAULT')) IN ('DEF', 'DEFAULT') THEN 'DEFAULT' ELSE UPPER('&&category_passed.') END cs_category FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_name." "&&cs_category."
@@hf_internal/hf_spool_id.sql
@@hf_internal/hf_spool_id_list_sql_id.sql
--
PRO NAME         : &&cs_name.
PRO CATEGORY     : &&cs_category.
--
@@hf_internal/hf_print_sql_text.sql
@@hf_internal/hf_plans_performance.sql 
@@hf_internal/hf_spch_internal_list.sql
--
PRO
PRO Changes category on "&&cs_name." to "&&cs_category."
@@hf_internal/hf_spch_internal_category.sql
--
@@hf_internal/hf_spch_internal_list.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_name." "&&cs_category."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

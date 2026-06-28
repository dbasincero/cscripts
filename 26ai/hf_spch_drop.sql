--==========================================================================
-- Script    : hf_spch_drop.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Remove todos os SQL Patches para um dado SQL_ID
-- Variaveis  : posicionais &1; &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spch_drop.sql
--
-- Purpose:     Drop all SQL Patches for given SQL_ID
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
--              SQL> @hf_spch_drop.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_primary.sql
@@cs_internal/hf_cdb_warn.sql
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
@@cs_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_spch_drop';
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
@@cs_internal/hf_spch_internal_list.sql
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." 
@@cs_internal/hf_spool_id.sql
@@cs_internal/hf_spool_id_list_sql_id.sql
@@cs_internal/hf_print_sql_text.sql
@@cs_internal/hf_plans_performance.sql 
@@cs_internal/hf_spch_internal_list.sql
--
@@cs_internal/hf_spch_internal_stgtab.sql
@@cs_internal/hf_spch_internal_pack.sql
--
PRO
PRO Drop SQL Patch(es) for: "&&cs_sql_id."
@@cs_internal/hf_spch_internal_drop.sql
--
@@cs_internal/hf_spch_internal_list.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." 
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

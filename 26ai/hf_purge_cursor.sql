--==========================================================================
-- Script    : hf_purge_cursor.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Faz purge de Cursor(es) para SQL_ID usando
--             DBMS_SHARED_POOL.PURGE e SQL Patch
-- Variaveis  : posicionais &1; &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_purge_cursor.sql
--
-- Purpose:     Purge Cursor(s) for SQL_ID using DBMS_SHARED_POOL.PURGE and SQL Patch
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
--              SQL> @hf_purge_cursor.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_purge_cursor';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
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
--
SET SERVEROUT ON;
@@hf_internal/cs_internal_purge_cursor "&&cs_sql_id."
SET SERVEROUT OFF;
--
@@hf_internal/hf_plans_performance.sql 
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." 
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

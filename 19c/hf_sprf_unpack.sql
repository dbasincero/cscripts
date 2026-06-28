--==========================================================================
-- Script    : hf_sprf_unpack.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Desempacota da tabela de staging um ou todos os SQL Profiles
--             para um dado SQL_ID
-- Variaveis  : posicionais &1, &2; &&cs_signature, &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_sprf_unpack.sql
--
-- Purpose:     Unpack from staging table one or all SQL Profiles for given SQL_ID
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
--              SQL> @hf_sprf_unpack.sql
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
DEF cs_script_name = 'cs_sprf_unpack';
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
@@hf_internal/hf_sprf_internal_list.sql
--
PRO
PRO 2. Enter NAME (opt)
DEF cs_name = '&2.';
UNDEF 2;
PRO
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_name."
@@hf_internal/hf_spool_id.sql
--
PRO SQL_ID       : &&cs_sql_id.
PRO SIGNATURE    : &&cs_signature.
PRO SQL_HANDLE   : &&cs_sql_handle.
PRO NAME         : &&cs_name.
--
@@hf_internal/hf_print_sql_text.sql
@@hf_internal/hf_sprf_internal_list.sql
@@hf_internal/hf_plans_performance.sql
--
PRO
PRO Unpack name: "&&cs_name."
BEGIN
  FOR i IN (SELECT obj_name name 
              FROM &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_sqlprof 
             WHERE signature = :cs_signature
               AND obj_name = NVL('&&cs_name.', obj_name)
             ORDER BY obj_name)
  LOOP
    DBMS_SQLTUNE.unpack_stgtab_sqlprof(profile_name => i.name, replace => TRUE, staging_table_name => '&&cs_stgtab_prefix._stgtab_sqlprof', staging_schema_owner => '&&cs_stgtab_owner.');
  END LOOP;
END;
/
--
@@hf_internal/hf_sprf_internal_list.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_name."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
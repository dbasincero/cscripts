--==========================================================================
-- Script    : hf_sprf_enable.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Habilita um ou todos os SQL Profiles para um dado SQL_ID
-- Variaveis  : posicionais &1, &2; &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_sprf_enable.sql
--
-- Purpose:     Enable one or all SQL Profiles for given SQL_ID
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
--              SQL> @hf_sprf_enable.sql
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
DEF cs_script_name = 'cs_sprf_enable';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_signature.sql
@@cs_internal/hf_plans_performance.sql 
@@cs_internal/hf_sprf_internal_list.sql
--
PRO
PRO 2. NAME (opt):
DEF cs_name = '&2.';
UNDEF 2;
PRO
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_name."
@@cs_internal/hf_spool_id.sql
@@cs_internal/hf_spool_id_list_sql_id.sql
--
PRO NAME         : &&cs_name.
--
@@cs_internal/hf_print_sql_text.sql
@@cs_internal/hf_plans_performance.sql 
@@cs_internal/hf_sprf_internal_list.sql
--
PRO
PRO Disable name: "&&cs_name."
BEGIN
  FOR i IN (SELECT name 
              FROM dba_sql_profiles 
             WHERE signature = :cs_signature
               AND status = 'DISABLED'
               AND name = NVL('&&cs_name.', name)
             ORDER BY name)
  LOOP
    DBMS_SQLTUNE.alter_sql_profile(name => i.name, attribute_name => 'STATUS', value => 'ENABLED');
  END LOOP;
END;
/
--
@@cs_internal/hf_sprf_internal_list.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_name."
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

--==========================================================================
-- Script    : hf_spch_enable.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Habilita um ou todos os SQL Patches para um dado SQL_ID
-- Variaveis  : posicionais &1, &2; &&cs_signature, &&cs_sql_handle, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spch_enable.sql
--
-- Purpose:     Enable one or all SQL Patches for given SQL_ID
--
-- Author:      Carlos Sierra
--
-- Version:     2023/02/28
--
-- Usage:       Connecting into PDB.
--
--              Enter SQL_ID and name when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spch_enable.sql
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
DEF cs_script_name = 'cs_spch_enable';
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
@@hf_internal/hf_spch_internal_list.sql
--
PRO
PRO 2. NAME (opt):
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
@@hf_internal/hf_spch_internal_list.sql
@@hf_internal/hf_plans_performance.sql
--
PRO
PRO Disable name: "&&cs_name."
BEGIN
  FOR i IN (SELECT name 
              FROM dba_sql_patches
             WHERE signature = :cs_signature
               AND status = 'DISABLED'
               AND name = NVL('&&cs_name.', name)
             ORDER BY name)
  LOOP
    $IF DBMS_DB_VERSION.ver_le_12_1
    $THEN
      DBMS_SQLDIAG.alter_sql_patch(name => i.name, attribute_name => 'STATUS', value => 'ENABLED'); -- 12c
    $ELSE
      DBMS_SQLDIAG.alter_sql_patch(name => i.name, attribute_name => 'STATUS', attribute_value => 'ENABLED'); -- 19c
    $END
  END LOOP;
END;
/
--
@@hf_internal/hf_spch_internal_list.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_name."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

--==========================================================================
-- Script    : hf_tcb.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : posicionais &1, &2; &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_tcb.sql
--
-- Purpose:     Executes Test Case Builder (TCB) for given SQL_ID
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
--              SQL> @hf_tcb.sql
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
DEF cs_script_name = 'cs_tcb';
--
PRO 1. SQL_ID: 
DEF cs_sql_id = '&1.';
UNDEF 1;
--
PRO
PRO 2. Sampling Percent: [{100}|1-100]
DEF cs_samplingPercent = '&2.';
UNDEF 2;
COL cs_samplingPercent NEW_V cs_samplingPercent NOPRI;
SELECT CASE WHEN TO_NUMBER('&&cs_samplingPercent.') BETWEEN 1 AND 100 THEN '&&cs_samplingPercent.' ELSE '100' END AS cs_samplingPercent FROM DUAL
/
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_sql_id._TCB' cs_file_name FROM DUAL;
--
@@hf_internal/hf_signature.sql
--
PRO
ACCEPT sys_password CHAR PROMPT 'Enter SYS Password (hidden): ' HIDE
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_samplingPercent."
@@hf_internal/hf_spool_id.sql
@@hf_internal/hf_spool_id_list_sql_id.sql
--
PRO SAMPLING_PERC: "&&cs_samplingPercent." [{100}|1-100]
PRO PARSE_SCHEMA : &&cs_parsing_schema_name.
PRO TEMP_DIR     : "&&cs_temp_dir." 
--
@@hf_internal/hf_print_sql_text.sql
@@hf_internal/hf_temp_dir_create.sql
--
ALTER SESSION SET current_schema = &&cs_parsing_schema_name.;
--
PRO DBMS_SQLDIAG.export_sql_testcase
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
VAR testcase CLOB;
EXEC DBMS_SQLDIAG.export_sql_testcase(directory => 'CS_TEMP_DIR', sql_id => '&&cs_sql_id.', exportData => TRUE, samplingPercent => TO_NUMBER('&&cs_samplingPercent.'), testcase_name => 'TCB_&&cs_sql_id._&&cs_file_timestamp._', testcase => :testcase);
--
ALTER SESSION SET current_schema = &&cs_current_schema.;
--
HOS cp &&cs_temp_dir./TCB_&&cs_sql_id.* /tmp/
HOS chmod 644 /tmp/TCB_&&cs_sql_id.*
--
@@hf_internal/hf_temp_dir_drop.sql
--
PRO SQL> @&&cs_script_name..sql "&&cs_sql_id." "&&cs_samplingPercent."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
PRO
PRO TCB files
PRO ~~~~~~~~~
HOS ls -lt /tmp/TCB_&&cs_sql_id.*
PRO 
HOS zip -mj /tmp/TCB_&&cs_sql_id._&&cs_file_timestamp..zip /tmp/TCB_&&cs_sql_id._&&cs_file_timestamp._*
PRO
PRO To get TCB:
PRO ~~~~~~~~~~~
PRO scp &&cs_host_name.:/tmp/TCB_&&cs_sql_id._&&cs_file_timestamp..zip .
PRO
--
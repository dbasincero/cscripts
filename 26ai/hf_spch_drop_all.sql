--==========================================================================
-- Script    : hf_spch_drop_all.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Remove todos os SQL Patches para alguma string de SQL Text no
--             PDB
-- Variaveis  : posicionais &1, &2; &&cs_con_name
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spch_drop_all.sql
--
-- Purpose:     Drop all SQL Patches for some SQL Text string on PDB
--
-- Author:      Carlos Sierra
--
-- Version:     2022/10/05
--
-- Usage:       Connecting into PDB.
--
--              Confirm when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spch_drop_all.sql
--
-- Notes:       Developed and tested on 19c.
--
---------------------------------------------------------------------------------------
--
DEF sleep_seconds = '1';
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_spch_drop_all';
--
PRO 1. SQL Text piece (e.g.: ScanQuery, getValues, TableName, IndexName):
DEF cs2_sql_text_piece = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
COL count_distinct_ch NEW_V count_distinct_ch NOPRI;
COL estimated_seconds_ch NEW_V estimated_seconds_ch NOPRI;
SELECT TO_CHAR(COUNT(DISTINCT name) * TO_NUMBER('&&sleep_seconds.')) AS estimated_seconds_ch, TO_CHAR(COUNT(DISTINCT name)) AS count_distinct_ch FROM dba_sql_patches WHERE ('&&cs2_sql_text_piece.' IS NULL OR UPPER(sql_text) LIKE '%'||UPPER(TRIM('&&cs2_sql_text_piece.'))||'%')
/
--
PRO
PRO ***
PRO *** You are about to drop &&count_distinct_ch. SQL Patches on this &&cs_con_name. PDB on SQL text "&&cs2_sql_text_piece."
PRO ***
PRO
PRO 2. Enter "Yes" (case sensitive) to continue, else <ctrl>-C
DEF cs_confirm = '&2.';
UNDEF 2;
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs2_sql_text_piece." "&&cs_confirm." 
@@hf_internal/hf_spool_id.sql
--
PRO SQL_TEXT     : &&cs2_sql_text_piece.
--
PRO
PRO Drop all &&count_distinct_ch. SQL Patches which include SQL text "&&cs2_sql_text_piece."
PRO
PRO Estimated Seconds: &&estimated_seconds_ch.
PRO
SET SERVEROUT ON;
DECLARE
  l_total INTEGER := 0;
BEGIN
  IF '&&cs_confirm.' = 'Yes' THEN
    FOR i IN (SELECT DISTINCT name FROM dba_sql_patches WHERE ('&&cs2_sql_text_piece.' IS NULL OR UPPER(sql_text) LIKE '%'||UPPER(TRIM('&&cs2_sql_text_piece.'))||'%') ORDER BY name)
    LOOP
      DBMS_SQLDIAG.drop_sql_patch(name => i.name); 
      l_total := l_total + 1;
      DBMS_LOCK.sleep(TO_NUMBER('&&sleep_seconds.'));
    END LOOP;
  END IF;
  DBMS_OUTPUT.put_line(' *** SQL Patches Dropped:'||l_total);
END;
/
SET SERVEROUT OFF;
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs2_sql_text_piece." "&&cs_confirm."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

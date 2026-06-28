--==========================================================================
-- Script    : hf_acs_enable.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Habilita Adaptive Cursor Sharing (ACS)
-- Variaveis  : posicionais &1; &&cs_con_name
-- Seguranca  : usa EXECUTE IMMEDIATE (SQL dinâmico)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_acs_enable.sql
--
-- Purpose:     Enable Adaptive Cursor Sharing (ACS)
--
-- Author:      Carlos Sierra
--
-- Version:     2022/02/07
--
-- Usage:       Connecting into PDB or CDB.
--
--              Confirm when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_acs_enable.sql
--
-- Notes:       Developed and tested on 19c.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_primary.sql
@@cs_internal/hf_cdb_warn.sql
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
--
PRO
PRO ***
PRO *** You are about to ENABLE Adaptive Cursor Sharing (ACS) for &&cs_con_name.
PRO ***
PRO
PRO 1. Enter "Yes" (case sensitive) to continue, else <ctrl>-C
DEF cs_confirm = '&1.';
UNDEF 1;
--
SET SERVEROUT ON;
BEGIN
  IF '&&cs_confirm.' = 'Yes' THEN
    EXECUTE IMMEDIATE 'ALTER SYSTEM SET "_optimizer_adaptive_cursor_sharing" = TRUE';
    EXECUTE IMMEDIATE 'ALTER SYSTEM SET "_optimizer_extended_cursor_sharing_rel" = "SIMPLE"';
    EXECUTE IMMEDIATE 'ALTER SYSTEM SET "_optimizer_extended_cursor_sharing" = "UDO"';
    DBMS_OUTPUT.put_line('Done');
  ELSE
    DBMS_OUTPUT.put_line('Null');
  END IF;
END;
/
--
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

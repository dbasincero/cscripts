--==========================================================================
-- Script    : hf_top.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Top SQL ativo conforme Active Sessions History ASH - último
--             1m
-- Atalhos    : t.sql
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   ta.sql | t.sql | hf_top.sql
--
-- Purpose:     Top Active SQL as per Active Sessions History ASH - last 1m
--
-- Author:      Carlos Sierra
--
-- Version:     2021/08/17
--
-- Usage:       Execute connected to PDB or CDB
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_top.sql
--
-- Notes:       *** Requires Oracle Diagnostics Pack License ***
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
DEF cs_script_name = 'cs_top';
DEF cs_script_acronym = 'ta.sql | t.sql | ';
--
DEF cs_minutes = '1';
DEF cs_top = '30';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@hf_internal/hf_spool_id.sql
--
@@hf_internal/hf_top_activity_internal.sql
@@hf_internal/hf_top_internal_foot.sql
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
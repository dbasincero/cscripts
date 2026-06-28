--==========================================================================
-- Script    : hf_spch_stgtab.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Cria Tabela de Staging para SQL Patches
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spch_stgtab.sql
--
-- Purpose:     Creates Staging Table for SQL Patches
--
-- Author:      Carlos Sierra
--
-- Version:     2018/08/06
--
-- Usage:       Connecting into PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spch_stgtab.sql
--
-- Notes:       *** Requires Oracle Diagnostics Pack License ***
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
DEF cs_script_name = 'cs_spch_stgtab';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@cs_internal/hf_spool_id.sql
--
@@cs_internal/hf_spch_internal_stgtab.sql
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

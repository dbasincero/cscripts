--==========================================================================
-- Script    : hf_spbl_stgtab.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Cria Tabela de Staging para SQL Plan Baselines
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spbl_stgtab.sql
--
-- Purpose:     Creates Staging Table for SQL Plan Baselines
--
-- Author:      Carlos Sierra
--
-- Version:     2018/07/25
--
-- Usage:       Connecting into PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spbl_stgtab.sql
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
DEF cs_script_name = 'cs_spbl_stgtab';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql
@@hf_internal/hf_spool_id.sql
--
@@hf_internal/hf_spbl_internal_stgtab.sql
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

--==========================================================================
-- Script    : hf_active_sessions.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Sessões Ativas incluindo Texto do SQL e Plano de Execução
-- Atalhos    : a.sql
-- Variaveis  : &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   a.sql | as.sql | hf_active_sessions.sql
--
-- Purpose:     Active Sessions including SQL Text and Exection Plan
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/16
--
-- Usage:       Execute connected to PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_active_sessions.sql
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
DEF cs_script_name = 'cs_active_sessions';
DEF cs_script_acronym = 'a.sql | as.sql | ';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@hf_internal/hf_spool_id.sql
--
@@hf_internal/hf_active_sessions_internal.sql
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
--==========================================================================
-- Script    : hf_locks.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Resumo e Detalhes de Locks
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   locks.sql | hf_locks.sql
--
-- Purpose:     Locks Summary and Details
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/16
--
-- Usage:       Execute connected to PDB or CDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_locks.sql
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
DEF cs_script_name = 'cs_locks';
DEF cs_script_acronym = 'locks.sql | ';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@hf_internal/hf_spool_id.sql
--
@@hf_internal/hf_locks_internal.sql
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
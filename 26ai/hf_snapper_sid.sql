--==========================================================================
-- Script    : hf_snapper_sid.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : posicionais &1
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   snapper_sid.sql | hf_snapper_sid.sql
--
-- Purpose:     Sessions Snapper for one SID using Tanel Poder Snapper
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/16
--
-- Usage:       Execute connected to PDB or CDB. Pass SID when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_snapper_sid.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@hf_internal/hf_primary.sql
--@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_snapper_sid';
DEF cs_script_acronym = 'snapper_sid.sql | ';
--
PRO
PRO Executing: SQL> @@snapper.sql ash=sid+service_name+module+machine 5 1 all
@@snapper.sql ash=sid+service_name+module+machine 5 1 all
UNDEF 1 2 3 4;
--
PRO 1. SID: 
DEF cs_sid = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sid."
@@hf_internal/hf_spool_id.sql
--
PRO SID          : "&&cs_sid."
PRO
--
DEF sid = '&&cs_sid.';
PRO Snapper #1 out of 6
@@snapper_sid.sql
--
DEF sid = '&&cs_sid.';
PRO Snapper #2 out of 6
@@snapper_sid.sql
--
DEF sid = '&&cs_sid.';
PRO Snapper #3 out of 6
@@snapper_sid.sql
--
DEF sid = '&&cs_sid.';
PRO Snapper #4 out of 6
@@snapper_sid.sql
--
DEF sid = '&&cs_sid.';
PRO Snapper #5 out of 6
@@snapper_sid.sql
--
DEF sid = '&&cs_sid.';
PRO Snapper #6 out of 6
@@snapper_sid.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sid."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
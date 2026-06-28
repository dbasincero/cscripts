--==========================================================================
-- Script    : hf_snapper_spid.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : posicionais &1
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   snapper_spid.sql | hf_snapper_spid.sql
--
-- Purpose:     Sessions Snapper for one SPID (OS PID) using Tanel Poder Snapper
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/16
--
-- Usage:       Execute connected to PDB or CDB. Pass SPID when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_snapper_spid.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_primary.sql
--@@cs_internal/hf_cdb_warn.sql
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
@@cs_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_snapper_spid';
DEF cs_script_acronym = 'snapper_spid.sql | ';
--
--PRO
--PRO Executing: SQL> @@snapper.sql ash=sid+service_name+module+machine 5 1 all
--@@snapper.sql ash=sid+service_name+module+machine 5 1 all
--UNDEF 1 2 3 4;
--
PRO 1. SPID (OS PID): 
DEF cs_spid = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_spid."
@@cs_internal/hf_spool_id.sql
--
PRO SPID (OS PID): "&&cs_spid."
PRO
--
DEF spid = '&&cs_spid.';
PRO Snapper #1 out of 6
@@snapper_spid.sql
--
DEF spid = '&&cs_spid.';
PRO Snapper #2 out of 6
@@snapper_spid.sql
--
DEF spid = '&&cs_spid.';
PRO Snapper #3 out of 6
@@snapper_spid.sql
--
DEF spid = '&&cs_spid.';
PRO Snapper #4 out of 6
@@snapper_spid.sql
--
DEF spid = '&&cs_spid.';
PRO Snapper #5 out of 6
@@snapper_spid.sql
--
DEF spid = '&&cs_spid.';
PRO Snapper #6 out of 6
@@snapper_spid.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_spid."
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--
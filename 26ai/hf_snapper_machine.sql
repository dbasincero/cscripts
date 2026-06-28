--==========================================================================
-- Script    : hf_snapper_machine.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : posicionais &1
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   snapper_machine.sql | hf_snapper_machine.sql
--
-- Purpose:     Sessions Snapper for one Machine using Tanel Poder Snapper
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/08
--
-- Usage:       Execute connected to PDB or CDB. Pass Machine when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_snapper_machine.sql
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
DEF cs_script_name = 'cs_snapper_machine';
DEF cs_script_acronym = 'snapper_machine.sql | ';
--
SELECT COUNT(*) sessions, 
       SUM(CASE status WHEN 'ACTIVE' THEN 1 ELSE 0 END) active,
       SUM(CASE status WHEN 'INACTIVE' THEN 1 ELSE 0 END) inactive,
       SUM(CASE status WHEN 'KILLED' THEN 1 ELSE 0 END) killed,
       type,
       machine 
  FROM v$session 
 WHERE machine IS NOT NULL 
 GROUP BY type, machine 
 ORDER BY 1 DESC
/
--
PRO
PRO Executing: SQL> @@snapper.sql ash=machine 5 1 all
@@snapper.sql ash=machine 5 1 all
UNDEF 1 2 3 4;
--
PRO 1. Machine: 
DEF cs_machine = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_machine.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_machine."
@@hf_internal/hf_spool_id.sql
--
PRO MACHINE      : "&&cs_machine."
PRO
--
DEF machine = '&&cs_machine.';
PRO Snapper #1 out of 6
@@snapper_machine.sql
--
DEF machine = '&&cs_machine.';
PRO Snapper #2 out of 6
@@snapper_machine.sql
--
DEF machine = '&&cs_machine.';
PRO Snapper #3 out of 6
@@snapper_machine.sql
--
DEF machine = '&&cs_machine.';
PRO Snapper #4 out of 6
@@snapper_machine.sql
--
DEF machine = '&&cs_machine.';
PRO Snapper #5 out of 6
@@snapper_machine.sql
--
DEF machine = '&&cs_machine.';
PRO Snapper #6 out of 6
@@snapper_machine.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_machine."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
--==========================================================================
-- Script    : hf_snapper_service.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : posicionais &1
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   snapper_service.sql | hf_snapper_service.sql
--
-- Purpose:     Sessions Snapper for one Service using Tanel Poder Snapper
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/16
--
-- Usage:       Execute connected to PDB or CDB. Pass Service Name when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_snapper_service.sql
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
DEF cs_script_name = 'cs_snapper_service';
DEF cs_script_acronym = 'snapper_service.sql | ';
--
SELECT COUNT(*) sessions, 
       SUM(CASE status WHEN 'ACTIVE' THEN 1 ELSE 0 END) active,
       SUM(CASE status WHEN 'INACTIVE' THEN 1 ELSE 0 END) inactive,
       SUM(CASE status WHEN 'KILLED' THEN 1 ELSE 0 END) killed,
       type,
       service_name 
  FROM v$session 
 WHERE service_name IS NOT NULL 
 GROUP BY type, service_name 
 ORDER BY 1 DESC
/
--
PRO
PRO Executing: SQL> @@snapper.sql ash=service_name 5 1 all
@@snapper.sql ash=service_name 5 1 all
UNDEF 1 2 3 4;
--
PRO 1. Service Name: 
DEF cs_service_name = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name._&&cs_service_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_service_name."
@@hf_internal/hf_spool_id.sql
--
PRO SERVICE_NAME : "&&cs_service_name."
PRO
--
DEF service_name = '&&cs_service_name.';
PRO Snapper #1 out of 6
@@snapper_service.sql
--
DEF service_name = '&&cs_service_name.';
PRO Snapper #2 out of 6
@@snapper_service.sql
--
DEF service_name = '&&cs_service_name.';
PRO Snapper #3 out of 6
@@snapper_service.sql
--
DEF service_name = '&&cs_service_name.';
PRO Snapper #4 out of 6
@@snapper_service.sql
--
DEF service_name = '&&cs_service_name.';
PRO Snapper #5 out of 6
@@snapper_service.sql
--
DEF service_name = '&&cs_service_name.';
PRO Snapper #6 out of 6
@@snapper_service.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_service_name."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
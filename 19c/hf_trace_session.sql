--==========================================================================
-- Script    : hf_trace_session.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Faz trace de uma sessão dado um SID
-- Variaveis  : posicionais &1, &2
-- Seguranca  : executa comando de SO (host/!) — confira o comando antes de rodar
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_trace_session.sql
--
-- Purpose:     Trace one session given a SID
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/09
--
-- Usage:       Execute connected to CDB or PDB.
--
--              Enter SID and SERIAL# when requested.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_trace_session.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_primary.sql
@@cs_internal/hf_cdb_warn.sql
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
@@cs_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_trace_session';
--
PRO
PRO 1. sid,serial:
DEF sid_serial = '&1';
UNDEF 1;
PRO
PRO 2. seconds:
DEF seconds = '&2';
UNDEF 2;
PRO
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@cs_internal/hf_spool_id.sql
--
PRO SID,SERIAL#  : &&sid_serial.
PRO SECONDS      : &&seconds.
--
EXEC DBMS_MONITOR.session_trace_enable(session_id => TO_NUMBER(SUBSTR('&&sid_serial.', 1, INSTR('&&sid_serial.', ',') - 1)), serial_num => TO_NUMBER(SUBSTR('&&sid_serial.', INSTR('&&sid_serial.', ',') + 1)), waits => TRUE, binds => TRUE, plan_stat => 'ALL_EXECUTIONS');
--
COL trace_filename NEW_V trace_filename FOR A200;
SELECT d.value||'/'||i.instance_name||'_ora_'||spid||CASE WHEN pr.traceid IS NOT NULL THEN '_'||pr.traceid END||'.trc' trace_filename
  FROM v$session se, 
       v$process pr,
       v$instance i,
       v$diag_info d
 WHERE se.type = 'USER'
   AND se.sid||','||se.serial# LIKE '%'||REPLACE('&&sid_serial.', ' ')||'%'
   AND pr.con_id = se.con_id
   AND pr.addr = se.paddr
   AND d.name = 'Diag Trace'
/
--
PRO
PRO tracing session &&sid_serial. for &&seconds. seconds...
PRO
EXEC DBMS_LOCK.sleep(seconds => &&seconds.);
EXEC DBMS_MONITOR.session_trace_disable(session_id => TO_NUMBER(SUBSTR('&&sid_serial.', 1, INSTR('&&sid_serial.', ',') - 1)), serial_num => TO_NUMBER(SUBSTR('&&sid_serial.', INSTR('&&sid_serial.', ',') + 1)));
HOST tkprof &&trace_filename. &&cs_file_prefix._&&cs_file_date_time._&&cs_reference_sanitized._tkprof.txt
--
PRO
PRO &&trace_filename.
PRO
PAUSE Trace completed. Press RETURN to display trace
PRO
HOST chmod 600 &&trace_filename.
HOST cat &&trace_filename.
PRO
PRO &&trace_filename.
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@cs_internal/hf_spool_tail.sql
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--
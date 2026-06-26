--==========================================================================
-- Script    : trace_10053_mysid_off.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Desliga o CBO EVENT 10053 na própria Sessão
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- trace_10053_mysid_off.sql - Turn OFF CBO EVENT 10053 on own Session
ALTER SESSION SET EVENTS '10053 TRACE NAME CONTEXT OFF';
--
HOS cp &&trace_file. /tmp/
HOS chmod 600 /tmp/&&filename.
--
PRO scp &&host_name.:/tmp/&&filename.* .

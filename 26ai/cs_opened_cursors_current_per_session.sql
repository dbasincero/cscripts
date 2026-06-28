--==========================================================================
-- Script    : cs_opened_cursors_current_per_session.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SET LIN 2490 PAGES 100 TRIMS ON TAB OFF FEED OFF HEA ON;
--
COL value HEA 'Cursors';
COL username FOR A30;
COL sid FOR 99999;
COL serial# FOR 99999999;
--
select a.value, s.username, s.sid, s.serial#
from v$sesstat a, v$statname b, v$session s
where a.statistic# = b.statistic#  and s.sid=a.sid
and b.name = 'opened cursors current'
order by a.value DESC
/


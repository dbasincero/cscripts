--==========================================================================
-- Script    : hf_ash_snapshot.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
REM Merges a snapshot of v$active_session_history into C##IOD.iod_active_session_history
select count(*) from c##iod.iod_active_session_history;
EXEC C##IOD.IOD_SESS.snap_ash(p_force => 'Y');
select count(*) from c##iod.iod_active_session_history;
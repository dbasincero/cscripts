--==========================================================================
-- Script    : locks.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Resumo e Detalhes de Locks
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SET HEA ON LIN 2490 PAGES 100 TAB OFF FEED OFF ECHO OFF VER OFF TRIMS ON TRIM ON TI OFF TIMI OFF LONG 240000 LONGC 2400 NUM 20 SERVEROUT OFF;
@@cs_internal/hf_locks_internal.sql
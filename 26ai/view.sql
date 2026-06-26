--==========================================================================
-- Script    : view.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Exibe o Texto de uma dada VIEW
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- view.sql - Display Text of a given VIEW name
SET HEA ON LIN 2490 PAGES 100 TAB OFF FEED OFF ECHO OFF VER OFF TRIMS ON TRIM ON TI OFF TIMI OFF LONG 240000 LONGC 2400 SERVEROUT OFF;
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD"T"HH24:MI:SS';
--
SELECT text
  FROM dba_views
 WHERE view_name = UPPER('&view_name.')
/

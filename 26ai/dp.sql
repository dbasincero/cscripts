--==========================================================================
-- Script    : dp.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Exibe Explain Plan da Plan Table. Execute este script após um
--             EXPLAIN PLAN FOR de um SQL para o qual você deseja ver o
--             Explain Plan
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- dp.sql - Display Plan Table Explain Plan. Execute this script after one EXPLAIN PLAN FOR for a SQL for which you want to see the Explain Plan
SET HEA ON LIN 2490 PAGES 100 TAB OFF FEED OFF ECHO OFF VER OFF TRIMS ON TRIM ON TI OFF TIMI OFF LONG 240000 LONGC 2400 NUM 20;
SET HEA OFF PAGES 0;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY('PLAN_TABLE', NULL, 'ADVANCED'));
SET HEA ON PAGES 100;
-- in case it was ON the repeat SQL execution followed by this script
SET SERVEROUT OFF;
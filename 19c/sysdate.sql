--==========================================================================
-- Script    : sysdate.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Exibe SYSDATE em formato seguro para nome de arquivo e em
--             formato YYYY-MM-DDTHH24:MI:SS UTC
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- sysdate.sql - Display SYSDATE in Filename safe format and in YYYY-MM-DDTHH24:MI:SS UTC format
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24.MI.SS"Z"') AS filename_safe_format, TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS') AS current_utc_time FROM dual;

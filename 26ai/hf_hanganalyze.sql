--==========================================================================
-- Script    : hf_hanganalyze.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Gera Trace de Hanganalyze
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_hanganalyze.sql
--
-- Purpose:     Generate Hanganalyze Trace
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/06
--
-- Usage:       Execute connected to CDB or PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_hanganalyze.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
ALTER SESSION SET tracefile_identifier = 'iod_hanganalyze';
COL trace_file NEW_V trace_file;
SELECT value trace_file FROM v$diag_info WHERE name = 'Default Trace File';
oradebug setmypid
oradebug unlimit
oradebug hanganalyze 3
oradebug hanganalyze 3
oradebug hanganalyze 3
oradebug hanganalyze 3
oradebug hanganalyze 3
oradebug hanganalyze 3
oradebug tracefile_name 
HOS cp &&trace_file. /tmp

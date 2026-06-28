--==========================================================================
-- Script    : hf_systemstate.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Gera Trace de System State Dump
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_systemstate.sql
--
-- Purpose:     Generate System State Dump Trace
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/09
--
-- Usage:       Execute connected to CDB or PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_systemstate.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
ALTER SESSION SET tracefile_identifier = 'iod_systemstate';
COL trace_file NEW_V trace_file;
SELECT value trace_file FROM v$diag_info WHERE name = 'Default Trace File';
oradebug setmypid
oradebug unlimit
oradebug dump systemstate 266 
oradebug tracefile_name 
HOS cp &&trace_file. /tmp

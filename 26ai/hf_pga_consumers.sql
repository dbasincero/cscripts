--==========================================================================
-- Script    : hf_pga_consumers.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Consumo de PGA por Processo
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_pga_consumers.sql
--
-- Purpose:     PGA Consumption per Process
--
-- Author:      Carlos Sierra
--
-- Version:     2022/07/12
--
-- Usage:       Execute connected to CDB or PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_pga_consumers.sql
--
-- Notes:       Developed and tested on 19c.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_primary.sql
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
@@cs_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_pga_consumers';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@cs_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@cs_internal/hf_spool_id.sql
--
-- @@cs_internal/&&cs_set_container_to_cdb_root.
--
COL pga_max_mem FOR 999,999,999,990;
COL pga_used_mem FOR 999,999,999,990;
COL pga_alloc_mem FOR 999,999,999,990;
COL pga_freeable_mem FOR 999,999,999,990;
COL pga_tunable_mem FOR 999,999,999,990;
COL spid FOR A6;
COL pname FOR A5;
COL sid FOR 99990;
COL serial# FOR 9999990;
COL con_id FOR 999990;
COL pdb_name FOR A30 TRUNC;
COL tracefile FOR A128;
--
BREAK ON REPORT;
COMPUTE SUM OF pga_max_mem pga_used_mem pga_alloc_mem pga_freeable_mem pga_tunable_mem ON REPORT;
--
PRO
PRO PGA Consumption per Process
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~
WITH c AS (SELECT /*+ MATERIALIZE NO_MERGE */ con_id, name FROM v$containers WHERE ROWNUM >= 1)
SELECT p.pga_max_mem,
       p.pga_alloc_mem,
       p.pga_used_mem,
       p.pga_freeable_mem,
       s.pga_tunable_mem,
       p.spid,
       p.pname,
       s.sid,
       s.serial#,
       s.type,
       s.status,
       s.sql_id,
       s.prev_sql_id,
       p.con_id,
       c.name AS pdb_name,
       p.tracefile
  FROM v$process p,
       v$session s, 
       c
 WHERE &&cs_con_id. IN (1, p.con_id)
   AND s.paddr(+) = p.addr
   AND c.con_id(+) = p.con_id
 ORDER BY
       p.pga_max_mem DESC,
       p.pga_alloc_mem DESC,
       p.pga_used_mem DESC
/
--
CLEAR BREAK COMPUTE;
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@cs_internal/hf_spool_tail.sql
--
-- @@cs_internal/&&cs_set_container_to_curr_pdb.
--
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--
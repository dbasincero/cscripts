--==========================================================================
-- Script    : hf_top_segments.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Top Segments de CDB ou PDB (relatório em texto)
-- Variaveis  : posicionais &1
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_top_segments.sql
--
-- Purpose:     Top CDB or PDB Segments (text report)
--
-- Author:      Carlos Sierra
--
-- Version:     2020/12/09
--
-- Usage:       Execute connected to CDB or PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_top_segments.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
DEF top_segments = '30';
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_top_segments';
--
SELECT DISTINCT tablespace_name 
  FROM cdb_tablespaces
 ORDER BY 1
/
PRO
PRO 1. Enter Tablespace Name (opt):
DEF cs2_tablespace_name = '&1.';
UNDEF 1;
--
SELECT '&&cs_file_prefix._&&cs_script_name.'||CASE WHEN '&&cs2_tablespace_name.' IS NOT NULL THEN '_&&cs2_tablespace_name.' END AS cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql &&cs2_tablespace_name.
@@hf_internal/hf_spool_id.sql
--
PRO TABLESPACE   : "&&cs2_tablespace_name."
--
COL rn FOR A5 HEA 'TOP#';
COL owner FOR A30;
COL segment_name FOR A30;
COL partition_name FOR A30;
COL mbs FOR 999,990;
COL gb FOR 99,990.000 HEA 'SEGMENT|GB';
COL table_name FOR A30;
COL column_name FOR A30;
COL tablespace_name FOR A30;
COL pdb_name FOR A35;
COL securefile FOR A6 HEA 'SECURE|FILE';
COL segment_space_management FOR A10 HEA 'SEGMENT|SPACE|MANAGEMENT';
--
BREAK ON REPORT;
COMPUTE SUM LABEL 'TOTAL' OF gb ON REPORT;
--
PRO
PRO TOP &&top_segments. SEGMENTS (CDB_SEGMENTS)
PRO ~~~~~~~~~~~~~~~
SELECT LPAD(ROW_NUMBER() OVER (ORDER BY s.bytes DESC, s.owner, s.segment_name, s.partition_name), LENGTH('&&top_segments.'), '0') AS rn,
       s.bytes / POWER(10, 9) AS gb,
       s.owner, s.segment_name, s.partition_name,
       CASE WHEN s.segment_type = 'LOBSEGMENT' THEN 'LOB' ELSE s.segment_type END AS segment_type,
       COALESCE(l.table_name, i.table_name) AS table_name,
       l.column_name,
       l.securefile,
       s.tablespace_name,
       t.segment_space_management,
       c.name||'('||s.con_id||')' AS pdb_name
  FROM cdb_segments s,
       cdb_tablespaces t,
       cdb_lobs l,
       cdb_indexes i,
       v$containers c
 WHERE s.tablespace_name = COALESCE('&&cs2_tablespace_name.', s.tablespace_name)
   AND t.con_id = s.con_id
   AND t.tablespace_name = s.tablespace_name
   AND l.con_id(+) = s.con_id
   AND l.owner(+) = s.owner
   AND l.segment_name(+) = s.segment_name
   AND i.con_id(+) = s.con_id
   AND i.owner(+) = s.owner
   AND i.index_name(+) = s.segment_name
   AND c.con_id = s.con_id
   AND c.open_mode = 'READ WRITE'
 ORDER BY
       s.bytes DESC, s.owner, s.segment_name, s.partition_name
 FETCH FIRST &&top_segments. ROWS ONLY
/
--
CLEAR BREAK COMPUTE;
--
PRO
PRO SQL> @&&cs_script_name..sql &&cs2_tablespace_name.
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
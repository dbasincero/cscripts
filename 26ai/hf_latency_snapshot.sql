--==========================================================================
-- Script    : hf_latency_snapshot.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Latência de SQL por snapshot (tempo decorrido por execução)
-- Variaveis  : posicionais &1; &&cs_sample_time_from, &&cs_sample_time_to
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_latency_snapshot.sql
--
-- Purpose:     Snapshot SQL latency (elapsed time over executions)
--
-- Author:      Carlos Sierra
--
-- Version:     2022/08/06
--
-- Usage:       Execute connected to PDB or CDB
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_latency_snapshot.sql
--
-- Notes:       Developed and tested on 19c
--
---------------------------------------------------------------------------------------
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_latency_snapshot';
DEF cs_top_latency = '20';
DEF cs_top_load = '10';
DEF cs_ms_threshold_latency = '0.05';
DEF cs_aas_threshold_latency = '0.005';
DEF cs_aas_threshold_load = '0.05';
DEF cs_uncommon_col = 'NOPRINT';
DEF cs_default_snapshot_seconds = '15';
-- DEF cs_execs_delta_h = '&&cs_last_snap_mins. mins';
DEF cs_execs_delta_h = '';
-- -- [{AUTO}|MANUAL]
-- DEF cs_snap_type = 'AUTO';
-- -- [{-666}|sid]
-- DEF cs_sid = '-666';
--
DEF cs_snap_type = 'MANUAL';
COL cs_sid NEW_V cs_sid NOPRI;
SELECT SYS_CONTEXT('USERENV', 'SID') AS cs_sid FROM DUAL
/
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
PRO
PRO 1. Snapshot Interval Seconds [{&&cs_default_snapshot_seconds.}|5-900]
DEF cs_snapshot_seconds = '&1.';
UNDEF 1;
COL cs_snapshot_seconds NEW_V cs_snapshot_seconds NOPRI;
SELECT CASE WHEN TRUNC(TO_NUMBER('&&cs_snapshot_seconds.')) BETWEEN 5 AND 900 THEN TO_CHAR(TRUNC(TO_NUMBER('&&cs_snapshot_seconds.'))) ELSE '&&cs_default_snapshot_seconds.' END AS cs_snapshot_seconds FROM DUAL
/
DEF cs_execs_delta_h = '&&cs_snapshot_seconds. secs';
--
@@hf_internal/&&cs_set_container_to_cdb_root.
--
@@hf_internal/hf_latency_internal_snapshot.sql
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_snapshot_seconds."
@@hf_internal/hf_spool_id.sql
--
PRO SECONDS      : "&&cs_snapshot_seconds." [{&&cs_default_snapshot_seconds.}|5-900]
PRO TIME_FROM    : "&&cs_sample_time_from."  
PRO TIME_TO      : "&&cs_sample_time_to." 
--
@@hf_internal/hf_latency_internal_cols.sql
@@hf_internal/hf_latency_internal_query_5.sql
@@hf_internal/hf_latency_internal_foot.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_snapshot_seconds."
--
@@hf_internal/hf_spool_tail.sql
--
@@hf_internal/&&cs_set_container_to_curr_pdb.
--
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
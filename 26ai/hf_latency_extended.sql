--==========================================================================
-- Script    : hf_latency_extended.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Latência atual de SQL (tempo decorrido por execução) -
--             Estendido
-- Atalhos    : le.sql
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   le.sql | hf_latency_extended.sql
--
-- Purpose:     Current SQL latency (elapsed time over executions) - Extended
--
-- Author:      Carlos Sierra
--
-- Version:     2022/02/20
--
-- Usage:       Execute connected to PDB or CDB
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_latency_extended.sql
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
DEF cs_script_name = 'cs_latency_extended';
DEF cs_script_acronym = 'le.sql | ';
DEF cs_top_latency = '40';
DEF cs_top_load = '20';
DEF cs_ms_threshold_latency = '0.05';
DEF cs_aas_threshold_latency = '0.005';
DEF cs_aas_threshold_load = '0.05';
DEF cs_uncommon_col = 'PRINT';
DEF cs_execs_delta_h = '&&cs_last_snap_mins. mins';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@hf_internal/hf_spool_id.sql
--
@@hf_internal/hf_latency_internal_cols.sql
@@hf_internal/hf_latency_internal_query_1.sql
@@hf_internal/hf_latency_internal_foot.sql
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

--==========================================================================
-- Script    : hf_ash_awr_block_chains_report.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Relatório de Cadeias de Bloqueio do ASH a partir do AWR
-- Variaveis  : posicionais &3; &&cs_sample_time_from, &&cs_sample_time_to
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_ash_awr_block_chains_report.sql
--
-- Purpose:     ASH Block Chains Report from AWR
--
-- Author:      Carlos Sierra
--
-- Version:     2022/02/04
--
-- Usage:       Execute connected to CDB or PDB
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_ash_awr_block_chains_report.sql
--
-- Notes:       Developed and tested on 19c.
--
---------------------------------------------------------------------------------------
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_ash_awr_block_chains_report';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
DEF cs_hours_range_default = '24';
@@hf_internal/hf_sample_time_from_and_to.sql
@@hf_internal/hf_snap_id_from_and_to.sql
--
PRO To report on Active Sessions over 1x the number of CPU Cores, then pass "1" (default) as Threshold value below
PRO
PRO 3. Threshold: [{1}|0-10] 
DEF times_cpu_cores = '&3.';
UNDEF 3;
COL times_cpu_cores NEW_V times_cpu_cores NOPRI;
SELECT CASE WHEN TO_NUMBER(REPLACE(UPPER('&&times_cpu_cores.'), 'X')) BETWEEN 0 AND 10 THEN REPLACE(UPPER('&&times_cpu_cores.'), 'X') ELSE '1' END AS times_cpu_cores FROM DUAL
/
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sample_time_from." "&&cs_sample_time_to." "&&times_cpu_cores."
@@hf_internal/hf_spool_id.sql
--
@@hf_internal/hf_spool_id_sample_time.sql
--
PRO THRESHOLD    : "&&times_cpu_cores.x NUM_CPU_CORES"
--
-- @@hf_internal/&&cs_set_container_to_cdb_root.
--
-- DEF times_cpu_cores = '1';
DEF include_hist = 'Y';
DEF include_mem = 'N';
--
@@hf_internal/hf_ash_block_chains.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sample_time_from." "&&cs_sample_time_to." "&&times_cpu_cores."
--
@@hf_internal/hf_spool_tail.sql
--
-- @@hf_internal/&&cs_set_container_to_curr_pdb.
--
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
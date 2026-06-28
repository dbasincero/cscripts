--==========================================================================
-- Script    : hf_top_range.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Top SQL ativo conforme Active Sessions History ASH -
--             intervalo de tempo
-- Atalhos    : tr.sql
-- Variaveis  : &&cs_sample_time_from, &&cs_sample_time_to
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_top_range.sql
--
-- Purpose:     Top Active SQL as per Active Sessions History ASH - time range
--
-- Author:      Carlos Sierra
--
-- Version:     2022/08/17
--
-- Usage:       Execute connected to PDB or CDB
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_top_range.sql
--
-- Notes:       *** Requires Oracle Diagnostics Pack License ***
--
--              Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_top_range';
DEF cs_script_acronym = 'tr.sql | ';
--
DEF cs_top = '30';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
DEF cs_hours_range_default = '1';
@@hf_internal/hf_sample_time_from_and_to.sql
@@hf_internal/hf_snap_id_from_and_to.sql
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql "&&cs_sample_time_from." "&&cs_sample_time_to."
@@hf_internal/hf_spool_id.sql
--
@@hf_internal/hf_spool_id_sample_time.sql
--
@@hf_internal/hf_top_activity_internal_range.sql
@@hf_internal/hf_top_internal_foot.sql
--
PRO
PRO SQL> @&&cs_script_name..sql "&&cs_sample_time_from." "&&cs_sample_time_to."
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--
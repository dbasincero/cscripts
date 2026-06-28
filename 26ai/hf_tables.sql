--==========================================================================
-- Script    : hf_tables.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Todas as Tabelas e Top N Tabelas (relatório em texto)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_tables.sql
--
-- Purpose:     All Tables and Top N Tables (text report)
--
-- Author:      Carlos Sierra
--
-- Version:     2023/01/20
--
-- Usage:       Execute connected to PDB or CDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_tables.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@hf_internal/hf_primary.sql
@@hf_internal/hf_cdb_warn.sql
@@hf_internal/hf_set.sql
@@hf_internal/hf_def.sql
@@hf_internal/hf_file_prefix.sql
--
DEF cs_script_name = 'cs_tables';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@hf_internal/hf_spool_id.sql
--
BREAK ON REPORT;
COMPUTE SUM OF total_MB table_MB indexes_MB tabs lobs_MB est_data_MB lobs idxs num_rows ON REPORT;
--
DEF specific_owner = '';
DEF specific_table = '';
DEF order_by = 't.owner, t.table_name';
DEF fetch_first_N_rows = '10000';
PRO
PRO All Tables
PRO ~~~~~~~~~~
@@hf_internal/hf_tables_internal.sql
--
DEF specific_table = '';
DEF order_by = 'NVL(t.bytes,0)+NVL(i.bytes,0)+NVL(l.bytes,0) DESC';
DEF fetch_first_N_rows = '20';
PRO
PRO Top Tables
PRO ~~~~~~~~~~
@@hf_internal/hf_tables_internal.sql
--
PRO
PRO SQL> @&&cs_script_name..sql
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

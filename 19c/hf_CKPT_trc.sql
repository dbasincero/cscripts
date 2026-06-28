--==========================================================================
-- Script    : hf_CKPT_trc.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Obtém o trace do check point CKPT
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_CKPT_trc.sql
--
-- Purpose:     Get check point CKPT trace
--
-- Author:      Carlos Sierra
--
-- Version:     2022/09/08
--
-- Usage:       Execute connected to CDB or PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_CKPT_trc.sql
--
-- Notes:       Developed and tested on 12.1.0.2.
--
---------------------------------------------------------------------------------------
--
@@cs_internal/hf_set.sql
@@cs_internal/hf_def.sql
--
COL trace_dir NEW_V trace_dir FOR A100 NOPRI;
COL ckpt_trc NEW_V ckpt_trc FOR A30 NOPRI;
SELECT d.value AS trace_dir, LOWER('&&cs_db_name._')||LOWER(p.pname)||'_'||p.spid||'.trc' AS ckpt_trc FROM v$diag_info d, v$process p WHERE d.name = 'Diag Trace' AND p.pname = 'CKPT';
--
HOS cat &&trace_dir./&&ckpt_trc.
PRO 
PRO &&trace_dir./&&ckpt_trc.
PRO
HOS cp &&trace_dir./&&ckpt_trc. /tmp/
HOS chmod 600 /tmp/&&ckpt_trc.
PRO
PRO Preserved CKPT trace on /tmp
PRO ~~~~~~~~~~~~~~~~~~~~~~~
HOS ls -oX /tmp/&&ckpt_trc.
PRO
PRO If you want to copy CKPT trace file, execute scp command below, from a TERM session running on your Mac/PC:
PRO
PRO scp &&cs_host_name.:/tmp/&&ckpt_trc. &&cs_local_dir.
--
@@cs_internal/hf_undef.sql
@@cs_internal/hf_reset.sql
--

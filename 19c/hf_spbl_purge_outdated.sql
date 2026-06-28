--==========================================================================
-- Script    : hf_spbl_purge_outdated.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Faz purge de SQL Plan Baselines desatualizados
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
----------------------------------------------------------------------------------------
--
-- File name:   hf_spbl_purge_outdated.sql
--
-- Purpose:     Purge Outdated SQL Plan Baselines
--
-- Author:      Carlos Sierra
--
-- Version:     2021/01/23
--
-- Usage:       Connecting into PDB.
--
-- Example:     $ sqlplus / as sysdba
--              SQL> @hf_spbl_purge_outdated.sql
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
DEF cs_script_name = 'cs_spbl_purge_outdated';
--
SELECT '&&cs_file_prefix._&&cs_script_name.' cs_file_name FROM DUAL;
--
@@hf_internal/hf_spool_head.sql
PRO SQL> @&&cs_script_name..sql 
@@hf_internal/hf_spool_id.sql
--
PRO
PRO please wait ...
SET SERVEROUT ON;
WHENEVER SQLERROR EXIT FAILURE;

DECLARE
  l_plans INTEGER;
BEGIN
  FOR i IN (SELECT o.signature,
                   o.category,
                   o.obj_type,
                   o.plan_id,
                   t.sql_handle,
                   o.name AS plan_name,
                   DECODE(BITAND(o.flags, 1),   0, 'NO', 'YES') AS enabled,
                   a.description
               FROM sys.sqlobj$ o,
                    sys.sqlobj$auxdata a,
                    sys.sql$text t
             WHERE o.category = 'DEFAULT'
               AND o.obj_type = 2
               AND a.signature = o.signature
               AND a.category = o.category
               AND a.obj_type = o.obj_type
               AND a.plan_id = o.plan_id
               AND t.signature = o.signature
               AND NOT EXISTS (
                     SELECT NULL
                       FROM sys.sqlobj$plan p
                       WHERE p.signature = o.signature
                         AND p.category = o.category
                         AND p.obj_type = o.obj_type 
                         AND p.plan_id = o.plan_id
                         AND p.id = 1
                         AND ROWNUM = 1
               )
               AND NOT EXISTS (
                     SELECT NULL
                       FROM sys.sqlobj$data d
                       WHERE d.signature = o.signature
                         AND d.category = o.category
                         AND d.obj_type = o.obj_type 
                         AND d.plan_id = o.plan_id
                         AND d.comp_data IS NOT NULL
                         AND ROWNUM = 1
               )
             ORDER BY
                   o.signature, o.category, o.obj_type, o.plan_id)
  LOOP
    DBMS_OUTPUT.put_line('Plan: '||i.plan_name||' '||i.description);
    IF i.enabled = 'YES' THEN
      DBMS_OUTPUT.put_line('Disabling Plan');
      l_plans := DBMS_SPM.alter_sql_plan_baseline(sql_handle => i.sql_handle, plan_name => i.plan_name, attribute_name => 'ENABLED', attribute_value => 'NO');
      DBMS_OUTPUT.put_line('Disabled '||l_plans||' Plan(s)');
    END IF;
    DBMS_OUTPUT.put_line('Fixing Corrupted Plan');
    DELETE sys.sqlobj$plan WHERE signature = i.signature AND category = i.category AND obj_type = i.obj_type AND plan_id = i.plan_id AND id = 1;
    INSERT INTO sys.sqlobj$plan (signature, category, obj_type, plan_id, id) VALUES (i.signature, i.category, i.obj_type, i.plan_id, 1);
    COMMIT;
    DBMS_OUTPUT.put_line('Droping Plan');
    l_plans := DBMS_SPM.drop_sql_plan_baseline(sql_handle => i.sql_handle, plan_name => i.plan_name);
    DBMS_OUTPUT.put_line('Dropped '||l_plans||' Plan(s)');
  END LOOP;
  DBMS_OUTPUT.put_line('Dropping Outdated Plan(s)');
  l_plans := SYS.DBMS_SPM_INTERNAL.auto_purge_sql_plan_baseline;
  DBMS_OUTPUT.put_line('Dropped '||l_plans||' Outdated Plan(s)');
END;
/
WHENEVER SQLERROR CONTINUE;

SET SERVEROUT OFF;
--
PRO
PRO SQL> @&&cs_script_name..sql 
--
@@hf_internal/hf_spool_tail.sql
@@hf_internal/hf_undef.sql
@@hf_internal/hf_reset.sql
--

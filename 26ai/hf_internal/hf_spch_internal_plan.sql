--==========================================================================
-- Script    : hf_spch_internal_plan.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO SQL PATCH - DISPLAY (dbms_xplan.display_sql_patch_plan)
PRO ~~~~~~~~~~~~~~~~~~~
-- only works from PDB.
SET HEA OFF PAGES 0;
SELECT * FROM TABLE(DBMS_XPLAN.display_sql_patch_plan((SELECT name FROM dba_sql_patches WHERE signature = :cs_signature AND category = 'DEFAULT' AND ROWNUM = 1), 'ADVANCED'));
SET HEA ON PAGES 100;

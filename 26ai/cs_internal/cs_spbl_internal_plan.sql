--==========================================================================
-- Script    : cs_spbl_internal_plan.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Variaveis  : &&cs_sql_handle
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO SQL PLAN BASELINES - DISPLAY (dbms_xplan.display_sql_plan_baseline)
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- only works from PDB.
SET HEA OFF PAGES 0;
SELECT * FROM TABLE(DBMS_XPLAN.display_sql_plan_baseline('&&cs_sql_handle.', NULL, 'ADVANCED')) WHERE '&&cs_sql_handle.' IS NOT NULL;
SET HEA ON PAGES 100;

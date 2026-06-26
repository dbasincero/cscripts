--==========================================================================
-- Script    : cs_sprf_internal_plan.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO SQL PROFILE - DISPLAY (dbms_xplan.display_sql_profile_plan)
PRO ~~~~~~~~~~~~~~~~~~~~~
-- only works from PDB.
SET HEA OFF PAGES 0;
SELECT * FROM TABLE(DBMS_XPLAN.display_sql_profile_plan((SELECT name FROM dba_sql_profiles WHERE signature = :cs_signature AND category = 'DEFAULT' AND ROWNUM = 1), 'ADVANCED'));
SET HEA ON PAGES 100;

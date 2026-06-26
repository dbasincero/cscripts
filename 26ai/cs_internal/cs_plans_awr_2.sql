--==========================================================================
-- Script    : cs_plans_awr_2.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : &&cs_dbid, &&cs_plan_hash_value, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO AWR PLANS - DISPLAY (dbms_xplan.display_awr)
PRO ~~~~~~~~~~~~~~~~~~~
SET HEA OFF PAGES 0;
WITH 
plans_by_timestamp AS (
SELECT /*+ MATERIALIZE NO_MERGE */
       h.sql_id,
       h.plan_hash_value
  FROM dba_hist_sql_plan h -- cannot use cdb_hist_sql_plan since DBMS_XPLAN only executes with a PDB (would need to use DBMS_SQL to execue from CDB$ROOT)
 WHERE h.sql_id = '&&cs_sql_id.'
   AND ('&&cs_plan_hash_value.' IS NULL OR h.plan_hash_value = TO_NUMBER('&&cs_plan_hash_value.'))
   AND h.id = 0
   AND h.dbid = TO_NUMBER('&&cs_dbid.') 
 ORDER BY
       h.timestamp
)
SELECT p.plan_table_output
  FROM plans_by_timestamp h,
       TABLE(DBMS_XPLAN.display_awr(h.sql_id, h.plan_hash_value, NULL, 'ADVANCED')) p
/
SET HEA ON PAGES 100;
--

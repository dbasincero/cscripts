--==========================================================================
-- Script    : hf_spbl_sprf_spch_cnt.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SET LIN 2490 PAGES 100 TRIMS ON TAB OFF FEED OFF HEA ON;
--
COL pdb_name FOR A30;
SELECT c.pdb_name, bl.cnt AS bl, pr.cnt AS pr, pa.cnt AS pa
  FROM (SELECT con_id, name AS pdb_name FROM v$containers) c,
       (SELECT con_id, COUNT(*) As cnt FROM cdb_sql_plan_baselines GROUP BY con_id) bl,
       (SELECT con_id, COUNT(*) As cnt FROM cdb_sql_profiles GROUP BY con_id) pr,
       (SELECT con_id, COUNT(*) As cnt FROM cdb_sql_patches GROUP BY con_id) pa
 WHERE bl.con_id = c.con_id
   AND pr.con_id = c.con_id
   AND pa.con_id = c.con_id
 ORDER BY
       c.pdb_name
/
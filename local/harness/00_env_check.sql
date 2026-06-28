--==========================================================================
-- 00_env_check.sql — checagem de ambiente p/ validar pre-requisitos dos cscripts
-- Rodar em cada banco:  @00_env_check.sql
--==========================================================================
SET PAGES 200 LIN 200 FEED OFF VER OFF
COL item FOR A34
COL valor FOR A60

PRO ================ IDENTIDADE / VERSAO ================
SELECT 'banner' AS item, banner_full AS valor FROM v$version WHERE ROWNUM=1
UNION ALL SELECT 'version_full', version_full FROM v$instance
UNION ALL SELECT 'con_name', SYS_CONTEXT('USERENV','CON_NAME') FROM DUAL
UNION ALL SELECT 'cdb?', (SELECT cdb FROM v$database) FROM DUAL
UNION ALL SELECT 'instance_number', TO_CHAR(instance_number) FROM v$instance;

PRO ================ VIEWS/PRIVILEGIOS NECESSARIOS ================
COL obj FOR A32
COL ok FOR A6
SELECT obj, CASE WHEN cnt>0 THEN 'OK' ELSE 'FALTA' END AS ok FROM (
  SELECT 'v$session'            AS obj, COUNT(*) cnt FROM v$session            WHERE ROWNUM=1
  UNION ALL SELECT 'v$active_session_history', COUNT(*) FROM v$active_session_history WHERE ROWNUM=1
  UNION ALL SELECT 'v$containers', COUNT(*) FROM v$containers WHERE ROWNUM=1
  UNION ALL SELECT 'dba_hist_snapshot', COUNT(*) FROM dba_hist_snapshot WHERE ROWNUM=1
  UNION ALL SELECT 'dba_hist_active_sess_history', COUNT(*) FROM dba_hist_active_sess_history WHERE ROWNUM=1
  UNION ALL SELECT 'cdb_services', COUNT(*) FROM cdb_services WHERE ROWNUM=1
);

PRO ================ STUBS INTERNOS (C##IOD) ================
SELECT object_type AS item, owner||'.'||object_name AS valor
  FROM dba_objects
 WHERE owner='C##IOD'
   AND object_name IN ('IOD_META_AUX','PDB_CONFIG','DBC_SYSTEM','DBC_RSRCMGRMETRIC_HISTORY','DBC_PDB_METADATA_V')
 ORDER BY object_name;

PRO ================ DIAGNOSTIC_DEST (p/ scripts de trace) ================
SELECT 'diagnostic_dest' AS item, value AS valor FROM v$parameter WHERE name='diagnostic_dest';
SET FEED ON

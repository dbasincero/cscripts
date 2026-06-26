--==========================================================================
-- Script    : cs_spool_id_chart.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
@@cs_spool_id_chart_pre.sql
@@cs_spool_time.sql
PRO <pre>
@@cs_spool_id_list.sql
PRO </pre>
@@cs_spool_id_chart_post.sql

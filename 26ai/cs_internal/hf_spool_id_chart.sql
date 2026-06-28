--==========================================================================
-- Script    : hf_spool_id_chart.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
@@hf_spool_id_chart_pre.sql
@@hf_spool_time.sql
PRO <pre>
@@hf_spool_id_list.sql
PRO </pre>
@@hf_spool_id_chart_post.sql

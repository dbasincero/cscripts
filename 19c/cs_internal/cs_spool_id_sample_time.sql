--==========================================================================
-- Script    : cs_spool_id_sample_time.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : &&cs_sample_time_from, &&cs_sample_time_to
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
--
PRO TIME_FROM    : "&&cs_entered_time_from." &&cs_sample_time_from. (&&cs_snap_id_from.) {&&cs_default_time_window.} 
PRO TIME_TO      : "&&cs_entered_time_to." &&cs_sample_time_to. (&&cs_snap_id_to.) {now} 
--

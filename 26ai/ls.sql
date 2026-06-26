--==========================================================================
-- Script    : ls.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Variaveis  : posicionais &1
-- Seguranca  : executa comando de SO (host/!) — confira o comando antes de rodar
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO Producing list of cs scripts as per: HOST ls $ORATK_HOME/sql/cscripts/<file_mask> | xargs -n1 basename | sort
PRO 
PRO 1. Enter optional file_mask, e.g.: [{*}|cs|spbl|sprf|spch|ash|chart|awr|kiev|session|kill|sqlmon|osstat|...]
HOST ls $ORATK_HOME/sql/cscripts/*&1.* | xargs -n1 basename | sort
UNDEF 1

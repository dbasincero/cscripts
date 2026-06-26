--==========================================================================
-- Script    : pr.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Print Table (exibição vertical das colunas de resultado da
--             última consulta)
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- null parameter (assumes then last sql executed)
@@cs_pr.sql ""
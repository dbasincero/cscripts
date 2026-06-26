--==========================================================================
-- Script    : cs_sqlstat_foot.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO 1. For more SQL Statistics history use ssr.sql (cs_sqlstat_report.sql) or ssri.sql (cs_sqlstat_report_iod.sql). The former provides 15m, hourly, daily or global granularity, while the latter 1m granularity.
PRO
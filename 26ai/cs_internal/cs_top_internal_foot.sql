--==========================================================================
-- Script    : cs_top_internal_foot.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO 1. Top Active SQL as per Active Sessions History ASH.
PRO 2. Up to &&cs_top. SQL statements per SQL Type as per Average Active Sessions (AAS) on Elpsped Time.
PRO 3. For database load on last 1 minute use t.sql (cs_top.sql). Use ta.sql to eliminate report heading.
PRO 4. For database load over a time range use tr.sql (cs_top_range.sql).
PRO
--==========================================================================
-- Script    : awr_snapshot.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Cria snapshot do AWR
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- Create AWR snapshot
EXEC DBMS_WORKLOAD_REPOSITORY.create_snapshot;
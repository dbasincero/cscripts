--==========================================================================
-- Script    : cs_pdbs.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Atributos dos PDBs
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- cs_pdbs.sql
@@cs_pr.sql "SELECT * FROM C##IOD.dbc_pdb_meta_v ORDER BY 1"

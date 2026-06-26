--==========================================================================
-- Script    : cs_spch_internal_drop.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Variaveis  : &&cs_signature
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
BEGIN
  FOR i IN (SELECT name FROM dba_sql_patches WHERE signature = &&cs_signature.)
  LOOP
    DBMS_SQLDIAG.drop_sql_patch(name => i.name); 
  END LOOP;
END;
/

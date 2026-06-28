--==========================================================================
-- Script    : hf_sprf_internal_drop.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Variaveis  : &&cs_signature, &&cs_sql_id
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO Drop SQL Profile(s) for: "&&cs_sql_id."
BEGIN
  FOR i IN (SELECT name FROM dba_sql_profiles WHERE signature = &&cs_signature.) 
  LOOP
    DBMS_SQLTUNE.drop_sql_profile(name => i.name); 
  END LOOP;
END;
/

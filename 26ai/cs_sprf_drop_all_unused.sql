--==========================================================================
-- Script    : cs_sprf_drop_all_unused.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SELECT name FROM dba_sql_profiles MINUS SELECT sql_profile FROM v$sql WHERE sql_profile IS NOT NULL;
BEGIN
  FOR i IN (SELECT name FROM dba_sql_profiles MINUS SELECT sql_profile FROM v$sql WHERE sql_profile IS NOT NULL) 
  LOOP
    DBMS_SQLTUNE.drop_sql_profile(name => i.name); 
  END LOOP;
END;
/
SELECT name FROM dba_sql_profiles MINUS SELECT sql_profile FROM v$sql WHERE sql_profile IS NOT NULL;
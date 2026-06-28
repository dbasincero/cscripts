--==========================================================================
-- Script    : loop.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SET TIM ON TIMI ON;
DECLARE
  l_date DATE := SYSDATE;
  l_seconds INTEGER := 600;
BEGIN
  WHILE l_date + (l_seconds/24/60/60) > SYSDATE -- loop for l_seconds
  LOOP
    NULL;
  END LOOP;
END;
/

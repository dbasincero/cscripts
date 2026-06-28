--==========================================================================
-- Script    : hf_set_quota_tools_owner.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script de diagnóstico/utilitário Oracle (ver corpo do script
--             para detalhes).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- gets tablespace
COL cs_default_tablespace NEW_V cs_default_tablespace NOPRI;
SELECT default_tablespace AS cs_default_tablespace FROM dba_users WHERE username = UPPER('&&cs_stgtab_owner.');
-- set unlimited quota
ALTER USER &&cs_stgtab_owner. QUOTA UNLIMITED ON &&cs_default_tablespace.;
--
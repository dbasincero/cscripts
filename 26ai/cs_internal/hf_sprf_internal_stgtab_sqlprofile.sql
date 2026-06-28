--==========================================================================
-- Script    : hf_sprf_internal_stgtab_sqlprofile.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
COL created FOR A23;
COL name FOR A30;
COL category FOR A30;
COL status FOR 99999999;
COL last_modified FOR A19;
COL description FOR A100 HEA 'Description' WOR;
--
PRO
PRO SQL PROFILES ON STAGING TABLE (&&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_sqlprof)
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT TO_CHAR(created, '&&cs_datetime_full_format.') created, 
       obj_name name,
       category,
       status,
       TO_CHAR(last_modified, '&&cs_datetime_full_format.') last_modified, 
       description
  FROM &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_sqlprof
 WHERE signature = :cs_signature
 ORDER BY
       created, obj_name
/

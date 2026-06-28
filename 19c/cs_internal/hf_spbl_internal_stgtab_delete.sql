--==========================================================================
-- Script    : hf_spbl_internal_stgtab_delete.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Variaveis  : &&cs_signature
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_baseline;
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT COUNT(*) AS "ROWS" FROM &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_baseline;
--
PRO
PRO DELETE &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_baseline WHERE signature = COALESCE(TO_NUMBER('&&cs_signature.'), signature) AND obj_name = COALESCE(TRIM('&&cs_plan_name.'), obj_name);
PRO ~~~~~~
DELETE &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_baseline WHERE signature = COALESCE(TO_NUMBER('&&cs_signature.'), signature) AND obj_name = COALESCE(TRIM('&&cs_plan_name.'), obj_name);
PRO
PRO &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_baseline;
PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT COUNT(*) AS "ROWS" FROM &&cs_stgtab_owner..&&cs_stgtab_prefix._stgtab_baseline;
--
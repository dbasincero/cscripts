--==========================================================================
-- hf_internal_stubs.sql
-- Cria objetos-STUB do ambiente interno Oracle Cloud (IOD/dbc_*/kiev) que o
-- hf_internal/hf_def.sql referencia, para que os cscripts rodem num banco
-- 19c/26ai limpo (fora da frota interna da Oracle).
--
-- Rodar como SYSDBA, UMA VEZ por container (CDB$ROOT e cada PDB).
-- Ex.:  sqlplus sys/<pwd>@//host:porta/SERVICO as sysdba @hf_internal_stubs.sql
--
-- Sao stubs: retornam valores fixos/neutros so para o cs_def completar. NAO
-- representam a topologia real. Objetos kiev/zapper sao opcionais (cs_def os
-- protege com checagens de existencia), entao nao sao criados aqui.
--==========================================================================
SET ECHO ON FEEDBACK ON
WHENEVER SQLERROR CONTINUE

-- Usuario comum dono dos stubs (cs_def: DEF iod_user = 'C##IOD')
DECLARE
  v_n NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_n FROM dba_users WHERE username = 'C##IOD';
  IF v_n = 0 THEN
    EXECUTE IMMEDIATE 'CREATE USER C##IOD IDENTIFIED BY iod_stub_pwd_2026 CONTAINER=ALL';
  END IF;
END;
/
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, UNLIMITED TABLESPACE TO C##IOD CONTAINER=ALL;

-- ------------------------------------------------------------------ pacotes
CREATE OR REPLACE PACKAGE C##IOD.IOD_META_AUX AS
  FUNCTION get_region(p_host IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_realm(p_region IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_region_acronym(p_region IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_other_acronym(p_region IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_onsr(p_region IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_dedicated(p_region IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_locale(p_value IN VARCHAR2) RETURN VARCHAR2;
END IOD_META_AUX;
/
CREATE OR REPLACE PACKAGE BODY C##IOD.IOD_META_AUX AS
  FUNCTION get_region(p_host IN VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN 'LOCAL_LAB'; END;
  FUNCTION get_realm(p_region IN VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN 'LAB'; END;
  FUNCTION get_region_acronym(p_region IN VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN 'LAB'; END;
  FUNCTION get_other_acronym(p_region IN VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN ''; END;
  FUNCTION get_onsr(p_region IN VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN 'N'; END;
  FUNCTION get_dedicated(p_region IN VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN 'N'; END;
  FUNCTION get_locale(p_value IN VARCHAR2) RETURN VARCHAR2 IS BEGIN RETURN 'LAB'; END;
END IOD_META_AUX;
/

CREATE OR REPLACE PACKAGE C##IOD.PDB_CONFIG AS
  FUNCTION get_cdb_availability RETURN NUMBER;
END PDB_CONFIG;
/
CREATE OR REPLACE PACKAGE BODY C##IOD.PDB_CONFIG AS
  FUNCTION get_cdb_availability RETURN NUMBER IS BEGIN RETURN 1; END;
END PDB_CONFIG;
/

-- ------------------------------------------------------------------ tabelas
CREATE TABLE C##IOD.dbc_system (
  timestamp        DATE,
  host_shape       VARCHAR2(64),
  disk_config      VARCHAR2(64),
  system_boot_time DATE
);
INSERT INTO C##IOD.dbc_system (timestamp, host_shape, disk_config, system_boot_time)
VALUES (SYSDATE, 'LAB.LOCAL', 'LOCAL_DISK', SYSDATE - 1);

CREATE TABLE C##IOD.dbc_rsrcmgrmetric_history (
  end_time             DATE,
  avg_running_sessions NUMBER,
  pdb_name             VARCHAR2(128),
  consumer_group_name  VARCHAR2(128)
);

CREATE OR REPLACE VIEW C##IOD.dbc_pdb_metadata_v AS
SELECT SYS_CONTEXT('USERENV','CON_NAME') AS pdb_name,
       'UNKNOWN' AS phonebook,
       'UNKNOWN' AS compartment_id,
       'N/A'     AS kiev_store_name
  FROM DUAL;

COMMIT;
PROMPT === Stubs C##IOD criados no container atual ===
SELECT SYS_CONTEXT('USERENV','CON_NAME') AS container_atual FROM DUAL;

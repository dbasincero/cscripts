--==========================================================================
-- Script    : hf_internal_list_dg_members.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
SET SERVEROUT ON;
BEGIN -- using pl/sql to avoid a blank line
  FOR i IN (SELECT RPAD(r.role, 13, ' ')||': '||d.db_unique_name||' HOST:'||h.host_name||CASE h.host_name WHEN '&&cs_host_name.' THEN ' <-' END AS dg_members
            FROM
            (SELECT x.value db_unique_name, ROW_NUMBER() OVER (ORDER BY x.indx) AS rn FROM x$drc x WHERE x.attribute = 'DATABASE') d,
            (SELECT x.value role, ROW_NUMBER() OVER (ORDER BY x.indx) AS rn FROM x$drc x WHERE x.attribute = 'role') r,
            (SELECT x.value host_name, ROW_NUMBER() OVER (ORDER BY x.indx) AS rn FROM x$drc x WHERE x.attribute = 'host') h
            WHERE r.rn = d.rn AND h.rn = d.rn
            ORDER BY r.role DESC, d.db_unique_name
  )
  LOOP
    DBMS_OUTPUT.put_line(i.dg_members);
  END LOOP;
END;
/
SET SERVEROUT OFF;
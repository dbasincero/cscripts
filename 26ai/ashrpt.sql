--==========================================================================
-- Script    : ashrpt.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Relatório ASH
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- ASH report
@$ORACLE_HOME/rdbms/admin/ashrpt.sql
--
HOS cp ashrpt_*.* /tmp
HOS chmod 644 /tmp/ashrpt_*.*
PRO
PRO If you want to preserve script output, execute corresponding scp command below, from a TERM session running on your Mac/PC:
HOS echo "scp $HOSTNAME:/tmp/ashrpt_*.* ."
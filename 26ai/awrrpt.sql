--==========================================================================
-- Script    : awrrpt.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Relatório AWR
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- AWR Report
@$ORACLE_HOME/rdbms/admin/awrrpt.sql
--
HOS cp awrrpt_*.* /tmp
HOS chmod 644 /tmp/awrrpt_*.*
PRO
PRO If you want to preserve script output, execute corresponding scp command below, from a TERM session running on your Mac/PC:
HOS echo "scp $HOSTNAME:/tmp/awrrpt_*.* ."
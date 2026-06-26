--==========================================================================
-- Script    : awrsqrpt.sql
-- Versao    : Oracle Database 19c (19.x)
-- Uso       : Relatório AWR SQL
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
-- AWR SQL Report
@$ORACLE_HOME/rdbms/admin/awrsqrpt.sql
--
HOS cp awrsqlrpt_*.* /tmp
HOS chmod 644 /tmp/awrsqlrpt_*.*
PRO
PRO If you want to preserve script output, execute corresponding scp command below, from a TERM session running on your Mac/PC:
HOS echo "scp $HOSTNAME:/tmp/awrsqlrpt_*.* ."
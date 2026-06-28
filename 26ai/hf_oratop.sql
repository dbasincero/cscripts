--==========================================================================
-- Script    : hf_oratop.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Monitor estilo oratop (snapshot): secao global (AAS, CPU, DB
--             time, load), top eventos, top sessoes ativas e top SQL (ASH).
-- Variaveis  : &&oratop_secs (janela ASH em s, default 60); &&oratop_top
--             (numero de linhas no top, default 10)
-- Seguranca  : secoes ASH (v$active_session_history) e v$sysmetric exigem
--             Diagnostic Pack; comente-as se nao licenciado.
-- Pre-req    : conexao com privilegio de DBA (acessa views V$).
--==========================================================================
-- ---------------------------------------------------------------------------
-- hf_oratop.sql — Monitor "estilo oratop" (snapshot) em SQL puro e EDITAVEL.
--
-- NAO e o oratop oficial da Oracle (que e um binario proprietario do MOS,
-- nota 1500864.1). Esta e uma reimplementacao em SQL para voce MODIFICAR a
-- vontade: mostra, num unico disparo, as mesmas informacoes-chave do oratop.
--
-- Como usar:   SQL> @hf_oratop.sql
--   - &&oratop_secs : janela do ASH em segundos (default 60)
--   - &&oratop_top  : numero de linhas no "top" (default 10)
--   Para "atualizar" como o oratop, re-execute o script (ou rode em loop:
--   no shell:  watch -n5 "sqlplus -s user/pwd @hf_oratop.sql")
--
-- Observacao de licenca: as secoes que usam ASH (v$active_session_history)
-- e v$sysmetric exigem o Diagnostic Pack. Se nao tiver, comente essas secoes.
-- ---------------------------------------------------------------------------
SET LIN 300 PAGES 100 TRIMS ON TAB OFF FEED OFF HEA ON VER OFF NUM 12
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--
-- Parametros editaveis ---------------------------------------------------------
DEF oratop_secs = '60'
DEF oratop_top  = '10'
--
PRO
PRO ===================================================================================
PRO  cs_oratop  -  snapshot estilo oratop  -  &&oratop_secs.s de janela ASH
PRO ===================================================================================

-- == Secao 1: Banco / Instancia (linha global do oratop) =======================
COL db        FOR A12      HEA 'DB'
COL inst      FOR A12      HEA 'Instancia'
COL versao    FOR A18      HEA 'Versao'
COL uptime    FOR A8       HEA 'Uptime'
COL cpus      FOR 9999     HEA 'CPUs'
COL load      FOR 9990.0   HEA 'OS Load'
COL sessions  FOR 999990   HEA 'Sessoes'
COL active    FOR 99990    HEA 'Ativas'
SELECT d.name AS db,
       i.instance_name AS inst,
       i.version_full AS versao,
       TRIM(TO_CHAR(ROUND(SYSDATE - i.startup_time, 1), '9990.0'))||'d' AS uptime,
       (SELECT value FROM v$osstat WHERE stat_name = 'NUM_CPUS') AS cpus,
       (SELECT ROUND(value, 1) FROM v$osstat WHERE stat_name = 'LOAD') AS load,
       (SELECT COUNT(*) FROM v$session WHERE type = 'USER') AS sessions,
       (SELECT COUNT(*) FROM v$session
         WHERE status = 'ACTIVE' AND type = 'USER'
           AND NVL(wait_class, 'CPU') <> 'Idle') AS active
  FROM v$database d, v$instance i
/

-- == Secao 2: Metricas globais do ultimo intervalo (v$sysmetric) ===============
COL metrica FOR A36 HEA 'Metrica (ultimo ~60s)'
COL valor   FOR A18 HEA 'Valor'
SELECT metric_name AS metrica,
       TO_CHAR(ROUND(value, 2))||' '||metric_unit AS valor
  FROM v$sysmetric
 WHERE group_id = 2
   AND metric_name IN ('Average Active Sessions',
                       'Host CPU Utilization (%)',
                       'Database CPU Time Ratio',
                       'Database Wait Time Ratio',
                       'Database Time Per Sec',
                       'Executions Per Sec',
                       'User Transaction Per Sec',
                       'Logical Reads Per Sec',
                       'Physical Reads Per Sec',
                       'Hard Parse Count Per Sec')
 ORDER BY metric_name
/

-- == Secao 3: Top eventos cronometrados agora (v$session ativas) ===============
COL wait_class FOR A18 HEA 'Wait Class'
COL evento     FOR A44 HEA 'Evento / ON CPU'
COL sess       FOR 99990 HEA 'Sessoes'
PRO
PRO Top eventos (sessoes ativas agora)
PRO ----------------------------------
SELECT * FROM (
  SELECT CASE WHEN s.state = 'WAITING' THEN s.wait_class ELSE 'CPU' END AS wait_class,
         CASE WHEN s.state = 'WAITING' THEN s.event ELSE 'ON CPU' END AS evento,
         COUNT(*) AS sess
    FROM v$session s
   WHERE s.status = 'ACTIVE'
     AND s.type = 'USER'
     AND NVL(s.wait_class, 'CPU') <> 'Idle'
   GROUP BY CASE WHEN s.state = 'WAITING' THEN s.wait_class ELSE 'CPU' END,
            CASE WHEN s.state = 'WAITING' THEN s.event ELSE 'ON CPU' END
   ORDER BY sess DESC
) WHERE ROWNUM <= &&oratop_top.
/

-- == Secao 4: Top sessoes ativas =============================================
COL con_id      FOR 9990   HEA 'Con|ID'
COL sid_serial  FOR A12    HEA 'Sid,Serial#'
COL username    FOR A20    HEA 'Usuario'
COL machine     FOR A24    HEA 'Maquina' TRUNC
COL curr_event  FOR A36    HEA 'Evento atual' TRUNC
COL sql_id      FOR A14    HEA 'SQL_ID'
COL secs        FOR 9999990 HEA 'LastCall|(s)'
PRO
PRO Top sessoes ativas
PRO ------------------
SELECT s.con_id,
       s.sid||','||s.serial# AS sid_serial,
       s.username,
       s.machine,
       CASE WHEN s.state = 'WAITING' THEN s.event ELSE 'ON CPU' END AS curr_event,
       s.sql_id,
       ROUND(s.last_call_et) AS secs
  FROM v$session s
 WHERE s.status = 'ACTIVE'
   AND s.type = 'USER'
 ORDER BY s.last_call_et DESC
 FETCH FIRST &&oratop_top. ROWS ONLY
/

-- == Secao 5: Top SQL por atividade no ASH (ultimos &&oratop_secs.s) ===========
COL sql_id   FOR A14   HEA 'SQL_ID'
COL samples  FOR 999990 HEA 'Amostras'
COL aas      FOR 990.00 HEA 'AAS'
COL sql_text FOR A90    HEA 'SQL Text' TRUNC
PRO
PRO Top SQL por atividade (ASH, ultimos &&oratop_secs.s)
PRO ---------------------------------------------------
SELECT * FROM (
  SELECT h.sql_id,
         COUNT(*) AS samples,
         ROUND(COUNT(*) / &&oratop_secs., 2) AS aas,
         (SELECT q.sql_text FROM v$sql q WHERE q.sql_id = h.sql_id AND ROWNUM = 1) AS sql_text
    FROM v$active_session_history h
   WHERE h.sample_time > SYSTIMESTAMP - NUMTODSINTERVAL(&&oratop_secs., 'SECOND')
     AND h.sql_id IS NOT NULL
   GROUP BY h.sql_id
   ORDER BY samples DESC
) WHERE ROWNUM <= &&oratop_top.
/
PRO
PRO (fim do snapshot - re-execute para atualizar)

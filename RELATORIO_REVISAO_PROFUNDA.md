# Relatório de Revisão Profunda — cscripts (segurança, bugs, compat 19c×26ai)

**Data:** 2026-06-27
**Escopo:** re-auditoria estática linha-a-linha de 62 scripts de maior risco
(os que usam `HOST`/`!`, `EXECUTE IMMEDIATE`, geração+execução de scripts e/ou
`SPOOL`), além da revisão anterior. Complementa `RELATORIO_SEGURANCA.md`.
**Método:** análise estática (sem banco). A validação em banco real fica a cargo
do harness em `local/` (containers 19c + 26ai).

> Correções **aplicadas** nas pastas `19c/` e `26ai/`: typo de hint
> `MATERIALIZWE`/`MATERIALIE` → `MATERIALIZE` (confirmado em `cs_def.sql` e
> `cs_sess_mon.sql`) e `chmod 644 → 600` nos arquivos de **trace** crus. Os
> demais itens abaixo são de natureza estrutural (third-party) e estão como
> **recomendação**, para não quebrar o fluxo operacional da ferramenta.

---

## A. Achados de SEGURANÇA — Alta severidade

### A1. Arquivos previsíveis em `/tmp` que são **gerados e depois EXECUTADOS** como DBA
Padrão mais perigoso e sistêmico: o script grava um `.sql` em `/tmp` com nome
previsível (muitas vezes só o SID) e logo o executa via `@`/`@@`/`GET`. Em host
compartilhado, outro usuário pode **pré-criar/symlinkar** o arquivo (race) e
injetar SQL que roda com privilégio de DBA.
- `cs_internal/cs_def.sql` — `!who am i > /tmp/get_who_am_i.txt` + `get`; e
  `SPO /tmp/cs_default_reference.sql` + `@@/tmp/cs_default_reference.sql`.
- `cs_pr.sql` / `cs_internal/cs_pr_internal.sql` — `/tmp/*_pr_tmpfile_<sid>.sql` (executados).
- `cs_internal/cs_cursors_not_shared.sql` — `&&cs_file_dir.` (=`/tmp/`) `cursors_not_shared_dynamic.sql`.
- `cs_locks_mon.sql`, `cs_internal/cs_top_keys_sql.sql`,
  `cs_internal/cs_top_primary_keys_table.sql`, `cs_internal/cs_top_secondary_keys_table.sql`
  — `/tmp/cs_driver_<sid>.sql` gerado e executado.
- `cs_sqlmon_capture.sql`, `cs_dbms_stats_gather_database_stats_job.sql` — driver `.sql` gerado e executado.
- `reason_not_shared.sql` — `all_reasons.sql` no diretório corrente (relativo).

**Recomendação:** gerar artefatos em diretório privado `0700` (ex.: `$HOME/cs_tmp/`)
com nome incluindo PID/aleatório; criar com `O_EXCL`; nunca executar `.sql` de
`/tmp` world-writable. O define `&&cs_file_dir.` já existe — apontá-lo para um
diretório seguro mitiga boa parte.

### A2. Injeção de shell em `HOST`/`HOS`/`!`
Variáveis interpoladas sem aspas/validação em comandos de SO:
- `ls.sql` (L5) — `HOST ls $ORATK_HOME/sql/cscripts/*&1.*` → `&1` e `$ORATK_HOME`
  sem aspas; valor com `;`/`$()` executa comando arbitrário.
- `cs_trace_session.sql` (L69/76/77) — `tkprof`/`chmod`/`cat &&trace_filename.` sem aspas.
- `cs_dbms_stats_operations.sql` (L73), `cs_sqlmon_capture.sql`/`_hist`/`_mem` — `HOS chmod`/`zip` com `&&cs_file_name.` sem sanitização.

**Recomendação:** citar todos os argumentos (`"$VAR"`), validar nomes (allowlist
`[A-Za-z0-9._-]`), evitar `HOST` com entrada do usuário.

### A3. Injeção de SQL em `EXECUTE IMMEDIATE` (concatenação)
- `cs_estimate_table_size.sql` (L62) — `EXPLAIN PLAN FOR CREATE TABLE
  &&schema_name..&&table_name._ AS SELECT...` com variáveis interativas em DDL dinâmico.
- `cs_estimate_index_size.sql` (L46) — `&&index_name.`/`&&schema_name.` em DDL.
- `cs_sprf_export.sql` (L253) — `bucket_name` derivado de `sql_fulltext` (não confiável) concatenado **sem bind** no script `_IMPLEMENT` gerado.
- `cs_spch_scan_create.sql` (L143/151) — `kiev_table_name` extraído de `sql_text` injetado em PL/SQL gerado e executado.
- `cs_tables_rows_vs_count.sql` / `_outliers.sql` (L11/13), `cs_redef_table*_OLD.sql` — `owner`/`table_name` concatenados (citados com `"`, mas sem `DBMS_ASSERT`).

**Recomendação:** `DBMS_ASSERT.ENQUOTE_NAME`/`SQL_OBJECT_NAME`/`SIMPLE_SQL_NAME`
para identificadores; **bind variables** (`USING`) para valores; validar `sql_id`
com `REGEXP_LIKE('^[0-9a-z]{13}$')` antes de usar em filtros/nomes de arquivo.

### A4. Permissões frouxas (`chmod 644`) em artefatos sensíveis
Traces e relatórios de SQL Monitor podem conter **binds e SQL da aplicação**.
- **CORRIGIDO (→600)** nos traces crus: `cs_trace_session.sql`, `trace_*_sql_id.sql`,
  `trace_*_mysid_off.sql`, `cs_LGWR_trc.sql`, `cs_CKPT_trc.sql`.
- **Recomendado (mantido 644)**: `cs_sqlmon_capture/hist/mem.sql`, `cs_sprf_export.sql`,
  `cs_dbms_stats_*` — são entregáveis para transferência; avaliar `600` em host multiusuário.

---

## B. Achados de SEGURANÇA — Média/Baixa
- `SPO /tmp/<script>_<timestamp>.txt` (sem execução) em ~dezenas de scripts de
  métricas/load (`cs_*_sysmetric_*`, `cs_load_*`): info-disclosure/symlink. Usar `cs_temp_dir`/`600`.
- Geração de literais `q'[...]'` que quebram se o conteúdo contiver `]'`
  (`cs_sprf_xfr.sql`, `cs_spch_xfr.sql`, `cs_def.sql` bloco `who_am_i`,
  `cs_sqlmon_capture.sql` hint_text): escolher delimitador dinâmico (como o
  `coe_xfr_sql_profile.sql` já faz) ou rejeitar `]'`.
- `cs_spool_head_chart.sql` — HTML sem escape dos valores (XSS local se aberto no navegador).

---

## C. BUGS (não relacionados a versão)
- **`planx.sql` (≈L819/944/1083):** três blocos "31 days" têm um `/` solto sem SQL
  no buffer → re-executa a query anterior (relatório de 31 dias **incorreto/duplicado**).
- `MATERIALIZWE`/`MATERIALIE` → `MATERIALIZE` — **CORRIGIDO**.
- `cs_estimate_index_size.sql`/`cs_estimate_table_size.sql` — `SELECT owner INTO ...
  WHERE table/index_name = ...` sem owner ⇒ **ORA-01422** se existir em vários schemas. Usar `MAX`/`FETCH FIRST 1` ou pedir owner.
- Família `cs_kill_*` — `IF coll.LAST >= coll.FIRST` em coleção possivelmente vazia;
  usar `IF coll.COUNT > 0`. Também: `ALTER SYSTEM DISCONNECT SESSION` em massa **sem confirmação** (risco operacional).
- Scripts de sysmetric/load — `WHERE ... AND ROWNUM = 1` junto de `MAX(...)`
  (agregado): predicado redundante/enganoso; remover `ROWNUM=1`.
- `instance_number = SYS_CONTEXT('USERENV','INSTANCE')` (VARCHAR↔NUMBER) — usar `TO_NUMBER(...)`.
- `cs_trace_session.sql` — match por `LIKE '%sid,serial%'` casa parcialmente (ex.: `1,2` em `11,23`); usar igualdade exata.
- `coe_xfr_sql_profile.sql` (≈L401) — última "peça" do CLOB usa `l_pos` em vez de `l_offset` no cálculo do tamanho.
- `fk_indexes.sql` — variáveis `VARCHAR2(30)` para owner/table/column (12.2+ permite 128) ⇒ truncamento/`VALUE_ERROR`; padronizar `VARCHAR2(128)`.

---

## D. Compatibilidade 19c → 26ai (verificar em banco real via harness)
- **Parâmetros ocultos** em hints `OPT_PARAM`/`ALTER SESSION|SYSTEM` — podem não
  existir ou mudar de semântica em 26ai (23ai):
  `_px_cdb_view_enabled`, `_fix_control 5922070`, `_optimizer_adaptive_cursor_sharing`
  e `_optimizer_extended_cursor_sharing*` (`cs_acs_enable/disable.sql`),
  `_kdlxp_lobcompress/_lobcmplevel/_lobdeduplicate` (`cs_redef_table*_OLD.sql`).
  Tornar condicional por versão e validar o `_fix_control` no destino.
- **XML depreciado:** `EXTRACTVALUE`/`XMLSEQUENCE` (`coe_xfr_sql_profile.sql`,
  `cs_spch_xfr.sql`) — migrar para `XMLTABLE`/`XMLQUERY` (já feito em `cs_sprf_export.sql`).
- **API de SQL Patch:** `DBMS_SQLDIAG_INTERNAL.i_create_patch` (12c) vs
  `DBMS_SQLDIAG.create_sql_patch` — assinatura mudou; testar em 26ai
  (`cs_sqlmon_capture.sql`, `cs_spbl_evolve_internal.sql`, `cs_spch_*`).
- **`GATHER_DATABASE_STATS_JOB_PROC`** (interno/não documentado) — preferir
  `DBMS_STATS.GATHER_DATABASE_STATS(options=>'GATHER AUTO')`.
- **`con_id <> 2`** para excluir PDB$SEED — frágil; usar `name <> 'PDB$SEED'`.
- **non-CDB desuportado em 26ai** — scripts já assumem CDB/PDB (compatível).
- Nomes de métricas/`group_id` de `v$sysmetric`/`v$con_sysmetric` podem expandir
  em 26ai — validar no harness.

---

## E. Itens obsoletos
`cs_redef_table_OLD.sql` e `cs_redef_table_no_dedup_OLD.sql`: DDL destrutivo de
redefinição com parâmetros ocultos `_kdlxp_*` e áreas de PGA de ~2,1 GB
(`HASH/SORT_AREA_SIZE` com `WORKAREA_SIZE_POLICY=MANUAL`). **Não usar**; preferir
as versões atuais. Mantidos só para referência.

---

## F. Verificação dos SET de visualização (SQL*Plus)
- **Integridade:** comparando cada arquivo das pastas novas com o original, só
  diferem (além do cabeçalho) os **12 arquivos editados de propósito** (chmod 600,
  `MATERIALIZE`, nota de versão). Nenhum `SET`/`COL`/formatação foi corrompido.
- **Arquitetura:** a configuração de exibição é **centralizada** em `set.sql` e
  `cs_internal/cs_set.sql` (`LIN 2490 PAGES 100 TRIMS ON FEED OFF ...` + formatos
  NLS). 220 scripts puxam essa cadeia; 77 definem `SET LIN` inline. Os fragmentos
  `cs_internal/*` **herdam** o SET do script-pai via `@@` (correto por design).
- **Compat de versão:** os comandos `SET` do SQL*Plus/SQLcl são **idênticos** em
  19c e 26ai — não há (nem faz sentido) ajuste de visualização por versão; por isso
  `set.sql`/`cs_set.sql` são byte-a-byte iguais nas duas pastas.
- **Ajuste aplicado:** 3 scripts de raiz que rodam standalone e produziam relatório
  sem definir `LINESIZE/PAGESIZE` (`cs_dg.sql`,
  `cs_opened_cursors_current_per_session.sql`, `cs_spbl_sprf_spch_cnt.sql`) receberam
  a linha padrão `SET LIN 2490 PAGES 100 TRIMS ON TAB OFF FEED OFF HEA ON;` nas duas
  pastas, para não herdarem o default `LIN 80` ao serem executados diretamente.

## G. Como validar em banco real
Use o lab em [`local/`](local/README.md): sobe 19c (emulado) + 26ai (nativo arm64),
aplica os stubs de ambiente interno, roda `00_env_check.sql` e um smoke read-only,
e compara os erros `ORA-/SP2-/PLS-` entre as duas versões. Foque a validação de
compat (seção D) nos logs de `local/reports/`.

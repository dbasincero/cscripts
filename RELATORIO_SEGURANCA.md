# Relatório de Segurança, Bugs e Compatibilidade de Versão — cscripts

**Data:** 2026-06-26
**Escopo:** 508 scripts SQL (família *cscripts*, diagnóstico Oracle DBA), analisados estaticamente.
**Método:** análise estática de código (o container não possui banco Oracle para execução real).
**Entregáveis:** pastas `19c/` e `26ai/` com todos os scripts copiados, ajustados, com cabeçalho de uso em português, e correções aplicadas.

---

## 1. Modelo de ameaça

Estes scripts são executados **interativamente por um DBA** (privilégios elevados) via SQL\*Plus/SQLcl.
As variáveis (`&&cs_sql_id.`, `&1`, etc.) são fornecidas pelo próprio operador. Portanto a maior
parte dos riscos é **local** (host compartilhado / multiusuário) ou de **qualidade/robustez**, e não
exposição remota. Ainda assim, padrões de injeção e arquivos previsíveis em `/tmp` são relevantes em
ambientes com mais de um usuário de SO no servidor de banco.

---

## 2. Resumo dos achados

| # | Tipo | Severidade | Itens | Situação |
|---|------|-----------|-------|----------|
| 1 | Bug — hint mal escrito (`MATERIALIZWE`/`MATERIALIE`) | Média (performance) | 2 arquivos | **CORRIGIDO** nas duas pastas |
| 2 | Segurança — `chmod 644` em arquivos de **trace** (contêm valores de bind) | Média | 10 arquivos de trace | **CORRIGIDO** (→ `600`) nas duas pastas |
| 3 | Segurança — caminhos previsíveis em `/tmp` (race/symlink/info-disclosure) | Média | 40 arquivos | Documentado + recomendação |
| 4 | Segurança — injeção via variável de substituição em SQL dinâmico (`EXECUTE IMMEDIATE`) | Baixa–Média | 20 arquivos | Documentado + recomendação |
| 5 | Segurança — variáveis interpoladas em comandos `HOST`/`!` (injeção de shell) | Baixa–Média | ~105 ocorrências | Documentado + recomendação |
| 6 | Segurança — `!rm`/`HOST rm` com caminho relativo/fixo | Baixa | 5 arquivos | Documentado + recomendação |
| 7 | Qualidade — scripts obsoletos `*_OLD.sql` com DDL destrutivo | Baixa | 2 arquivos | Documentado (mantidos) |
| 8 | Info — `&&cs_sql_id.` e afins embutidos em literais SQL | Baixa | 104 arquivos | Documentado |

---

## 3. Correções aplicadas (nas pastas `19c/` e `26ai/`)

### 3.1 Bug de performance — hint `MATERIALIZE` mal grafado
- `cs_internal/cs_def.sql`: `/*+ MATERIALIZWE NO_MERGE ... */` → `/*+ MATERIALIZE NO_MERGE ... */`
- `cs_sess_mon.sql`: 5 ocorrências de `/*+ MATERIALIE NO_MERGE */` → `/*+ MATERIALIZE NO_MERGE */`

O otimizador **ignora silenciosamente** hints com nome inválido. Com o nome correto, a CTE é
materializada como o autor pretendia, evitando reavaliações repetidas da subconsulta.

### 3.2 Permissão de arquivos de trace — `644` → `600`
Arquivos de trace brutos podem conter **valores de bind e dados de aplicação sensíveis**. Tê-los
world-readable (`644`) expõe esses dados a qualquer usuário de SO no servidor. Alterado para `600`
(somente o dono `oracle`, que é quem executa os scripts, lê o arquivo — `cat`/`tkprof` continuam
funcionando) nos seguintes arquivos: `trace_10046_sql_id.sql`, `trace_10053_sql_id.sql`,
`trace_10046_mysid_off.sql`, `trace_10053_mysid_off.sql`, `trace_10046_10053_mysid_off.sql`,
`trace_SPM_sql_id.sql`, `trace_DUMP_sql_id.sql`, `cs_trace_session.sql`, `cs_LGWR_trc.sql`,
`cs_CKPT_trc.sql`.

> Relatórios "entregáveis" (`*.sql`, `*.txt`, `*.html`, `*.zip` de AWR/SQL Monitor) foram **mantidos
> em `644`** de propósito, pois costumam ser transferidos/compartilhados. Veja recomendação em 4.1.

---

## 4. Achados documentados (recomendações, não auto-alterados)

> Optou-se por **não** reescrever estes pontos automaticamente para não quebrar o fluxo operacional
> de uma ferramenta de terceiros. Seguem as remediações recomendadas.

### 4.1 Caminhos previsíveis em `/tmp` (40 arquivos)
Ex.: `/tmp/get_who_am_i.txt`, `/tmp/cs_pr_*.sql`, `/tmp/cs_default_reference.sql`, `/tmp/SQL_ID_<id>/...`.
Em host compartilhado, outro usuário pode **pré-criar um symlink** no caminho (ataque de symlink) ou
**ler** a saída. Risco: corrupção/escrita arbitrária e vazamento de informação.
**Recomendação:** usar o define já existente `&&cs_file_dir.` apontando para um diretório por-usuário
com permissão `0700` (ex.: `$HOME/cs_tmp/`), e incluir o PID/timestamp no nome do arquivo.

### 4.2 Injeção em SQL dinâmico — `EXECUTE IMMEDIATE` (20 arquivos)
Ex.: `cs_estimate_index_size.sql` concatena `&&index_name.`/`&&schema_name.` direto na DDL passada a
`EXECUTE IMMEDIATE`. Como roda com privilégio de DBA, um valor malicioso poderia injetar SQL.
**Recomendação:** validar identificadores com `DBMS_ASSERT.SQL_OBJECT_NAME` /
`DBMS_ASSERT.ENQUOTE_NAME` antes de concatenar.

### 4.3 Injeção de shell em comandos `HOST`/`!` (~105 ocorrências)
Ex.: `cs_trace_session.sql` monta `tkprof`/`cat` com `&&trace_filename.`; `ls.sql` injeta `&1` em um
glob de shell. Metacaracteres no valor poderiam executar comandos arbitrários como o usuário `oracle`.
**Recomendação:** não interpolar variáveis não sanitizadas em comandos `HOST`; quando inevitável,
restringir os valores (whitelist) e citar adequadamente.

### 4.4 `!rm` / `HOST rm` com caminho relativo/fixo (5 arquivos)
Ex.: `reason_not_shared.sql` faz `!rm all_reasons.sql` no **diretório corrente** (apaga arquivo de
mesmo nome onde o DBA estiver). **Recomendação:** usar caminho absoluto sob diretório controlado e
`rm -f --` com caminho dentro de `&&cs_file_dir.`.

### 4.5 Scripts obsoletos `*_OLD.sql` (2 arquivos)
`cs_redef_table_OLD.sql` e `cs_redef_table_no_dedup_OLD.sql` contêm DDL de redefinição de tabela
(operações destrutivas). **Recomendação:** não utilizar; preferir as versões atuais. Mantidos para
referência histórica.

### 4.6 `&&cs_sql_id.` e afins embutidos em literais (104 arquivos)
Baixo risco (o `sql_id` segue formato restrito de 13 caracteres alfanuméricos), mas um valor com aspa
simples poderia romper o literal. **Recomendação:** validar formato do `sql_id`/`signature` antes do
uso, ou usar bind variables onde possível.

---

## 5. Compatibilidade 19c × 26ai

A grande maioria dos scripts é **agnóstica de versão**: já são multitenant-aware (usam `v$containers`,
`con_id`, `cdb_*`, `dba_hist_*`), e todas as views/funções empregadas existem nas duas versões.
Por isso **não houve necessidade de divergência funcional de código** entre as pastas; as diferenças
relevantes para um DBA estão anotadas em `cs_internal/cs_def.sql` de cada pasta:

- **19c:** espera `i.version_full` iniciando em `19.`. Arquitetura CDB **ou** non-CDB suportadas.
- **26ai:** espera `i.version_full` iniciando em `26.`. A arquitetura **non-CDB é desuportada** (linhagem
  23ai); como os scripts já assumem CDB/PDB, permanecem compatíveis. `version_full` e as views
  `V$/DBA_/CDB_` usadas seguem presentes.

**Itens para um DBA observar ao migrar 19c → 26ai** (verificar em banco real):
- Parâmetros ocultos (`_px_cdb_view_enabled`, `_fix_control`) usados em alguns hints podem ter
  comportamento/valor diferente; revisar caso a caso.
- Objetos de ambiente Oracle Cloud interno (`IOD`/`ODIS`, `dbc_*`, `kiev*`) não existem fora daquele
  ambiente — independem da versão, mas falharão se ausentes (os scripts já tratam parte disso via
  `cs_odis`).

---

## 6. Estrutura entregue

```
19c/        -> 508 scripts ajustados p/ Oracle 19c  (+ cs_internal/)
26ai/       -> 508 scripts ajustados p/ Oracle 26ai (+ cs_internal/)
```

Cada script recebeu, no topo, um **cabeçalho de uso em português** com: nome, versão alvo, descrição
de uso, atalhos conhecidos, variáveis esperadas, nota de segurança (quando aplicável) e pré-requisito
de privilégio. Os arquivos originais na raiz do repositório foram **preservados** como linha de base
do fork.

# Lab local — Oracle 19c + 26ai para validar os cscripts (Apple Silicon)

Sobe dois bancos Oracle locais no seu Mac (disco `FORD_2TB`) e roda os cscripts
contra ambos, comparando erros entre as versões.

> **Importante:** estes passos rodam **no seu Mac** — eu (assistente) rodo num
> container remoto e não tenho acesso ao seu disco/Docker. Este diretório é o
> "manual + automação" para você executar localmente.

## 0. Pré-requisitos
- **Docker Desktop** (com Rosetta ligado: *Settings → General → Use Rosetta for
  x86_64/amd64 emulation*) — necessário porque **19c não tem imagem ARM** e roda
  emulado. O 26ai roda nativo (arm64).
- Login na registry da Oracle p/ a imagem 19c EE:
  `docker login container-registry.oracle.com` (aceite os termos da imagem no site).
- O disco **`FORD_2TB` precisa ser APFS** (ou HFS+). **exFAT não funciona** para
  datafiles Oracle (sem permissões POSIX/symlinks).

## 1. Clonar o projeto no disco externo
```bash
mkdir -p /Volumes/FORD_2TB/cscripts-lab
cd /Volumes/FORD_2TB
git clone https://github.com/dbasincero/cscripts.git
cd cscripts/local
cp .env.example .env        # edite ORACLE_PWD, confira FORD_2TB e as tags das imagens
```

## 2. Subir os containers
```bash
mkdir -p "$(grep FORD_2TB .env | cut -d= -f2)"/oradata-19c
mkdir -p "$(grep FORD_2TB .env | cut -d= -f2)"/oradata-26ai
docker compose up -d
docker compose ps
# acompanhe a 1a inicialização (19c emulado é LENTO, pode levar 15-30 min):
docker compose logs -f ora19c
docker compose logs -f ora26ai
```
Espere ambos ficarem `healthy`.

## 3. Rodar a revisão (stubs + env-check + execução)
```bash
./harness/run_review.sh            # PADRAO: roda TODA a lista (~225 read-only)
./harness/run_review.sh --smoke    # conjunto representativo (10 scripts)
./harness/run_review.sh --stubs    # só (re)criar os stubs internos
```
Saídas em `local/reports/`:
- `ora19c__env_check.log` / `ora26ai__env_check.log` — versão, CDB, views, stubs.
- `oraXX__<script>.log` — saída de cada script; contagem de `ORA-/SP2-/PLS-`.
- **`SUMARIO_ORA.md`** — sumário + **diff 19c × 26ai** (gerado automaticamente no
  fim do `run_review.sh`).

### Sumário/diff de erros (gerado automático, ou avulso)
O `run_review.sh` já chama o sumarizador no fim. Para rodar avulso sobre logs
existentes:
```bash
./harness/summarize_errors.sh reports      # gera reports/SUMARIO_ORA.md
```
O `SUMARIO_ORA.md` traz: totais por versão, top códigos, e o **diff** —
códigos **só no 26ai** (regressões potenciais ao migrar), **só no 19c**, comuns
(lado a lado), e scripts que erraram em só uma versão.

### Como me mandar os logs depois
Rode no Mac e cole aqui **o conteúdo de `reports/SUMARIO_ORA.md`** (ou empacote
os logs: `tar czf reports.tgz reports/`). Com isso eu analiso as diferenças
19c × 26ai e ataco os itens de compat com dados reais.

## Sobre os stubs (`stubs/hf_internal_stubs.sql`)
Os cscripts foram feitos para a **frota interna Oracle Cloud** e o
`hf_internal/hf_def.sql` referencia objetos que **não existem** num banco limpo
(`IOD_META_AUX`, `PDB_CONFIG`, `dbc_system`, `dbc_rsrcmgrmetric_history`,
`dbc_pdb_metadata_v`). O stub cria versões mínimas (retornos fixos) no usuário
comum `C##IOD` para o `cs_def` completar. Objetos `kiev*`/`zapper*` são opcionais
(o `hf_def` os protege com checagens de existência) e não são stubados.

## Limitações conhecidas
- O **smoke é best-effort**: muitos scripts são interativos (pedem `sql_id`, faixas
  de tempo etc.). O wrapper pré-define as variáveis mais comuns, mas alguns ainda
  podem pedir entrada ou falhar por falta de dados (AWR vazio em banco novo). Gere
  carga/AWR antes para cobertura melhor.
- **Nunca** rodamos scripts destrutivos no smoke (kill/redef/drop/expdp/patches):
  a lista `autonomous_scripts.txt` é curada só com read-only.
- 26ai vs 23ai: confirme em `container-registry.oracle.com` a tag/arquitetura
  disponível; se não houver imagem 26ai arm64, use a 23ai Free como proxy e ajuste
  `IMG_26AI` no `.env`.

--==========================================================================
-- Script    : hf_latency_internal_foot.sql
-- Versao    : Oracle Database 26ai (26.x)
-- Uso       : Script auxiliar interno, invocado por outros scripts via @@
--             (não chamado diretamente).
-- Pre-req    : conexao com privilegio de DBA (acessa views V$/DBA_/CDB_).
--==========================================================================
PRO
PRO 1. Top &&cs_top_latency. active SQL per SQL Type as per DB Latency (iff DB AAS > &&cs_aas_threshold_latency.) UNION Top &&cs_top_load. active SQL per SQL Type as per DB Load (iff DB AAS > &&cs_aas_threshold_load.) ordered by DB Latency descending.
PRO 2. Includes only SQL with DB Latency > &&cs_ms_threshold_latency. milliseconds per execution, and which has been active recently.
PRO 3. For an extended output use le.sql (hf_latency_extended.sql). For a reduced output use l.sql (hf_latency.sql). For a reduced output without a report heading use la.sql.
PRO 4. For a time range use lr.sql (hf_latency_range.sql) OR lre.sql (hf_latency_range_extended.sql), both from AWR (15m granularity); or hf_latency_range_iod.sql and hf_latency_range_iod_extended.sql, both from IOD table (1m granularity).
PRO 5. For the last 1 minute use hf_latency_1m.sql OR hf_latency_1m_extended.sql.
PRO 6. For an interval of N seconds use hf_latency_snapshot.sql or hf_latency_snapshot_extended.sql.
PRO 
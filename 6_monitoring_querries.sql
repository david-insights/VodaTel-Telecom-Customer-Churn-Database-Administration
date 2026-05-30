-- 1. Table sizes (Check disk usage)
SELECT 
    relname AS table_name,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
    pg_size_pretty(pg_relation_size(relid)) AS data_size,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS index_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;
--Physical disk space used by each table (data + indexes)
--Plan storage, identify large tables for partitioning, avoid disk full



--2. Index usage statistics (Find unused indexes)
SELECT 
    i.schemaname,
    c.relname AS tablename,
    i.indexrelname AS indexname,
    i.idx_scan AS number_of_scans,
    pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size
FROM pg_stat_user_indexes i
JOIN pg_class c ON i.relid = c.oid
ORDER BY i.idx_scan ASC;
--How often each index is used
--Find unused indexes (waste space) and missing indexes



-- 3. Long-running queries (Detect slow queries)
SELECT 
    pid,
    now() - query_start AS duration,
    state,
    query
FROM pg_stat_activity
WHERE state != 'idle' 
  AND (now() - query_start) > interval '1 minute'
ORDER BY duration DESC;
--Queries that have been running longer than 1 minute
--Identify performance bottlenecks, kill stuck queries
--If no queries are running long, the result set is empty, means no stuck queries.



-- 4. Table bloat estimate (Monitor vacuum needs)
SELECT 
    schemaname,
    relname AS tablename,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows,
    ROUND(n_dead_tup * 100.0 / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS dead_row_percent
FROM pg_stat_user_tables
WHERE n_dead_tup > 1000
ORDER BY dead_row_percent DESC;
--Schedule VACUUM to reclaim space and prevent performance degradation
--Percentage of "dead" rows (updated/deleted but not vacuumed)



-- 5. Connection count by state (Check connection health)
SELECT state, COUNT(*) FROM pg_stat_activity GROUP BY state;
--How many database connections are idle, active, waiting, etc
--Monitor connection pool, detect application leaks



-- 6. Cache hit ratio (Assess cache efficiency))
SELECT 
    round(SUM(heap_blks_hit) * 100.0 / NULLIF(SUM(heap_blks_hit + heap_blks_read), 0), 2) AS cache_hit_ratio
FROM pg_statio_user_tables;
--Percentage of data reads served from RAM (cache) vs disk
--Low cache hit (<99%) means more RAM needed or poor query patterns
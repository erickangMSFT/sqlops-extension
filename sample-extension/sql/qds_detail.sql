WITH SlowestQry AS( 
    SELECT TOP 5  
        q.query_id, 
        MAX(rs.max_duration ) max_duration 
    FROM sys.query_store_query_text AS qt    
    JOIN sys.query_store_query AS q    
        ON qt.query_text_id = q.query_text_id    
    JOIN sys.query_store_plan AS p    
        ON q.query_id = p.query_id    
    JOIN sys.query_store_runtime_stats AS rs    
        ON p.plan_id = rs.plan_id   
    WHERE rs.last_execution_time > DATEADD(week, -1, GETUTCDATE())   
    AND is_internal_query = 0 
    GROUP BY q.query_id 
    ORDER BY MAX(rs.max_duration ) DESC) 
SELECT  
    q.query_id,  -- legend 
    format(rs.last_execution_time,'yyyy-MM-dd hh:mm:ss') as [last_execution_time],   -- x axis 
    rs.max_duration,  -- y axis
    p.plan_id ,
    qt.query_sql_text,
    p.query_plan
FROM SlowestQry tq  
    join sys.query_store_query as q
    on tq.query_id = q.query_id 
    JOIN sys.query_store_query_text AS qt    
        ON qt.query_text_id = q.query_text_id    
    JOIN sys.query_store_plan AS p    
        ON q.query_id = p.query_id    
    JOIN sys.query_store_runtime_stats AS rs    
        ON p.plan_id = rs.plan_id   
WHERE rs.last_execution_time > DATEADD(week, -1, GETUTCDATE())   
AND is_internal_query = 0 
order by q.query_id, rs.max_duration desc--format(rs.last_execution_time,'yyyy-MM-dd hh:mm:ss')




-- SELECT
--     Qry.query_id,
--     Pl.plan_id,
--     Txt.query_sql_text,
--     pl.query_plan,  
--     Qry.initial_compile_start_time,
--     Qry.last_compile_start_time,
--     Qry.last_execution_time,
--     Qry.count_compiles,
--     Qry.avg_compile_duration,
--     Qry.last_compile_duration,
--     Qry.avg_bind_duration,
--     Qry.last_bind_duration,
--     Qry.avg_bind_cpu_time,
--     Qry.last_bind_cpu_time,
--     Qry.avg_optimize_duration,
--     Qry.last_optimize_duration,
--     Qry.avg_optimize_cpu_time,
--     Qry.last_optimize_cpu_time,
--     Qry.avg_compile_memory_kb,
--     Qry.last_compile_memory_kb,
--     Qry.max_compile_memory_kb

-- FROM sys.query_store_plan AS Pl  
-- JOIN sys.query_store_query AS Qry  
--     ON Pl.query_id = Qry.query_id  
-- JOIN sys.query_store_query_text AS Txt  
--     ON Qry.query_text_id = Txt.query_text_id

SELECT end_time, -- x axis   
  (SELECT Max(v)     
   FROM (VALUES (avg_cpu_percent), (avg_data_io_percent), (avg_log_write_percent)) AS     
   value(v)) AS [avg_DTU_percent] -- y axis   
FROM sys.dm_db_resource_stats 
order by 2 desc;   
DECLARE @TablesWithMissingPK INT = ( 
    SELECT COUNT(1) 
    FROM SYS.TABLES T 
    WHERE NOT EXISTS (SELECT * 
                    FROM SYS.indexes i 
                    WHERE i.object_id = t.object_id 
                    AND i.is_primary_key = 1) 
    AND t.type = 'U' 
    AND t.temporal_type = 0 
    ); 
 
 
DECLARE @TablesWithMissingIndexes INT = 0; 
DECLARE @MissingIndexes INT = 0; 
 
SELECT
@TablesWithMissingIndexes = COUNT(DISTINCT dm_mid.OBJECT_ID), 
@MissingIndexes = COUNT(1)  
FROM sys.dm_db_missing_index_groups dm_mig 
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs 
ON dm_migs.group_handle = dm_mig.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details dm_mid 
ON dm_mig.index_handle = dm_mid.index_handle 
WHERE dm_mid.database_ID = DB_ID() 
GROUP BY  dm_mid.database_id  
 
SELECT  
    @TablesWithMissingIndexes AS [Tables with Missing Indexes], 
    @MissingIndexes AS [Number of Missing Indexes], 
    @TablesWithMissingPK AS [Tables with Missing Primary Keys]; 
SELECT  
'Create Index' as Suggestion, 
OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName], 
'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_' 
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','')  
+ CASE 
WHEN dm_mid.equality_columns IS NOT NULL 
AND dm_mid.inequality_columns IS NOT NULL THEN '_' 
ELSE '' 
END 
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','') 
+ ']' 
+ ' ON ' + dm_mid.statement 
+ ' (' + ISNULL (dm_mid.equality_columns,'') 
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns  
IS NOT NULL THEN ',' ELSE 
'' END 
+ ISNULL (dm_mid.inequality_columns, '') 
+ ')' 
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement 
FROM sys.dm_db_missing_index_groups dm_mig 
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs 
ON dm_migs.group_handle = dm_mig.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details dm_mid 
ON dm_mig.index_handle = dm_mid.index_handle 
UNION ALL 
SELECT  
'Create Primary Keys' as Suggestion, 
t.name, 
NULL  
FROM SYS.TABLES T 
   WHERE NOT EXISTS (SELECT * 
                    FROM SYS.indexes i 
                    WHERE i.object_id = t.object_id 
                    AND i.is_primary_key = 1) 
    AND t.type = 'U' 
    AND t.temporal_type = 0 
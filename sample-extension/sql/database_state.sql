SELECT 
ONLINE, 
RECOVERY_PENDING 
FROM    
(SELECT state_desc, database_id 
FROM sys.databases ) p   
PIVOT   
(   
COUNT (database_id)   
FOR state_desc IN   
( ONLINE, RECOVERY_PENDING) 
) AS pvt
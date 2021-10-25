﻿
CREATE PROCEDURE [amd].[sp_ACE_ETL_Open_Audit_Header](
    @AuditID INT output
	, @packageName VARCHAR(200) = 'No package Name Provided'
	, @ActionStartTime DATETIME2 
	, @InputSourceName VARCHAR(200) = 'No Input Source Name Provided'	
	, @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	, @ErrorName VARCHAR(200) = 'No Error Name Provided'	
	)
AS 
    DECLARE @AuditStatus tinyInt = 1; -- Open value

    INSERT INTO [amd].[ACE_ETL_Audit_Header]
           ([EtlAudit_Status]
           ,[PackageName]
           ,[ActionStartTime]           
           ,[InputSourceName]           
           ,[DestinationName]           
           ,[ErrorDestinationName]           
           )
     VALUES
           (@AuditStatus
           ,@packageName
           ,@ActionStartTime           
           ,@InputSourceName
           ,@DestinationName           
           ,@ErrorName           
           );
    
    SELECT @AuditID = @@IDENTITY;
  
    IF @AuditID IS NULL
    BEGIN
	   RAISERROR ('Audit log entry open audit failed.',16, 1); 
    END

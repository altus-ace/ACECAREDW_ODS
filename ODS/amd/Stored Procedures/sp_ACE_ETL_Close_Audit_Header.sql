
CREATE PROCEDURE [amd].[sp_ACE_ETL_Close_Audit_Header]
	@audit_id int
    , @ActionStopTime DATETIME 
    , @SourceCount int = 0
    , @DestinationCount int = 0
    , @ErrorCount int = 0    
AS
BEGIN
    IF @audit_id IS NULL or @audit_id < 0
    BEGIN
	   
	   INSERT INTO [amd].[AceEtlAuditLogErrorLog] (ParamValues) 
		  VALUES ('Audit_id: '		+ ISNULL(CONVERT(VARCHAR(25), @audit_id), 'NULL') + 
			 ' ActionStopTime: '	+ ISNULL(CONVERT(VARCHAR(25), @actionStopTime), 'NULL') + 
			 ' SourceCount: '		+ ISNULL(CONVERT(VARCHAR(10), @sourceCount) , 'NULL')+ 
			 ' DestinationCount: '	+ ISNULL(convert(VARCHAR(10), @DestinationCount), 'NULL') +
			 ' ErrorCount: '		+ ISNULL(Convert(VARCHAR(10), @ErrorCount), 'NULL'));

	   RAISERROR ('This procedure must be passed an AuditID',16, 1);
	   RETURN;

    END

    UPDATE amd.ACE_ETL_Audit_Header
	   set ActionStopTime = @ActionStopTime
	   , InputCount = @SourceCount
	   , DestinationCount = @DestinationCount
	   , ErrorCount = @ErrorCount    
    where [EtlAuditHeader_Pkey] = @audit_id;

END


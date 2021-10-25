CREATE PROCEDURE [adw].[Load_Pdw_MbrActivities_ToShcnMssp_FromAceCare]
-- @Count INT OUTPUT
AS
BEGIN    
    
    /* 2 Log FACT LOAD */        
    DECLARE @AuditID INT ;    
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	   -- 1 adi load, 2 dw load????
    DECLARE @ClientKey INT	=   16 -- SHCN_MSSP
    DECLARE @JobName VARCHAR(200) = OBJECT_NAME(@@PROCID)  -- if it is the procedure name
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = 'ACECAREDW.dbo.tmp_AHS_PatientActivities'
    DECLARE @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	   SELECT @DestinationName = DB_NAME() + '.adw.[MbrActivities]';    
    DECLARE @ErrorName VARCHAR(200) = 'No Error Name Provided';
    DECLARE @SourceCount int;     
    DECLARE @DestinationCount int;	     
    DECLARE @ErrorCount int = 0
    /* close load Staging Log record */    
    DECLARE @ActionStopTime DATETIME;

    Declare @Output table (ID INT PRIMARY KEY NOT NULL) ;
    
    SELECT @SourceCount	  = COUNT(*) 
	   FROM dbo.tmp_AHS_PatientActivities APA
		  JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
	   WHERE LoadDate = CONVERT(DATE, GETDATE());
 
    /* 3 update old records setting the RowExpirationdate  */      
    -- add error handling 
    BEGIN TRY      
    BEGIN TRAN LoadMbrActivities
  --  TRUNCATE table ACDW_CLMS_SHCN_MSSP.[adw].[MbrActivities]; -- Remove By byu
    /* XXXXXXXXXX Move Activities to SHCN_MSSP catelog XXXXXXXX*/
    INSERT INTO ACDW_CLMS_SHCN_MSSP.[adw].[MbrActivities]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[ActivitySource]
           ,[CareActivityTypeName]
           ,[ActivityOutcome]
           ,[ActivityPerformedDate]
           ,[ActivityCreatedDate]
           ,[OutcomeNotes]
           ,[VenueName]
           ,[srcFileName]
           ,[LoadDate] )
    OUTPUT inserted.MbrActivityKey INTO @Output(ID)
    SELECT 
              APA.ClientMemberKey, 
		    Client.ClientKey,
		    'AHS' ActivitySource,
              APA.CareActivityTypeName, 
              APA.ActivityOutcome, 
              APA.ActivityPerformedDate, 
              APA.ActivityCreatedDate, 
              APA.OutcomeNotes, 
              APA.VenueName,               
              APA.srcFileName, 
              APA.LoadDate              
    FROM dbo.tmp_AHS_PatientActivities APA
	   JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE Client.ClientKey = 16
	AND		LoadDate = CONVERT(DATE, GETDATE());
    
    /* do not truncate, the APA.ShcnMsspLoadStatus  flag should handle loading only the new rows */
    --TRUNCATE table ACDW_CLMS_SHCN_MSSP.[adw].[MbrActivities]
    
    COMMIT TRAN LoadMbrActivities;
    END TRY
    BEGIN CATCH
	   EXECUTE [dbo].[usp_QM_Error_handler]
	   /* add logg update  */
    END CATCH
	/*  --Si asked to have it commented out
    UPDATE apa SET apa.ShcnMsspLoadStatus = 1
--    SELECT * 
    FROM dbo.tmp_AHS_PatientActivities APA 
    WHERE apa.ShcnMsspLoadStatus = 0 --and apa.LOB  = 'SHCN_MSSP';*/
    
END;


	/*2. Processing for BCBS*/
BEGIN
	BEGIN TRY      
    BEGIN TRAN LoadMbrActivitiesBCBS
	INSERT INTO ACDW_CLMS_SHCN_BCBS.[adw].[MbrActivities]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[ActivitySource]
           ,[CareActivityTypeName]
           ,[ActivityOutcome]
           ,[ActivityPerformedDate]
           ,[ActivityCreatedDate]
           ,[OutcomeNotes]
           ,[VenueName]
           ,[srcFileName]
           ,[LoadDate] )
    SELECT 
              APA.ClientMemberKey, 
		    Client.ClientKey,
		    'AHS' ActivitySource,
              APA.CareActivityTypeName, 
              APA.ActivityOutcome, 
              APA.ActivityPerformedDate, 
              APA.ActivityCreatedDate, 
              APA.OutcomeNotes, 
              APA.VenueName,               
              APA.srcFileName, 
              APA.LoadDate              
    FROM dbo.tmp_AHS_PatientActivities APA
	   JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE Client.ClientKey = 20
	AND		LoadDate = CONVERT(DATE, GETDATE());


	COMMIT TRAN LoadMbrActivitiesBCBS;
    END TRY
    BEGIN CATCH
	   EXECUTE [dbo].[usp_QM_Error_handler]
	  
    END CATCH
END


	/*3. Processing for UHC*/
BEGIN
	BEGIN TRY      
    BEGIN TRAN LoadMbrActivitiesUHC
	INSERT INTO ACDW_CLMS_UHC.[adw].[MbrActivities]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[ActivitySource]
           ,[CareActivityTypeName]
           ,[ActivityOutcome]
           ,[ActivityPerformedDate]
           ,[ActivityCreatedDate]
           ,[OutcomeNotes]
           ,[VenueName]
           ,[srcFileName]
           ,[LoadDate] )
    SELECT 
              APA.ClientMemberKey, 
		    Client.ClientKey,
		    'AHS' ActivitySource,
              APA.CareActivityTypeName, 
              APA.ActivityOutcome, 
              APA.ActivityPerformedDate, 
              APA.ActivityCreatedDate, 
              APA.OutcomeNotes, 
              APA.VenueName,               
              APA.srcFileName, 
              APA.LoadDate              
    FROM dbo.tmp_AHS_PatientActivities APA
	   JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE Client.ClientKey = 1
	AND		LoadDate = CONVERT(DATE, GETDATE());


	COMMIT TRAN LoadMbrActivitiesUHC;
    END TRY
    BEGIN CATCH
	   EXECUTE [dbo].[usp_QM_Error_handler]
	  
    END CATCH
END


	/*4. Processing for AMGTX_MA*/
BEGIN
	BEGIN TRY      
    BEGIN TRAN LoadMbrActivitiesAMGTX_MA
	INSERT INTO ACDW_CLMS_AMGTX_MA.[adw].[MbrActivities]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[ActivitySource]
           ,[CareActivityTypeName]
           ,[ActivityOutcome]
           ,[ActivityPerformedDate]
           ,[ActivityCreatedDate]
           ,[OutcomeNotes]
           ,[VenueName]
           ,[srcFileName]
           ,[LoadDate] )
    SELECT 
              APA.ClientMemberKey, 
		    Client.ClientKey,
		    'AHS' ActivitySource,
              APA.CareActivityTypeName, 
              APA.ActivityOutcome, 
              APA.ActivityPerformedDate, 
              APA.ActivityCreatedDate, 
              APA.OutcomeNotes, 
              APA.VenueName,               
              APA.srcFileName, 
              APA.LoadDate              
    FROM dbo.tmp_AHS_PatientActivities APA
	   JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE Client.ClientKey = 21
	AND		LoadDate = CONVERT(DATE, GETDATE());


	COMMIT TRAN LoadMbrActivitiesAMGTX_MA;
    END TRY
    BEGIN CATCH
	   EXECUTE [dbo].[usp_QM_Error_handler]
	   
    END CATCH
END

	/*5. Processing for AMGTX_MCD*/
BEGIN
	BEGIN TRY      
    BEGIN TRAN LoadMbrActivitiesAMGTX_MCD
	INSERT INTO ACDW_CLMS_AMGTX_MA.[adw].[MbrActivities]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[ActivitySource]
           ,[CareActivityTypeName]
           ,[ActivityOutcome]
           ,[ActivityPerformedDate]
           ,[ActivityCreatedDate]
           ,[OutcomeNotes]
           ,[VenueName]
           ,[srcFileName]
           ,[LoadDate] )
    SELECT 
              APA.ClientMemberKey, 
		    Client.ClientKey,
		    'AHS' ActivitySource,
              APA.CareActivityTypeName, 
              APA.ActivityOutcome, 
              APA.ActivityPerformedDate, 
              APA.ActivityCreatedDate, 
              APA.OutcomeNotes, 
              APA.VenueName,               
              APA.srcFileName, 
              APA.LoadDate              
    FROM dbo.tmp_AHS_PatientActivities APA
	   JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE Client.ClientKey = 22
	AND		LoadDate = CONVERT(DATE, GETDATE());


	COMMIT TRAN LoadMbrActivitiesAMGTX_MCD;
    END TRY
    BEGIN CATCH
	   EXECUTE [dbo].[usp_QM_Error_handler]
	  
    END CATCH
END

	/*6. Processing for Devoted*/
BEGIN
	BEGIN TRY      
    BEGIN TRAN LoadMbrActivitiesDHTX
	INSERT INTO ACDW_CLMS_DHTX.[adw].[MbrActivities]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[ActivitySource]
           ,[CareActivityTypeName]
           ,[ActivityOutcome]
           ,[ActivityPerformedDate]
           ,[ActivityCreatedDate]
           ,[OutcomeNotes]
           ,[VenueName]
           ,[srcFileName]
           ,[LoadDate] )
    SELECT 
              APA.ClientMemberKey, 
		    Client.ClientKey,
		    'AHS' ActivitySource,
              APA.CareActivityTypeName, 
              APA.ActivityOutcome, 
              APA.ActivityPerformedDate, 
              APA.ActivityCreatedDate, 
              APA.OutcomeNotes, 
              APA.VenueName,               
              APA.srcFileName, 
              APA.LoadDate              
    FROM dbo.tmp_AHS_PatientActivities APA
	   JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE Client.ClientKey = 11
	AND		LoadDate = CONVERT(DATE, GETDATE());


	COMMIT TRAN LoadMbrActivitiesDHTX;
    END TRY
    BEGIN CATCH
	   EXECUTE [dbo].[usp_QM_Error_handler]

    END CATCH
END


	/*7. Processing for Wlc*/
BEGIN
	BEGIN TRY      
    BEGIN TRAN LoadMbrActivitiesWlc
	INSERT INTO ACDW_CLMS_WLC.[adw].[MbrActivities]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[ActivitySource]
           ,[CareActivityTypeName]
           ,[ActivityOutcome]
           ,[ActivityPerformedDate]
           ,[ActivityCreatedDate]
           ,[OutcomeNotes]
           ,[VenueName]
           ,[srcFileName]
           ,[LoadDate] )
    SELECT 
              APA.ClientMemberKey, 
		    Client.ClientKey,
		    'AHS' ActivitySource,
              APA.CareActivityTypeName, 
              APA.ActivityOutcome, 
              APA.ActivityPerformedDate, 
              APA.ActivityCreatedDate, 
              APA.OutcomeNotes, 
              APA.VenueName,               
              APA.srcFileName, 
              APA.LoadDate              
    FROM dbo.tmp_AHS_PatientActivities APA
	   JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
    WHERE Client.ClientKey = 2
	AND		LoadDate = CONVERT(DATE, GETDATE());


	COMMIT TRAN LoadMbrActivitiesWlc;
    END TRY
    BEGIN CATCH
	   EXECUTE [dbo].[usp_QM_Error_handler]
	 
    END CATCH
END


---Keep updating with more clients

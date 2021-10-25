







CREATE PROCEDURE [ast].[PSTCopLoadToStg_AetMa] 
    @LoadDate DATE, @QMDate DATE
AS 
	/**/
    DECLARE @OutputTbl TABLE (ID INT);      
    DECLARE @ClientKey INT = 3 -- AETNAMA
    --DECLARE @LoadDate Date = CONVERT(date, GETDATE()) ;            
    /* Log Stag Load */        
      /* Log Export to adw */    
    DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt     ;
    DECLARE @JobStatus tinyInt = 1	;
    DECLARE @JobName VARCHAR(200) ;
    DECLARE @ActionStartTime DATETIME = getdate();
    DECLARE @ActionStopTime DATETIME = getdate()
    DECLARE @InputSourceName VARCHAR(200) = 'No Name given';	   
    DECLARE @DestinationName VARCHAR(200) = 'No Name given';	   
    DECLARE @ErrorName VARCHAR(200)	  = 'No Name given';	   
    DECLARE @SourceCount int = 0;         
    DECLARE @DestinationCount int = 0;    
    DECLARE @ErrorCount int = 0;    
        
    SET @JobType				 = 9	   -- 9 ast load    
    SET @JobName				 = 'PSTCopLoadToStg_AetMa'
    SELECT @InputSourceName		 = DB_NAME() +  'ast.vw_AetnaMaCareOpsUnpivotedFromAdi'    
    SELECT @DestinationName		 = DB_NAME() + '.ast.QM_ResultByMember_History';    
    SELECT @ErrorName			 = DB_NAME() + '.ast.QM_ResultByMember_History';    
    
    EXEC AceMetaData.amd.sp_AceEtlAudit_Open   
	        
	     @AuditID = @AuditID OUTPUT          
	   , @AuditStatus = @AuditStatus          
	   , @JobType = @JobType          
	   , @ClientKey = @ClientKey          
	   , @JobName = @JobName          
	   , @ActionStartTime = @ActionStartTime          
	   , @InputSourceName = @InputSourceName          
	   , @DestinationName = @DestinationName          
	   , @ErrorName = @ErrorName          ;                
--	   
    /* load to staging table insert set for Num and Cop */      
    BEGIN TRY      
	   BEGIN TRAN      
	   INSERT INTO [ast].[QM_ResultByMember_History]  
		  (		  
			 [astRowStatus]
			,[srcFileName]
			,[adiTableName]
			,[adiKey]
			,[LoadDate]			
			,[ClientKey]
			,[ClientMemberKey]
			,[QmMsrId]
			,[QMDate]
			,[QmCntCat]
			,srcQMID
		  )      
	   OUTPUT inserted.[pstQM_ResultByMbr_HistoryKey]  INTO @OutputTbl(ID)      
	   SELECT   
		   'Loaded'										as astRowStatus						--[astRowStatus]
		  ,cop.Sourcefilename							as srcFileName						--[srcFileName]
		  ,'ast.vw_AetnaMaCareOpsUnpivotedFromAdi'	    as adiTableName						--[adiTableName]
		  ,cop.skey										as adiKey							--[adiKey]
		  ,@LoadDate			 						as LoadDate							--[LoadDate]		
		  ,@ClientKey									as ClientKey						--[ClientKey]                  
		  ,cop.MemberID									as ClientMemberKey					--[ClientMemberKey]
		  ,cop.MeasureID									as QmMsrId						--[QmMsrId]
		  ,@QMDate										as Qmdate							--[QMDate]
		  ,cop.qmcomp									as QmCntCat							--[QmCntCat] 
		  ,cop.AceQmMsrId						AS srcQMID 
		 								  		  
	   FROM ast.vw_AetnaMaCareOpsUnpivotedFromAdi cop
	   -- where cop.LoadtoAST = 'Y';      We want all records brought into staging
	   COMMIT TRAN;        BEGIN TRAN;      
	   /* insert a second time all as DEN */      
	   INSERT INTO [ast].[QM_ResultByMember_History]             
		  ( 		  
			 [astRowStatus]
			,[srcFileName]
			,[adiTableName]
			,[adiKey]
			,[LoadDate]
			,[ClientKey]
			,[ClientMemberKey]
			,[QmMsrId]
			,[QMDate]
			,[QmCntCat]
			,srcQMID

		  )       
	   OUTPUT inserted.[pstQM_ResultByMbr_HistoryKey] INTO @OutputTbl(ID)      
	   SELECT       
	   /*alias the feilds*/    
		   'Loaded'									   as astRowStatus						--[astRowStatus]
		  ,cop.Sourcefilename							   as srcFileName						--[srcFileName]
		  ,'ast.vw_AetnaMaCareOpsUnpivotedFromAdi'			   as adiTableName						--[adiTableName]
		  ,cop.skey									   as adiKey							--[adiKey]
		  ,@LoadDate  									   as LoadDate							--[LoadDate]		
		  ,@ClientKey									   as ClientKey						--[ClientKey]                  
		  ,cop.MemberID								   as ClientMemberKey					--[ClientMemberKey]
		  ,cop.MeasureID								   as QmMsrId						--[QmMsrId]
		  ,@QMDate										   as Qmdate							--[QMDate]
		  ,CASE WHEN qmComp <> 'UNK' THEN 'DEN'		
			ELSE 'UNK' END								 as QmCntCat							--[QmCntCat]     
		 ,cop.AceQmMsrId					AS srcQMID   
		 								  		       
		           
	   FROM ast.vw_AetnaMaCareOpsUnpivotedFromAdi cop
	  -- where cop.LoadtoAST = 'Y';        We want all records brought into staging   

	  BEGIN
	  /*Set QMMsrID to null where Measure exist but requirement says to ignore*/
	  --SELECT	QmMsrId,QmCntCat,astRowStatus
	  --FROM		ast.QM_ResultByMember_History qm
	  UPDATE  ast.QM_ResultByMember_History
	  SET QmMsrId = NULL 
	  WHERE		ClientKey = @ClientKey
	  AND	QMDate = @QMDate
	  AND	QmCntCat = 'UNK'
	  AND QmMsrId IS NOT NULL

	  END

	   COMMIT TRAN;      
    END TRY      
    BEGIN CATCH      
	   EXEC AceMetaData.amd.TCT_DbErrorWrite;          
	   IF (XACT_STATE()) = -1      
		  BEGIN      
		  ROLLBACK TRANSACTION          
		  END    	   
	   IF (XACT_STATE()) = 1      
		  BEGIN      
		  COMMIT TRANSACTION    ;         
	   END       
	   /* write error log close */          
	   SET @ActionStopTime = getdate();              
	   SELECT @SourceCount = COUNT(*) 
		 FROM ast.vw_AetnaMaCareOpsUnpivotedFromAdi ;      
	   SELECT @DestinationCount= 0;      
	   SET @ErrorCount = @SourceCount;      
	   SET @JobStatus = 3 -- error      
	   EXEC AceMetaData.amd.sp_AceEtlAudit_Close       
		  @AuditId = @AuditID      
		  , @ActionStopTime = @ActionStopTime      
		  , @SourceCount = @SourceCount          
		  , @DestinationCount = @DestinationCount      
		  , @ErrorCount = @ErrorCount      
		  , @JobStatus = @JobStatus      
		  ;      
	   ;THROW      
    END CATCH        
    
    /* close load Staging Log record */          
    SET @ActionStopTime = getdate()      
    SELECT @SourceCount = COUNT(*) from ast.vw_AetnaMaCareOpsUnpivotedFromAdi
    SELECT @DestinationCount= COUNT(ID) FROM @OutputTbl;      
    SET @ErrorCount = 0;
    SET @JobStatus = 2;    
    
    EXEC AceMetaData.amd.sp_AceEtlAudit_Close           
	   @AuditId = @AuditID          
	   , @ActionStopTime = @ActionStopTime          
	   , @SourceCount = @SourceCount              
	   , @DestinationCount = @DestinationCount          
	   , @ErrorCount = @ErrorCount          
	   , @JobStatus = @JobStatus      
	   ;         
    /* Update adi: status = 1*/  
	/*  TO DO LIST - Logging */    
    BEGIN TRY      
	   BEGIN TRAN      
	   -- purpose: Update all rows in adi with status 0 to status = 1
	   UPDATE adiData      
		  SET adiData.CopStgLoadStatus = 1           	   
	   FROM adi.copAetMaCareopps adiData         
	   WHERE adidata.CopStgLoadStatus = 0
	   COMMIT TRAN      
    END TRY      
    BEGIN CATCH      
	   EXEC AceMetaData.amd.TCT_DbErrorWrite;          
	   IF (XACT_STATE()) = -1      
		  BEGIN      
			 ROLLBACK TRANSACTION      
			 ;THROW
		  END    
	   IF (XACT_STATE()) = 1      
		  BEGIN      
			 COMMIT TRANSACTION;         
		  END       
    ;THROW      
    END CATCH

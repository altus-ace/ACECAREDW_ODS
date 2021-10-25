


CREATE PROCEDURE [ast].[pstCopLoadToStg_WlcTxM] 
    @LoadDate DATE, @QMDATE DATE
AS 

    DECLARE @OutputTbl TABLE (ID INT);      
    DECLARE @ClientKey INT = 2 -- WLC
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
        
    SET @JobType = 9	   -- 9 ast load    
    SET @JobName	     = 'pstCopLoadToStg_WlcTxM'
    SELECT @InputSourceName = DB_NAME() + '.adi.copWlcTxM'	    
    SELECT @DestinationName = DB_NAME() + '.ast.QM_ResultByMember_History';    
    SELECT @ErrorName	   = DB_NAME() + '.ast.QM_ResultByMember_History';    
    
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
	   
    /* load to staging table insert set for Num and Cop */      
    BEGIN TRY      
	   BEGIN TRAN      
	   INSERT INTO [ast].[QM_ResultByMember_History]  
		  ([ClientKey]             
		  ,[ClientMemberKey]             
		  ,[QmMsrId]             
		  ,[QmCntCat]             
		  ,[QMDate]             
		  ,[astRowStatus]             
		  , srcFileName
		  ,[adiTableName] 		              
		  ,[adiKey]             
		  ,[LoadDate]
		  , [srcQMID])      
	   OUTPUT inserted.[pstQM_ResultByMbr_HistoryKey]  INTO @OutputTbl(ID)      
	   SELECT           
		  cop.ClientKey          
		  ,cop.MemberId          
		  ,cop.QM_ID           
		  ,cop.CopMsrStatus              
		  ,@QMDATE                    
		  , 'Loaded' AS astRowStatus         
		  , cop.SrcFileName
		  ,'adi.vw_PstSrc_CopWlcTxM'         
		  ,cop.adiKey           
		  ,CONVERT(date, GETDATE()) aS LoadDate
		  ,cop.srcQMID          
	   FROM adi.vw_PstSrc_CopWlcTxM cop;      
	   COMMIT TRAN;        BEGIN TRAN;      
	   /* insert a second time all as DEN */      
	   INSERT INTO [ast].[QM_ResultByMember_History]             
		  ([ClientKey]             
		  ,[ClientMemberKey]             
		  ,[QmMsrId]             
		  ,[QmCntCat]             
		  ,[QMDate]             
		  ,[astRowStatus] 
		  , srcFileName            
		  ,[adiTableName]             
		  ,[adiKey]             
		  ,[LoadDate]
		  , [srcQMID])      
	   OUTPUT inserted.[pstQM_ResultByMbr_HistoryKey] INTO @OutputTbl(ID)      
	   SELECT           
		  cop.ClientKey          
		  ,cop.MemberId          
		  ,cop.QM_ID          
		  ,'DEN'             
		  ,@QMDATE                   
		  , 'Loaded' AS astRowStatus    
		  , cop.SrcFileName     
		  ,'adi.vw_PstSrc_CopWlcTxM'         
		  ,cop.adiKey           
		  ,CONVERT(date, GETDATE()) aS LoadDate  
		  ,cop.srcQMID        
	   FROM adi.vw_PstSrc_CopWlcTxM cop;       
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
		 FROM adi.vw_PstSrc_CopWlcTxM ;      
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
    SELECT @SourceCount = COUNT(*) FROM adi.vw_PstSrc_CopWlcTxM;
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
    BEGIN TRY      
	   BEGIN TRAN      
	   UPDATE adiData      
		  SET status = 1           
	   FROM adi.CopWlcTxM adiData         
		  JOIN adi.vw_PstSrc_CopWlcTxM Src 
			 ON adiData.urn = src.AdiKey;      
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

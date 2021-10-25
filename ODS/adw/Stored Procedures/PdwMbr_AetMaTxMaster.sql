CREATE PROCEDURE [adw].[PdwMbr_AetMaTxMaster]
	@LoadType CHAR(1) /* S or P secondary or Primary */
	,@LoadDate DATE    /* Date of load batch to process */
	,@ClientKey INT    /* client load batch to process */
AS

    /* /
    DECLARE @LoadType CHAR(1) = 'P';
    DECLARE @LoadDate DATE;    
    /* this is a hint on how to get the load date in the caller */
    SELECT @LoadDate = src.LoadDate
    FROM (  SELECT MbrAetMaTx.LoadDate, MbrAetMaTx.DataDate, rank() OVER ( ORDER BY MbrAetMaTx.DataDate DESC) AS aRowRank
		  FROM adi.MbrAetMaTx MbrAetMaTx
		  GROUP BY MbrAetMaTx.LoadDate, MbrAetMaTx.DataDate
		  ) src
    WHERE src.aRowRank = 1
    DECLARE @ClientKey INT = 3;   
    SELECT @LoadType, @LoadDate, @ClientKey;
    / */    
              
    DECLARE @InsertCountAdi	  INT = -1;
    DECLARE @InsertCountLHist	  INT = -1;
    DECLARE @InsertCountMem	  INT = -1;
    DECLARE @InsertCountDemo	  INT = -1;
    DECLARE @UpdateCountDemo	  INT = -1;
    DECLARE @InsertCountPhone	  INT = -1;
    DECLARE @UpdateCountPhone	  INT = -1;
    DECLARE @InsertCountAdd	  INT = -1;
    DECLARE @UpdateCountAdd	  INT = -1;
    DECLARE @InsertCountPcp	  INT = -1;
    DECLARE @UpdateCountPcp	  INT = -1;
    DECLARE @TermedCountPcp	  INT = -1;    
    DECLARE @InsertCountPlan	  INT = -1;
    DECLARE @UpdateCountPlan	  INT = -1;
    DECLARE @TermedCountPlan	  INT = -1;
    DECLARE @InsertCountCsPlan  INT = -1;
    DECLARE @UpdateCountCsPlan  INT = -1;
    DECLARE @TermedCountCsPlan  INT = -1;
    DECLARE @InsertCountStgMbrDet  INT = -1;
    DECLARE @InsertCountStgPhnAdd  INT = -1;
    
    /* logging variables */
    DECLARE @Audit_ID INT	   = 0;    
    DECLARE @AuditStatus tinyINt = 1;
    DECLARE @EtlJobType TinyInt  = 2;
    DECLARE @Job_AetMaTx_MbrLoad VARCHAR(50)		  = 'Aet Ma Tx Member Load';
    DECLARE @Job_AetMaTx_StgMbr VARCHAR(50)		  = 'Aet Ma Tx Stage Member Data';
    DECLARE @Job_AetMaTx_StgPhone VARCHAR(50)	  = 'Aet Ma Tx Stage Member Phone and address Data';
    DECLARE @Job_AetMaTx_TransMbrData VARCHAR(50)	  = 'Aet Ma Tx Transform Member Data';
    DECLARE @Job_AetMaTx_TransPhone VARCHAR(50)	  = 'Aet Ma Tx Transform Member Phone and address Data';
    DECLARE @Job_AetMaTx_ValidMbrData VARCHAR(50)	  = 'Aet Ma Tx validate Member Data';
    DECLARE @Job_AetMaTx_ValidPhone   VARCHAR(50)	  = 'Aet Ma Tx validate Member Phone and address Data';
    DECLARE @Job_AetMaTx_ExpMbrLoadHist VARCHAR(50) = 'Aet Ma Tx Stage Member Phone and address Data';
/*    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    */
    DECLARE @DateTime2 DATETIME2;
        
    /*  Load staging from Adi */
    EXEC ast.[MbrPst2MbrAetMaTxMbrDetail]   @loadDate,  @InsertCount = @InsertCountStgMbrDet OUTPUT;
    EXEC ast.MbrPst2MbrAetMaTxMbrPhnAdd	    @loadDate,  @InsertCount = @InsertCountStgPhnAdd OUTPUT;

    /* Update adi MbrLoadStatus: 1 = loaded to stg, 2 means never load to status, rule failure */
    MERGE adi.MbrAetMaTx TRG
    USING (SELECT adiData.mbrAetMaTxKey 
	   	   , DATEFROMPARTS(SUBSTRING(adiData.EffectiveMonth, 1, 4), SUBSTRING(adiData.EffectiveMonth, 5, 2), 1) RowEffMonthStart
	   	   , DATEADD(day, -1, (DATEADD(month, 1, (DATEFROMPARTS(SUBSTRING(adiData.EffectiveMonth, 1, 4), SUBSTRING(adiData.EffectiveMonth, 5, 2), 1))))) RowEffMonthEnd 	       	          
	   	   , CASE WHEN (astData.mbrStg2_MbrDataUrn is null) THEN 2 ELSE 1 END AS NewMbrLS
	       FROM adi.MbrAetMaTx adiData
	   	   LEFT JOIN (SELECT * FROM ast.MbrStg2_MbrData astData	    
	   				WHERE astData.LoadDate = @LoadDate
	   				    and astData.ClientKey = @Clientkey) astData
	   	   ON adiData.mbrAetMaTxKey = astData.AdiKey
	   		  --and astData.AdiTableName = 'adi.MbrAetMaTx'
	       WHERE adiData.MbrLoadStatus = 0
		  )src 
	ON Trg.MbrAetMaTxKey = src.MbrAetMaTxKey
	WHEN MATCHED THEN 
	   UPDATE SET trg.MbrLoadStatus = src.NewMbrLS
	   ;

    /* transform  the Staging data
	   1. GET MRN keys. this will be replaced with MRN Code
	   */ -- Commented out cos of error
    --TRUNCATE TABLE AceMpi.ast.MPI_SOURCETABLE ;  
    --EXEC [ast].[GetMrnFromMpi];

	EXECUTE [ast].[pls_AetnaMbrMembershipRunMPI]@ClientKey;

	--Validate MstrnMrnkey for Dedup
	SELECT	 COUNT(*), MstrMrnKey 
	FROM	 ast.MbrStg2_MbrData 
	WHERE	 LoadDate = @LoadDate
	AND		 ClientKey = @Clientkey
	GROUP BY MstrMrnKey 
	HAVING	 COUNT(*)>1
    
    BEGIN TRAN loadAetMA_Mbr; -- rollback tran loadAetMA_Mbr; -- commit tran loadAetMA_Mbr;
    /* validate     
	   01.things to validate, 1 is the TIN valid?
	   02. things to validate is the mapping all applied
    */
       
    EXEC [ast].[Pst_MbrDetails_Validate]	   @LoadDate, @ClientKey;
    EXEC [ast].[Pst_MbrPhnAddEmail_Validate]	   @LoadDate, @ClientKey;
        
    /* load Members */
    SET @DateTime2 = GETDATE();	   
    /*
    EXEC AceMetaData.amd.[sp_AceEtlAudit_Open] @AuditID = @Audit_ID OUTPUT,              
		 @AuditStatus = @AuditStatus , @JobType = @EtlJobType, @ClientKey = @ClientKey , @JobName = @Job_AetCom_ExpMbrLoadHist,
		  @ActionStartTime = @DateTime2, @InputSourceName = 'ast.MbrStg2_MbrData', @DestinationName = 'adw.mbrLoadHistory',
		  @ErrorName = 'N/A'                           ;
		  */
    EXEC [adw].[PdwMbr_01_LoadHistory]	 @LoadDate, @LoadType, @ClientKey, @InsertCount = @InsertCountLHist	 Output;
    /*
    SET @DateTime2 = GETDATE();
    EXEC AceMetaData.amd.sp_AceEtlAudit_Close @Audit_ID = @Audit_ID, @ActionStopTime = @DateTime2, @SourceCount = @Stg2CntMbrDet
		  , @DestinationCount = @InsCntLHist, @ErrorCount = 0, @JobStatus = 1;   
    */
    EXEC [adw].[PdwMbr_02_LoadMember]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountMem	 Output;
    EXEC [adw].[PdwMbr_03_LoadDemo]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountDemo	 Output, @UpdateCount = @UpdateCountDemo OUTPUT;    
    EXEC [adw].[PdwMbr_06_LoadPcp]		 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountPcp	 Output, @UpdateCount = @UpdateCountPcp OUTPUT;
    EXEC adw.PdwMbr_30_TermPcp		 @LoadDate		 , @ClientKey, @TermCount   = @TermedCountPcp	 Output;
    EXEC [adw].[PdwMbr_08_LoadPlan]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountPlan	 Output, @UpdateCount = @UpdateCountPlan OUTPUT;
    EXEC [adw].[PdwMbr_25_TermPlan]	 @LoadDate		 , @ClientKey, @TermCount   = @TermedCountPlan	 Output; 
    
    EXEC [adw].[PdwMbr_09_LoadCsPlan]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountCsPlan	 Output, @UpdateCount = @UpdateCountCsPlan OUTPUT;
    EXEC [adw].[PdwMbr_29_TermCsPlan]	 @LoadDate		 , @ClientKey, @TermCount   = @TermedCountCsPlan	 Output; 

    EXEC [adw].[PdwMbr_04_LoadPhone]	 @LoadDate, @LoadType, @ClientKey, @InsertCount = @InsertCountPhone	 Output, @UpdateCount = @UpdateCountPhone OUTPUT;
    EXEC [adw].[PdwMbr_05_LoadAddress]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountAdd	 Output, @UpdateCount = @UpdateCountAdd OUTPUT;

	/*Load into Member Month History table*/
	EXEC adw.pdwMbr_31_Load_MemberMonth_Consolidation  @LoadDate, @ClientKey
	EXEC [ACDW_CLMS_AET_TX_COM].[adw].[pdw_Load_MonthlyRecordsIntoMemberMonthByMonth] @LoadDate, @ClientKey
	
  
    /* update staging data with new status */    
    EXEC [ast].[Pst_MbrDetails_MarkExported] @LoadDate, @ClientKey;
    EXEC [ast].[Pst_MbrPhnAddEmail_MarkExported] @LoadDate, @ClientKey;

	/*Load Failed Membership Table*/
	DECLARE @EffectiveDate DATE =  CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0, @LoadDate), 0)) 
	EXEC [ACDW_CLMS_AET_MA].[adw].[pdw_Load_FailedMembership]@EffectiveDate

    /* log */
    INSERT INTO [amd].[AceMbrLoadLog]
           (ClientKey, [LoadDate], LoadType, [countInsertLoadHist], [countInsertMember], [countInsertDemo]
		 , [countUpdateDemo], [countInsertPhone], [countUpdatePhone],[countInsertAddress]
		 , [countUpdateAddress], [countInsertPcp], [countUpdatePcp], CountTermedPcp, [countInsertPlan]
		 , [countUpdatePlan], [countTermedPlanCnt], [CountInsertCsPlan], [countUpdateCsPlan],
		  [countTermedCsPlanCnt])
     SELECT @ClientKey, @loaddate, @LoadType, @InsertCountLHist , @InsertCountMem, @InsertCountDemo 
	   , @UpdateCountDemo, @InsertCountPhone, @UpdateCountPhone, @InsertCountAdd
	   , @UpdateCountAdd , @InsertCountPcp  , @UpdateCountPcp, @TermedCountPcp , @InsertCountPlan 
	   , @UpdateCountPlan , @TermedCountPlan , @InsertCountCsPlan ,@UpdateCountCsPlan
	   , @TermedCountPlan;
    
    SELECT top 1 LoadLog.* FROM amd.AceMbrLoadLog LoadLog 
    --ORDER BY loadLog.AceMbrLoadLogKey desc
    where LoadLog.AceMbrLoadLogKey = @@IDENTITY;-- order by aceMbrLoadLogKey desc 
    --EXEC adi.AceValidMbrsAetMaTx
    --commit tran loadAetMA_Mbr;
    --rollback tran loadAetMA_Mbr;
    
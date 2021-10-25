
CREATE PROCEDURE [adw].[PdwMbr_UhcTxM_Master_V0]
    @LoadType Char(1)
    , @LoadDate Date    	
AS 
   /* /

    DECLARE @LoadType CHAR(1) = 'P';
    DECLARE @LoadDate DATE;
/ */
  
    --SELECT @LoadDate = m.loadDate FROM adi.UHC_TempLoad_LoadDateToLoad m
    -- update adi.UHC_TempLoad_LoadDateToLoad  set loaddate = '2019-12-16'  SELECT * FROM adi.UHC_TempLoad_LoadDateToLoad m
    SELECT @LoadDate = MAX(a.LoadDate)
    FROM adi.mbrUhcMbrByPcp a  
    WHERE a.mbrLoadStatus = 0	   
    group by a.LoadDate      
        
/**/

    DECLARE @ClientKey INT;	   
    SELECT @ClientKey = c.ClientKey FROM lst.list_Client c WHERE c.ClientShortName = 'UHC';    	
    SELECT @LoadType, @LoadDate, @ClientKey;
    
    /* prepare countVariables */    
    DECLARE @InsertCountAdi		 INT = -1;
    DECLARE @InsertCountHist		 INT = -1;
    DECLARE @InsertCountMem		 INT = -1;
    DECLARE @InsertCountDemo		 INT = -1;
    DECLARE @UpdateCountDemo		 INT = -1;
    DECLARE @InsertCountPhone		 INT = -1;
    DECLARE @UpdateCountPhone		 INT = -1;
    DECLARE @InsertCountAddress	 INT = -1;
    DECLARE @UpdateCountAddress	 INT = -1;
    DECLARE @InsertCountPcp		 INT = -1;
    DECLARE @UpdateCountPcp		 INT = -1;    
    DECLARE @TermedCountPcp		 INT = -1;
    DECLARE @InsertCountPlan		 INT = -1;
    DECLARE @UpdateCountPlan		 INT = -1;
    DECLARE @TermedCountPlan		 INT = -1;
    DECLARE @InsertCountCsPlan	 INT = -1;
    DECLARE @UpdateCountCsPlan	 INT = -1;
    DECLARE @TermedCountCsPlan	 INT = -1;
    DECLARE @InsertCountEmail		 INT = -1;
    DECLARE @UpdateCountEmail		 INT = -1;    
    DECLARE @Stg2CountMbrDet		 INT = -1;
    DECLARE @Stg2CountMbrPhnAdd	 INT = -1;
     
       
    /* Load Stging tables */	
    EXEC ast.MbrPst2MbrUhcTxMbrDetail @LoadDate, @LoadType, @InsertCount = @Stg2CountMbrDet	OUTPUT; 
    EXEC ast.MbrPst2MbrUhcMTxMbrPhnAdd @LoadDate, @LoadType, @InsertCount = @Stg2CountMbrPhnAdd OUTPUT;

    /* update adi MbrLoadStatus to indicate the data has been staged */
    --SELECT pcp.mbrMbrByPcpKey, pcp.MbrLoadStatus
    UPDATE Pcp SET Pcp.MbrLoadStatus = 1    
    FROM adi.mbrUhcMbrByPcp Pcp 
	   JOIN ast.MbrStg2_MbrData stg ON pcp.mbrMbrByPcpKey = stg.AdiKey
	   	   and stg.AdiTableName = 'adi.MbrUhcMbrByPcp'
    WHERE pcp.MbrLoadStatus = 0 AND stg.ClientKey = 1;
     
    /* prep and load MRN */
    TRUNCATE TABLE AceMpi.ast.MPI_SOURCETABLE ;  
    EXEC [ast].[GetMrnFromMpi];
 
 /* Validate the data prior to Export */

	EXEC ast.Pst_MbrDetails_Validate @LoadDate, @ClientKey	;
	EXEC ast.Pst_MbrPhnAddEmail_Validate @LoadDate, @ClientKey ;

	--Get validation Count: if the ratio is to high (exist / term) stop the process and report an error. or something.
	-- SELECT * FROM ast.MbrStg2_MbrData mbr where mbr.stgRowStatus = 'VALID' and mbr.ClientKey = 1 --@ClientKey
  /* execute Export Jobs */
    
    BEGIN TRAN loadUhc; -- rollback tran loadUhc; COMMIT tran loadUhc;
	
    -- rollback COMMIT tran loadUhc;
    EXEC [adw].[PdwMbr_01_LoadHistory]	@LoadDate,  @LoadType,  @ClientKey, @InsertCount = @InsertCountHist	  OUTPUT;
    EXEC [adw].[PdwMbr_02_LoadMember]	@LoadDate,		    @ClientKey, @InsertCount = @InsertCountMem	  OUTPUT;
    EXEC [adw].[PdwMbr_03_LoadDemo]	@LoadDate,		    @ClientKey, @InsertCount = @InsertCountDemo	  OUTPUT, @UpdateCount = @UpdateCountDemo	 OUTPUT;
    EXEC [adw].[PdwMbr_04_LoadPhone]	@LoadDate, @LoadType,   @ClientKey, @InsertCount = @InsertCountPhone	  OUTPUT, @UpdateCount = @UpdateCountPhone	 OUTPUT;
    EXEC [adw].[PdwMbr_05_LoadAddress]	@LoadDate,		    @ClientKey, @InsertCount = @InsertCountAddress  OUTPUT, @UpdateCount = @UpdateCountAddress	 OUTPUT;
    EXEC [adw].[PdwMbr_11_LoadEmail]	@LoadDate,		    @ClientKey, @InsertCount = @InsertCountEmail	  OUTPUT, @UpdateCount = @UpdateCountEmail	 OUTPUT;
    EXEC [adw].[PdwMbr_06_LoadPcp]		@LoadDate,		    @ClientKey, @insertcount = @InsertCountPcp	  OUTPUT, @UpdateCount = @UpdateCountPcp	 OUTPUT;    
    EXEC [adw].[PdwMbr_08_LoadPlan]	@LoadDate,		    @ClientKey, @InsertCount = @InsertCountPlan	  OUTPUT, @UpdateCount = @UpdateCountPlan	 OUTPUT;
    EXEC [adw].[PdwMbr_09_LoadCsPlan]	@LoadDate,		    @ClientKey, @InsertCount = @InsertCountCsPlan	  OUTPUT, @UpdateCount = @UpdateCountCsPlan;
    EXEC [adw].[PdwMbr_30_TermPcp]		@LoadDate,		    @ClientKey, @TermCount    = @TermedCountPcp	  OUTPUT;         
    EXEC [adw].[PdwMbr_25_TermPlan]	@LoadDate,		    @ClientKey, @TermCount    = @TermedCountPlan	  OUTPUT;     
    EXEC [adw].[PdwMbr_29_TermCsPlan]	@LoadDate,		    @ClientKey, @TermCount    = @TermedCountCsPlan  OUTPUT; 
    
    --rollback tran loadUhc; 
    --COMMIT tran loadUhc;
	
	/* Mark Exported the data prior to Export */
	EXEC ast.Pst_MbrDetails_MarkExported	 @LoadDate, @ClientKey;
	EXEC ast.Pst_MbrPhnAddEmail_MarkExported @LoadDate, @ClientKey;

    /* make this an insert into the Load log table */	

    
  INSERT INTO amd.[AceMbrLoadLog] 
	   (ClientKey, LoadDate, LoadType
	   , countInsertLoadHist, countInsertMember, countInsertDemo, countUpdateDemo
	   , countInsertPhone, countUpdatePhone, countInsertAddress, countUpdateAddress
	   , countInsertPcp, countUpdatePcp,   CountTermedPcp
	   , countInsertPlan, countUpdatePlan, countTermedPlanCnt
	   , CountInsertCsPlan, countUpdateCsPlan, countTermedCsPlanCnt)
    SELECT 
	     @ClientKey, @LoadDate, @LoadType
	   , @InsertCountHist cntILHist, @InsertCountMem , @InsertCountDemo,	@UpdateCountDemo	  
        , @InsertCountPhone ,	   @UpdateCountPhone,	 @InsertCountAddress,	@UpdateCountAddress 
        , @InsertCountPcp,	   @UpdateCountPcp,		 @TermedCountPcp 
        , @InsertCountPlan,	   @UpdateCountPlan,	 @TermedCountPlan
        , @InsertCountCsPlan,	   @UpdateCountCsPlan,	 @TermedCountCsPlan;
    
    SELECT LoadLog.*
    FROM amd.[AceMbrLoadLog] LoadLog
    WHERE LoadLog.AceMbrLoadLogKey = @@Identity;

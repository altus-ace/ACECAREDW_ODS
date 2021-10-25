
CREATE PROCEDURE [adw].[PdwMbr_CignaMaTx_Master]
	@LoadDate Date , @DataDate DATE  	
AS 
    

    -- DECLARE @LoadDate DATE = '06/12/2020';	
    DECLARE @LoadType CHAR(1) = 'P';    
          
    SELECT @LoadDate = MAX(CONVERT(date, adidata.DataDate) )    
    FROM [ACDW_CLMS_CIGNA_MA].[adi].[tmp_CignaMAMembership] AS adiData
    WHERE adidata.mbrLoadStatus = 0    
        
    DECLARE @ClientKey INT;	   
    SELECT @ClientKey = c.ClientKey FROM lst.list_Client c WHERE c.ClientShortName = 'Cigna_MA';   
    select @clientKey, @LoadDate, @LoadType
	
    
    /* prepare countVariables */    
    DECLARE @InsertCountAdi		INT = -1;
    DECLARE @InsertCountHist		INT = -1;
    DECLARE @InsertCountMem		INT = -1;
    DECLARE @InsertCountDemo		INT = -1;
    DECLARE @UpdateCountDemo		INT = -1;
    DECLARE @InsertCountPhone		INT = -1;
    DECLARE @UpdateCountPhone		INT = -1;
    DECLARE @InsertCountAddress	INT = -1;
    DECLARE @UpdateCountAddress	INT = -1;
    DECLARE @InsertCountPcp		INT = -1;
    DECLARE @UpdateCountPcp		INT = -1;    
    DECLARE @TermedCountPcp		INT = -1;
    DECLARE @InsertCountPlan		INT = -1;
    DECLARE @UpdateCountPlan		INT = -1;
    DECLARE @TermedCountPlan		INT = -1;
    DECLARE @InsertCountCsPlan	INT = -1;
    DECLARE @UpdateCountCsPlan	INT = -1;
    DECLARE @TermedCountCsPlan	INT = -1;
    DECLARE @InsertCountEmail		INT = -1;
    DECLARE @UpdateCountEmail		INT = -1;    
    DECLARE @Stg2CountMbrDet		INT = -1;
    DECLARE @Stg2CountMbrPhnAdd	INT = -1;
	DECLARE @MemberMonth DATE =  CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) ---Make a change request
            
    /* Load Stging tables */	
   EXEC ast.MbrPst2MbrCignaMaTxMbrDetail @DataDate, @InsertCount = @Stg2CountMbrDet	OUTPUT; 
   EXEC ast.MbrPst2MbrCignaMaTxMbrPhnAdd @DataDate, @InsertCount = @Stg2CountMbrPhnAdd OUTPUT;
	
    /*UPDATE ADI loadStatus column*/
    Update adi SET adi.MbrLoadStatus = 1    
    FROM ACDW_CLMS_CIGNA_MA.adi.[tmp_CignaMAMembership] adi 
    WHERE --adi.dataDate = @LoadDate
	    adi.mbrLoadStatus = 0 ; --want all record as 0. Latest files only get processed

	/* Validate the data prior to Export */
    EXEC ast.Pst_MbrDetails_Validate @LoadDate, @ClientKey	;
    EXEC ast.Pst_MbrPhnAddEmail_Validate @LoadDate, @ClientKey ;
	 -- EXEC ast.pupd_UpdateStatusRowForInvalidRecords @LoadDate, @ClientKey; 

    /* GET MRN/Ace ID */--CHANGE THIS GUY
	-- Commented out cos of error
   /*TRUNCATE TABLE AceMpi.ast.MPI_SOURCETABLE ;  
   EXEC [ast].[GetMrnFromMpi];*/

   EXECUTE [ast].[pls_AetnaMbrMembershipRunMPI]@ClientKey;

 
    /* execute Export Jobs */
    BEGIN TRAN loadCignaMaTx;
	
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
    EXEC [adw].[PdwMbr_30_TermPcp]		@LoadDate,		    @ClientKey, @TermCount    = @TermedCountPlan	  OUTPUT;         
    EXEC [adw].[PdwMbr_25_TermPlan]	@LoadDate,		    @ClientKey, @TermCount    = @TermedCountPlan	  OUTPUT;     
    EXEC [adw].[PdwMbr_29_TermCsPlan]	@LoadDate,		    @ClientKey, @TermCount    = @TermedCountCsPlan  OUTPUT; 

	/*Create AWV Programs for New Members*/
	DECLARE @ProgramID INT = 22
	EXECUTE [ast].[PdwCreateExportProgram]@LoadDate,@clientKey,@ProgramID
	   
	 /*Load into Member Month History table*/
	EXEC adw.pdwMbr_31_Load_MemberMonth_Consolidation  @LoadDate, @ClientKey;
	

	
	 /* Mark Exported the data prior to Export */
	EXEC ast.Pst_MbrDetails_MarkExported	 @LoadDate, @ClientKey;
	EXEC ast.Pst_MbrPhnAddEmail_MarkExported @LoadDate, @ClientKey;


	/*Load Failed Membership Table*/
	DECLARE @EffectiveDate DATE =  CONVERT(DATE,DATEADD(month, DATEDIFF(month, 0, @LoadDate), 0)) 
	EXEC [ACDW_CLMS_CIGNA_MA].[adw].[pdw_Load_FailedMembership]@EffectiveDate
      
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

	--commit tran loadCignaMaTx; 
	rollback tran loadCignaMaTx;

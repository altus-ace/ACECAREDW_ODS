
CREATE PROCEDURE [adw].[PdwMbr_WlcMaMaster_OLD]
    @LoadType CHAR(1)
    , @LoadDate DATE
    , @ClientKey INT 
AS 
    /* /
    DECLARE @LoadType CHAR(1) = 'P';
    DECLARE @LoadDate DATE --= '2019-08-16';
    SELECT @LoadDate = MAX(LOADDATE) FROM adi.MbrWlcMbrByPcp
    DECLARE @ClientKey INT = 2; 
    SELECT @LoadType, @LoadDate, @ClientKey
    / */
    --SELECT MAX(LOADDATE) FROM adi.MbrWlcMbrByPcp

    DECLARE @ExecStart DATETIME2 = GETDATE();
    DECLARE @ExecStop  DATETIME2;
    DECLARE @InsertAdiCount	  INT = -1;
    DECLARE @InsertCountHist  INT = -1;
    DECLARE @InsertCountMem   INT = -1;
    DECLARE @InsertCountDemo  INT = -1;
    DECLARE @UpdateCountDemo  INT = -1;
    DECLARE @InsertCountPhone INT = -1;
    DECLARE @UpdateCountPhone INT = -1;
    DECLARE @InsertCountAdd	  INT = -1;
    DECLARE @UpdateCountAdd	  INT = -1;
    DECLARE @InsertCountPcp	  INT = -1;
    DECLARE @UpdateCountPcp	  INT = -1;
    DECLARE @TermedCountPcp	  INT = -1;    
    DECLARE @InsertCountPlan  INT = -1;
    DECLARE @UpdateCountPlan  INT = -1;
    DECLARE @TermedCountPlan  INT = -1;
    DECLARE @InsertCountCsPlan  INT = -1;
    DECLARE @UpdateCountCsPlan  INT = -1;
    DECLARE @TermedCountCsPlan  INT = -1;
    

    --SELECT DISTINCT LOADDATE FROM adi.MbrWlcMbrByPcp m order by loaddate
    --SELECT count(*) FROM adi.MbrWlcMbrByPcp m WHERE m.LoadDate = @LoadDate

    begin tran loadWlc;
    EXEC [adw].[AceMrnMbrWlcMbrByPcp] @LoadDate,@ClientKey;    
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_01_0025_LoadHistory]	@LoadDate, @LoadType	 ,@InsertCount = @InsertCountHist Output;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_02_0025_LoadMember]	@LoadDate, @InsertCount = @InsertCountMem	 Output;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_03_0025_LoadDemo]		@LoadDate, @InsertCount = @InsertCountDemo	 Output, @UpdateCount = @UpdateCountDemo OUTPUT;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_04_0025_LoadPhone]	@LoadDate, @InsertCount = @InsertCountPhone Output,   @UpdateCount = @UpdateCountPhone OUTPUT;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_05_0025_LoadAddress]	@LoadDate, @InsertCount = @InsertCountAdd	 Output, @UpdateCount = @UpdateCountAdd OUTPUT;    
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_08_0025_LoadPlan]		@LoadDate, @InsertCount = @InsertCountPlan	 Output, @UpdateCount = @UpdateCountPlan OUTPUT;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_06_0025_LoadPcp]		@LoadDate, @InsertCount = @InsertCountPcp	 Output, @UpdateCount = @UpdateCountPcp OUTPUT;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_09_0025_LoadCsPlan]	@LoadDate, @InsertCount = @InsertCountCsPlan	 Output, @UpdateCount = @UpdateCountCsPlan OUTPUT;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_27_0025_TermPcp]		@LoadDate, @TermCount   = @TermedCountPcp	 Output;    
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_28_0025_TermPlan]		@LoadDate, @TermCount   = @TermedCountPlan	 Output;
    EXEC [adw].[AcePdwMbrWlcMbrByPcp_29_0025_TermCsPlan]	@LoadDate, @TermCount   = @TermedCountCsPlan	 Output;
	EXEC adw.pdwMbr_31_Load_MemberMonth_Consolidation  @LoadDate, @ClientKey;
    
    SET @ExecStop = GETDATE();
    
    /* write this to the log table Probably by section*/
    
    INSERT INTO amd.[AceMbrLoadLog] 
	   (ClientKey, LoadDate, LoadType
	   , countInsertLoadHist, countInsertMember, countInsertDemo, countUpdateDemo
	   , countInsertPhone, countUpdatePhone, countInsertAddress, countUpdateAddress
	   , countInsertPcp, countUpdatePcp,   CountTermedPcp
	   , countInsertPlan, countUpdatePlan, countTermedPlanCnt
	   , CountInsertCsPlan, countUpdateCsPlan, countTermedCsPlanCnt)
    SELECT  --@ExecStart, @ExecStop
	   @ClientKey, @LoadDate, @LoadType
        , @InsertCountHist , @InsertCountMem , @InsertCountDemo ,  @UpdateCountDemo 
        , @InsertCountPhone,@UpdateCountPhone , @InsertCountAdd  ,  @UpdateCountAdd  
        , @InsertCountPcp  ,  @UpdateCountPcp  , @TermedCountPcp
        , @InsertCountPlan ,  @UpdateCountPlan , @TermedCountPlan 
        , @InsertCountCsPlan, @UpdateCountCsPlan, @TermedCountPlan 
	   ;

    SELECT * FROM [amd].[AceMbrLoadLog] mll WHERE mll.AceMbrLoadLogKey = @@IDENTITY;
    
    EXEC [adi].[AceValidMbrsWlc_CompareLastLoad] --cNT nEW: 1043, cntTerm 3, Prior, 7/29/19, Cur 8/16

	EXEC [adw].[pdwMbr_31_Load_MemberMonth_Consolidation]@LoadDate, @ClientKey 
    
    --2019-07-29	742	2019-08-16	833	91
    --commit tran loadWlc;
    rollback tran loadWlc;

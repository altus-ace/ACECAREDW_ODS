
CREATE PROCEDURE [adw].[zzPdwMbr_WlcMaMaster]
    @LoadType CHAR(1)
    , @LoadDate DATE
    , @ClientKey INT 
AS 
    /*
    DECLARE @LoadType CHAR(1) = 'P';    
    DECLARE @ClientKey INT = 2; 
    DECLARE @LoadDate DATE;    
    /* this is a hint on how to get the load date in the caller */
    SELECT @LoadDate = src.LoadDate
    FROM (  SELECT MbrWlcTx.LOADDATE, MbrWlcTx.DataDate
			 , ROW_NUMBER() OVER (ORDER BY MbrWlcTx.DataDate Desc) aRowRank
		  FROM adi.MbrWlcMbrByPcp MbrWlcTx 
		  GROUP BY MbrWlcTx.LoadDate, MbrWlcTx.DataDate
		  ) src
    WHERE src.aRowRank = 1
    
    SELECT @LoadType AS LoadType, @LoadDate AS LoadDate, @ClientKey As ClientKey;
   */

    DECLARE @DefaultTermDate DATE = '12/31/2099';
    
    DECLARE @ExecStart DATETIME2 = GETDATE();
    DECLARE @ExecStop  DATETIME2;
    DECLARE @InsertAdiCount	  INT = -1;
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
    

    --SELECT DISTINCT LOADDATE FROM adi.MbrWlcMbrByPcp m order by loaddate
    --SELECT count(*) FROM adi.MbrWlcMbrByPcp m WHERE m.LoadDate = @LoadDate
    
    -- Load to Stg	  
    EXEC [ast].[MbrPst2MbrWlcTxMbrDetail] @LoadDate, @InsertCount = @InsertCountStgMbrDet OUTPUT;
    EXEC [ast].[MbrPst2MbrWlcTxMbrPhnAdd] @LoadDate, @InsertCount = @InsertCountStgPhnAdd OUTPUT;  -- this convert errored out.
    EXEC [ast].[MbrPst2LoadToStagingExisting] @LoadDate, @ClientKey; -- this loads terms
    
    
    begin tran loadWlc;
    /* Process MPI */	 
    EXECUTE [ast].[GetMrnFromMpi];

    -- transform data to target values with business rules
--    EXEC ast.MbrPstTransformMaster @LoadDate , @ClientKey , @DefaultTermDate ;
  
    -- validate rows pass bussiness rules
  --  EXEC ast.MbrPstValidateMaster;
    
    -- export to data warehouse	
--    EXEC ast.MbrPstExportMaster;

    /* 
    The module 'PdwMbr_WlcMaMaster' depends on the missing object 'ast.MbrPstTransformMaster'. The module will still be created; however, it cannot run successfully until the object exists.
    The module 'PdwMbr_WlcMaMaster' depends on the missing object 'ast.MbrPstValidateMaster'. The module will still be created; however, it cannot run successfully until the object exists.
    The module 'PdwMbr_WlcMaMaster' depends on the missing object 'ast.MbrPstExportMaster'. The module will still be created; however, it cannot run successfully until the object exists.
    */
    
    --cREATE A FX TO DO  The export it will 
    /*
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
        , @InsertCountLHist , @InsertCountMem , @InsertCountDemo ,  @UpdateCountDemo 
        , @InsertCountPhone,@UpdateCountPhone , @InsertCountAdd  ,  @UpdateCountAdd  
        , @InsertCountPcp  ,  @UpdateCountPcp  , @TermedCountPcp
        , @InsertCountPlan ,  @UpdateCountPlan , @TermedCountPlan 
        , @InsertCountCsPlan, @UpdateCountCsPlan, @TermedCountPlan 
	   ;

    SELECT * FROM [amd].[AceMbrLoadLog] mll WHERE mll.AceMbrLoadLogKey = @@IDENTITY;
    */
    EXEC [adi].[AceValidMbrsWlc_CompareLastLoad] --cNT nEW: 1043, cntTerm 3, Prior, 7/29/19, Cur 8/16
    
    --2019-07-29	742	2019-08-16	833	91
    --commit tran loadWlc;
    rollback tran loadWlc;

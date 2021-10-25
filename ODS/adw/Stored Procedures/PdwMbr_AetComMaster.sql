CREATE PROCEDURE [adw].[PdwMbr_AetComMaster]
	@LoadType CHAR(1) /* S or P secondary or Primary */
	,@LoadDate DATE    /* Date of load batch to process */
	,@ClientKey INT    /* client load batch to process */
AS

    /* /
    DECLARE @LoadType CHAR(1) = 'P';        
    DECLARE @LoadDate DATE = '01/01/1900';    
    /* this is a hint on how to get the load date in the caller */
    SELECT @LoadDate = src.LoadDate
    FROM (  SELECT MbrAetCom.LoadDate, MbrAetCom.DataDate, rank() OVER ( ORDER BY MbrAetCom.DataDate DESC) AS aRowRank
		  FROM adi.MbrAetCom MbrAetCom
		  WHERE MbrAetCom.mbrLoadStatus = 0
		  GROUP BY MbrAetCom.LoadDate, MbrAetCom.DataDate
		  ) src
    --WHERE src.aRowRank = 1
    DECLARE @ClientKey INT = 9;         
    SELECT @LoadType, @LoadDate, @ClientKey
    / */
    --SELECT DISTINCT LOADDATE from adi.MbrAetCom 

    /*  Validate if needed. This should be done in the profile prior to this step. 
        EXEC adi.AceValid_AetComTx_Mbr @LoadDate
		
	   DECLARE @PlanActive smallint = 1 -- return only active plans
	   DECLARE @PcpActive smallint = 1	 -- return only active pcps
	   EXEC  [adw].[sp_Ace_Validate_MbrModel] @clientKey, @LoadDate  ,@PlanActive ,@PcpActive
	   GO
    */

    DECLARE @InsertAdiCount	  INT = -1;
    DECLARE @InsertCountLHist  INT = -1;
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
    DECLARE @InsertCountPrac  INT = -1;
    DECLARE @UpdateCountPrac  INT = -1;
    DECLARE @InsertCountPlan  INT = -1;
    DECLARE @UpdateCountPlan  INT = -1;
    DECLARE @TermedCountPlan  INT = -1;
    DECLARE @InsertCountCsPlan  INT = -1;
    DECLARE @UpdateCountCsPlan  INT = -1;
    DECLARE @TermedCountCsPlan  INT = -1;
    DECLARE @Stg2CountMbrDet  INT = -1;
    DECLARE @Stg2CountMbrPhnAdd  INT = -1;
    

    DECLARE @Audit_ID INT	   = 0;    
    DECLARE @AuditStatus tinyINt = 1;
    DECLARE @EtlJobType TinyInt  = 2;
    DECLARE @Job_AetCom_MbrLoad VARCHAR(50) = 'Aet Com Member Load';
    DECLARE @Job_AetCom_StgMbr VARCHAR(50) = 'Aet Com Stage Member Data';
    DECLARE @Job_AetCom_StgPhone VARCHAR(50) = 'Aet Com Stage Member Phone and address Data';
    DECLARE @Job_AetCom_TransMbrData VARCHAR(50) = 'Aet Com Transform Member Data';
    DECLARE @Job_AetCom_TransPhone VARCHAR(50)   = 'Aet Com Transform Member Phone and address Data';
    DECLARE @Job_AetCom_ValidMbrData VARCHAR(50) = 'Aet Com validate Member Data';
    DECLARE @Job_AetCom_ValidPhone   VARCHAR(50) = 'Aet Com validate Member Phone and address Data';
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data';
/*    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    DECLARE @Job_AetCom_ExpMbrLoadHist VARCHAR(50) = 'Aet Com Stage Member Phone and address Data'
    */
    DECLARE @DateTime2 DATETIME2;

    /*  Load staging from Adi */
   EXEC ast.MbrPst2MbrAetComMbrDetail @loadDate, @InsertCount = @Stg2CountMbrDet OUTPUT;
   EXEC ast.MbrPst2MbrAetComMbrPhnAdd @loadDate, @InsertCount = @Stg2CountMbrPhnAdd OUTPUT;

    /* update adi MbrLoadStatus */
    /* this should update all rows as they are considered and rejected. */
    SELECT adi.mbrAetComMbr, adi.MbrLoadStatus
    --UPDATE adi SET adi.MbrLoadStatus = 1
    FROM adi.MbrAetCom Adi
	JOIN ast.MbrStg2_MbrData stg On Adi.mbrAetComMbr = stg.AdiKey and stg.AdiTableName = 'adi.MbrAetCom'
    WHERE Adi.MbrLoadStatus = 0;

    /* transform  the Staging data */
	---- Commented out cos of error
	/*
    TRUNCATE TABLE AceMpi.ast.MPI_SOURCETABLE ;  
    EXEC [ast].[GetMrnFromMpi];*/
    /* other transformation */
    ---use this instead
	EXECUTE [ast].[pls_AetnaMbrMembershipRunMPI]@ClientKey;

	
    /* validate */ 
    EXEC [ast].[Pst_MbrDetails_Validate]	   @LoadDate, @ClientKey;
    EXEC [ast].[Pst_MbrPhnAddEmail_Validate]	   @LoadDate, @ClientKey;

    
    /* load Members */
    BEGIN TRAN loadAetCom; -- rollback tran loadAetCom; -- commit tran loadAetCom;

    SET @DateTime2 = GETDATE();	   
    /*
    EXEC AceMetaData.amd.[sp_AceEtlAudit_Open] @AuditID = @Audit_ID OUTPUT,              
		 @AuditStatus = @AuditStatus , @JobType = @EtlJobType, @ClientKey = @ClientKey , @JobName = @Job_AetCom_ExpMbrLoadHist,
		  @ActionStartTime = @DateTime2, @InputSourceName = 'ast.MbrStg2_MbrData', @DestinationName = 'adw.mbrLoadHistory',
		  @ErrorName = 'N/A'                           ;
		  */
    EXEC [adw].[PdwMbr_01_LoadHistory]	 @LoadDate, @LoadType, @ClientKey, @InsertCount = @InsertCountLHist Output;
    /*
    SET @DateTime2 = GETDATE();
    EXEC AceMetaData.amd.sp_AceEtlAudit_Close @Audit_ID = @Audit_ID, @ActionStopTime = @DateTime2, @SourceCount = @Stg2CntMbrDet
		  , @DestinationCount = @InsCntLHist, @ErrorCount = 0, @JobStatus = 1;   
    */
    EXEC [adw].[PdwMbr_02_LoadMember]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountMem	 Output;
    EXEC [adw].[PdwMbr_03_LoadDemo]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountDemo	 Output, @UpdateCount = @UpdateCountDemo OUTPUT;    
    EXEC [adw].[PdwMbr_06_LoadPcp]		 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountPcp	 Output, @UpdateCount = @UpdateCountPcp OUTPUT;
    EXEC [adw].[PdwMbr_30_TermPcp]		 @LoadDate		 , @ClientKey, @TermCount   = @TermedCountPcp	 Output;
    EXEC [adw].[PdwMbr_08_LoadPlan]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountPlan	 Output, @UpdateCount = @UpdateCountPlan OUTPUT;
    EXEC [adw].[PdwMbr_25_TermPlan]	 @LoadDate		 , @ClientKey, @TermCount   = @TermedCountPlan	 Output; 
    
    EXEC [adw].[PdwMbr_09_LoadCsPlan]	 @LoadDate		 , @ClientKey, @InsertCount = @InsertCountCsPlan Output, @UpdateCount = @UpdateCountCsPlan OUTPUT;
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
	EXEC [ACDW_CLMS_AET_TX_COM].[adw].[pdw_Load_FailedMembership]@EffectiveDate
    
    INSERT INTO [amd].[AceMbrLoadLog]
           (ClientKey, [LoadDate], LoadType, [countInsertLoadHist], [countInsertMember], [countInsertDemo]
		 , [countUpdateDemo], [countInsertPhone], [countUpdatePhone],[countInsertAddress]
		 , [countUpdateAddress], [countInsertPcp], [countUpdatePcp], [countInsertPlan]
		 , [countUpdatePlan], [countTermedPlanCnt], [CountInsertCsPlan], [countUpdateCsPlan],
		  [countTermedCsPlanCnt], CountTermedPcp)
     SELECT @ClientKey, @loaddate, @LoadType, @InsertCountLHist , @InsertCountMem, @InsertCountDemo 
	   , @UpdateCountDemo, @InsertCountPhone, @UpdateCountPhone, @InsertCountAdd
	   , @UpdateCountAdd , @InsertCountPcp  , @UpdateCountPcp  , @InsertCountPlan 
	   , @UpdateCountPlan , @TermedCountPlan , @InsertCountCsPlan ,@UpdateCountCsPlan
	   , @TermedCountCsPlan, @TermedCountPcp ;
    
    --EXEC adi.AceValidMbrsAetMaTx


    SELECT * FROM amd.AceMbrLoadLog LoadLog where LoadLog.AceMbrLoadLogKey = @@IDENTITY;

    
    --SELECT * FROM dbo.tvf_Activemembers_Keys('09/18/2020', 9)
    

    -- Commit tran loadAetCom;
    --rollback tran loadAetCom;

    /*

SELECT mbr.ClientMemberKey, stg.*
FROM ast.MbrStg2_MbrData stg
    LEFT JOIN adw.MbrMember mbr ON stg.ClientSubscriberId = mbr.ClientMemberKey
where stg.ClientKey =  9
    and stg.loaddate = '2019-11-19'

    SELECT *
    FROM dbo.vw_ActiveMembers m
    where m.client = 'aetcom'



/* state of Dev Staging */

SELECT s.ClientKey, s.stgRowStatus, s.LoadDate, count(s.mbrStg2_MbrDataUrn) rcnt
FROM ast.MbrStg2_MbrData s
GROUP BY s.ClientKey, s.stgRowStatus, s.LoadDate
ORDER BY s.ClientKey, s.LoadDate DESC, s.stgRowStatus

SELECT s.ClientKey, s.stgRowStatus, s.LoadDate, count(s.mbrStg2_PhoneAddEmailUrn) rcnt
FROM ast.MbrStg2_PhoneAddEmail s
GROUP BY s.ClientKey, s.stgRowStatus, s.LoadDate
ORDER BY s.ClientKey, s.LoadDate DESC, s.stgRowStatus


declare @Ld Date = '2019-09-24'
DECLARE @del int = 1;
SELECT count(*)
FROM ast.MbrStg2_MbrData s
where s.loaddate = @ld;

SELECT count(*)
FROM ast.MbrStg2_PhoneAddEmail s
where s.loaddate = @ld;

--set @del = 2;
if @del = 2
BEGIN 
    delete s FROM ast.MbrStg2_MbrData s	    where s.loaddate = @ld;
    DELETE s FROM ast.MbrStg2_PhoneAddEmail s where s.loaddate = @ld;
END;

*/

/* we have new PCP this month for 9?
SELECT * 
FROM amd.AceMbrLoadLog LoadLog 
where LoadLog.AceMbrLoadLogKey = 45
--select 228 + 78 = 306 pcp rows new, 78 have terms associated

SELECT *
FROM adw.MbrPcp p
    JOIN (SELECT mbr.mbrMemberKey, mbr.ClientMemberKey 
	   FROM adw.MbrMember mbr where mbr.ClientKey = 9) mbr
	   ON p.mbrMemberKey = mbr.mbrMemberKey
where p.CreatedDate >= '10/22/2019'

SELECT mbr.mbrMemberKey, p.*
FROM adw.MbrPlan p
JOIN (SELECT mbr.mbrMemberKey, mbr.ClientMemberKey 
	   FROM adw.MbrMember mbr where mbr.ClientKey = 9) mbr
	   ON p.mbrMemberKey = mbr.mbrMemberKey
where p.CreatedDate >= '10/22/2019'


SELECT p.*
FROM adw.MbrPlan p
    JOIN adw.MbrMember mbr ON p.mbrMemberKey = mbr.mbrMemberKey    
where mbr.mbrMemberKey in (4081,4378,4416,4445,4504,4552,4652,4654,4731,5021,5457,5618,5647,5674,5752,57976138
,12555,12556,12557,12558,12559,12560,12561,12562,12563,12564,12565,12566,12567,12568
,12569,12570,12571,12572,12573,12574,12575,12576,12577,12578,12579,12580,12581,12582
,12583,12584,12585,12586,12587,12588,12589,12590,12591,12592,12593,12594,12595,12596
,12597,12598,12599,12600,12601,12602,12603,12604,12605,12606,12607,12608,12609,12610
,12611,12612,12613,12614,12615,12616,12617,12618,12619,12620,12621,12622,12623,12624
,12625,12626,12627,12628,12629,12630,12631,12632,12633,12634,12635,12636,12637,12638,12639
,12640,12641,12642,12643,12644,12645,12646,12647,12648,12649,12650,12651,12652,12653,12654,12655
,12656,12657,12658,12659,12660,12661,12662,12663,12664,12665,12666,12667,12668,12669,12670,12671,12672
,12673,12674,12675,12676,12677,12678,12679,12680,12681,12682,12683,12684,12685,12686,12687,12688,12689,12690
,12691,12692,12693,12694,12695,12696,12697,12698,12699,12700,12701,12702,12703,12704,12705,12706,12707,12708,12709
,12710,12711,12712,12713,12714,12715,12716,12717,12718,12719,12720,12721,12722,12723,12724,12725,12726,12727,12728,12729
,12730,12731,12732,12733,12734,12735,12736,12737,12738,12739,12740,12741,12742,12743,12744,12745,12746,12747,12748,12749
,12750,12751,12752,12753,12754,12755,12756,12757,12758,12759,12760,12761,12762,12763,12764,12765,12766,12767,12768,12769
,12770,12771,12772,12773,12774,12775,12776,12777,12778,12779,12780,12781,12782)
    AND NOT p.mbrMemberKey in (SELECT p.mbrMemberKey
				FROM adw.MbrPlan p 
				where p.EffectiveDate = '2019-06-01' and p.ExpirationDate = '2019-05-31')
ORDER BY p.mbrMemberKey, p.EffectiveDate asc

/* new plans, plus updated plans */
SELECT p.*
FROM adw.MbrPlan p
    JOIN adw.MbrMember mbr ON p.mbrMemberKey = mbr.mbrMemberKey       
WHERE mbr.ClientKey = 9    
    and p.EffectiveDate = '10/01/2019'
ORDER BY p.mbrMemberKey, p.EffectiveDate asc


SELECT p.*
FROM adw.MbrPcp p
    JOIN adw.MbrMember mbr ON p.mbrMemberKey = mbr.mbrMemberKey    
   /*
    AND NOT p.mbrMemberKey in (SELECT p.mbrMemberKey
				FROM adw.MbrPlan p 
				where p.EffectiveDate = '2019-06-01' and p.ExpirationDate = '2019-05-31')
				*/
WHERE mbr.ClientKey = 9    
    and p.EffectiveDate = '10/01/2019'
ORDER BY p.mbrMemberKey, p.EffectiveDate asc



1. Termed on 5/31, came back
2. Plan Change

*/



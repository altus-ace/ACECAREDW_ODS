CREATE PROCEDURE [adi].[AceValidMbrsWlc_CompareLastLoad]
    (@ShowDetails TINYINT = 1)
AS
    /*
	   this currently only creates data for plans add 
		  memberDemo, CsPlans, PCP, PHones, Address as needed.

		  
		  */
		  
    DECLARE @refreshLoadDates tinyint = 1
    -- get the load dates
    if @refreshLoadDates = 1 
    BEGIN
        IF OBJECT_ID('tempdb..#AdiValMbrEligLoadDates', 'U') IS NOT NULL
    	   DROP TABLE #AdiValMbrEligLoadDates;  
        CREATE TABLE #AdiValMbrEligLoadDates( loadDate date, rowNumber INT primary key not null)
        INSERT INTO #AdiValMbrEligLoadDates (loadDate, rowNumber)
        SELECT ld.*
            ,ROW_NUMBER() OVER (ORDER BY loadDATE desc)  AS arn
        FROM (SELECT loaddate    
        	   FROM adi.MbrWlcMbrByPcp w
        	   GROUP BY loaddate) ld;
    END;

    
    DECLARE @cld DATE; /* Current/Most recent Load Date */
    DECLARE @lld DATE; /* Last Load Date */
    
    SELECT @cld = loadDate FROM #AdiValMbrEligLoadDates	 ld WHERE ld.rowNumber = 1;
    SELECT @lld = loadDate FROM #AdiValMbrEligLoadDates	 ld WHERE ld.rowNumber = 2;
    
    SELECT ll.LastLoadDate, ll.MbrCount LastMemberCount, cl.CurrentLoadDate, cl.MbrCount CurrentMemberCount, (cl.MbrCount - ll.MbrCount ) DifferencePriorMnthToCurMnth
    FROM (SELECT @lld AS LastLoadDate, COUNT(ll.mbrWlcMbrByPcpKey) as MbrCount
		  FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@lld) ll
		  where ll.BestMemberRow = 1) ll
	   JOIN (SELECT @cld AS CurrentLoadDate, COUNT(ll.mbrWlcMbrByPcpKey) as MbrCount
			 FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@cld) ll
			 where ll.BestMemberRow = 1) cl 
	   ON 1 =1 
    
       
    /* XXXXXXXXXXXXX Termed: Existed on last load, not on current load XXXXXXXXXXXXX*/    
    IF @ShowDetails = 1 
    BEGIN 
	   SELECT distinct ll.SEQ_Mem_ID AS ClientMemberKey, 'Termed Members'as ChangeSet   
	   FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@lld) ll    
	   WHERE ll.BestMemberRow = 1
	   EXCEPT
	   SELECT distinct cl.SEQ_Mem_ID AS ClientMemberKey, 'Termed Members'as ChangeSet    
	   FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@cld) cl    
	   WHERE cl.BestMemberRow = 1
	   ;

	   /* XXXXXXXXXXXXX New: Exists on current load, not on prior load XXXXXXXXXXXXX */
	   SELECT distinct cl.SEQ_Mem_ID AS ClientMemberKey, 'New Members'as ChangeSet    
	   FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@cld) cl    
	   WHERE cl.BestMemberRow = 1
	   EXCEPT
	   SELECT distinct ll.SEQ_Mem_ID AS ClientMemberKey, 'New Members'as ChangeSet    
	   FROM adi.tvf_PdwSrc_Wlc_MemberByPcp(@lld) ll    
	   WHERE ll.BestMemberRow = 1
	   ;
    END;
    IF @ShowDetails = 1
	   SELECT 'Use Stored Proc: adi.AceValidMbr_Wlc with a above id to explore details.' AS [HowToUse], 'DifferencePriorMnthToCurMnth sum of the count of New Members and the count of Termed Members' As ValidationDetails;


CREATE PROCEDURE [adi].[AceValidMbrsUhc_CurLoadControlCounts] 
    @NumberOfLoadsOut INT = 1
AS 
    DECLARE @NumLoadToOutput int = @NumberOfLoadsOut; -- sets the number of LoadDates back will be in the result set.
    /* this gets the last load counts for UHC
    Mbrs By  Pcp
    Mbrs By Pcp By Plan
    Member Summary
    New Members
    '
    */
    -- After Load: Get count by load date
    SELECT 'Uhc_MembersByPcp' as aTable, m.A_LAST_UPDATE_DATE, COUNT(urn)
    FROM dbo.UHC_MembersByPCP m
            JOIN (select m.A_LAST_UPDATE_DATE LoadDate
    				, ROW_NUMBER() over (ORDER BY m.A_LAST_UPDATE_DATE desc) aRN
    				FROM dbo.UHC_MembersByPCP m 
    				GROUP BY m.A_LAST_UPDATE_DATE) aLD ON m.A_LAST_UPDATE_DATE = aLD.LoadDate and aLD.arn <= @NumLoadToOutput
    GROUP BY m.A_LAST_UPDATE_DATE
    ORDER BY m.A_LAST_UPDATE_DATE desc;
    
    -- After Load Get count members by plan type
    SELECT 'Uhc_MembersByPcp' as aTable, m.A_LAST_UPDATE_DATE, SUBSTRING(m.PLAN_ID, 1, 4) planType, COUNT(m.URN)
    FROM dbo.UHC_MembersByPCP m
        JOIN (select m.A_LAST_UPDATE_DATE LoadDate
    				, ROW_NUMBER() over (ORDER BY m.A_LAST_UPDATE_DATE desc) aRN
    				FROM dbo.UHC_MembersByPCP m 
    				GROUP BY m.A_LAST_UPDATE_DATE) aLD ON m.A_LAST_UPDATE_DATE = aLD.LoadDate and aLD.arn <= @NumLoadToOutput
    GROUP BY m.A_LAST_UPDATE_DATE, SUBSTRING(m.PLAN_ID, 1, 4)
    WITH ROLLUP;
    
    -- after load count Membership:
    SELECT 'Uhc_Membership' as aTable, m.A_LAST_UPDATE_DATE,  m.Line_Of_Business, COUNT(m.URN)
    FROM dbo.UHC_Membership m
        JOIN (select m.A_LAST_UPDATE_DATE LoadDate
    				, ROW_NUMBER() over (ORDER BY m.A_LAST_UPDATE_DATE desc) aRN
    				FROM dbo.UHC_Membership m 
    				GROUP BY m.A_LAST_UPDATE_DATE) aLD ON m.A_LAST_UPDATE_DATE = aLD.LoadDate and aLD.arn <= @NumLoadToOutput
    GROUP BY m.A_LAST_UPDATE_DATE,  m.Line_Of_Business
    WITH ROLLUP;
    
    -- after load count New members
    SELECT aLD.LoadDate, COUNT(p.URN) cntNewMbrs
    FROM cc.dbo.p11 p
        JOIN (select p.lst_UPdate_date as LoadDate
    				, ROW_NUMBER() over (ORDER BY p.lst_UPdate_date desc) aRN
    				FROM cc.dbo.P11 p
    				GROUP BY p.lst_UPdate_date) aLD ON p.lst_UPdate_date = aLD.LoadDate and aLD.arn <= @NumLoadToOutput
    GROUP BY aLD.LoadDate
    WITH ROLLUP;
    
    SELECT 'ClinicalSystem Plan History' CntType , COUNT(DISTINCT m.A_ALT_MemberPlanHistory_ID) csPlanCount, COUNT(DISTINCT m.Client_Member_ID) ClientCnt   
	   , 'The two counts should be equal.' as Explain
    FROM adw.A_ALT_MemberPlanHistory m
    WHERE (SELECT MAX(a_last_update_date) FROM dbo.UHC_MembersByPCP m) between m.startDate and m.stopDate
	   AND m.planHistoryStatus = 1
   

    -- If rows with invalid Subscriber Ids are added (ie rows from file are read that are empty )
    -- delete rows with null subscriber id 
    /*
    begin tran clnInvalidUhcSubscriberID
    MERGE dbo.Uhc_MembersByPcp trg
    USIng(SELECT urn
    	   From dbo.UHC_MembersByPCP m
    	   where isnull(m.UHC_SUBSCRIBER_ID, '')  = '') src
    ON trg.urn= src.urn
    when matched then 
        delete ;
    commit tran clnInvalidUhcSubscriberID;
    */
    

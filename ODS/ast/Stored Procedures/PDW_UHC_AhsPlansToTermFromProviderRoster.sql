--TERM UHC AHS Plan Records for PROVIDER ROSTER EXCLUSION
CREATE  PROCEDURE ast.PDW_UHC_AhsPlansToTermFromProviderRoster
    ( @LoadDate date )
AS 
BEGIN
    /* get dates */
    --declare @LoadDate date = getdate();
    DECLARE @AsOfDate date = @LoadDate;
    DECLARE @NewTermDate DATE = DATEADD(day, -1, DATEFROMPARTS(YEAR(@AsOfDate), MONTH(@AsOfDate), 1));
    
    --SELECT @AsOfDate ,@NewTermDate

    /* -- when done these 2 numbers should be the same 
    SELECT count(DISTINCT am.CLIENT_SUBSCRIBER_ID) from dbo.vw_ActiveMembers am where am.clientKey = 1
    SELECT COUNT(*)
    FROM adw.A_ALT_MemberPlanHistory ph
    WHERE getdate() between ph.startDate and ph.stopDate 
        and ph.planHistoryStatus = 1
    -- truncate table ast.TmpAhsPlansToTerm
    SELECT * FROM ast.TmpAhsPlansToTerm
    */
    /* get Working set */
    
    INSERT INTO ast.TmpAhsPlansToTerm(A_ALT_MemberPlanHistory_ID,Client_Member_ID, startDate, stopDate, planHistoryStatus,NewTermDate)
    SELECT aph.A_ALT_MemberPlanHistory_ID, aph.Client_Member_ID, aph.startDate, aph.stopDate, aph.planHistoryStatus, @NewTermDate NewTermDate
    FROM adw.A_ALT_MemberPlanHistory APH
	   JOIN dbo.Uhc_MembersByPcp CurMembers
	      ON APH.Client_Member_ID = CurMembers.UHC_SUBSCRIBER_ID
	   	  AND CurMembers.A_LAST_UPDATE_FLAG = 'Y'
	   LEFT JOIN (SELECT pr.TIN
	   	  FROM dbo.vw_AllClient_ProviderRoster pr
	   	  WHERE pr.CalcClientKey = 1
	   		 AND @AsOfDate BETWEEN pr.EffectiveDate and pr.ExpirationDate
	   	  GROUP BY pr.TIN
	   	  ) PR ON CurMembers.PCP_PRACTICE_TIN = pr.TIN
    WHERE getdate() between aph.startDate and aph.stopDate
	   and aph.planHistoryStatus = 1
	   AND pr.TIN is null
    ;
    begin tran UpdateUhcAhsPlans
    /* Newly created  SET History to 0 and set termdate */ 
    --SELECT t.*
    update ph set ph.planHistoryStatus = 0 , ph.stopDate = t.NewTermDate
    FROM ast.TmpAhsPlansToTerm t
        JOIN adw.A_ALT_MemberPlanHistory PH ON t.A_ALT_MemberPlanHistory_ID = ph.A_ALT_MemberPlanHistory_ID
    where t.UpdateStatus = 0 and t.NewTermDate < t.startDate
    /* aready existed SET term date only*/
    --SELECT t.*
    UPDATE ph set ph.stopDate = t.NewTermDate
    FROM ast.TmpAhsPlansToTerm t
        JOIN adw.A_ALT_MemberPlanHistory PH ON t.A_ALT_MemberPlanHistory_ID = ph.A_ALT_MemberPlanHistory_ID
    where t.UpdateStatus = 0 and t.NewTermDate > t.startDate
    
    /* update working table */
    --SELECT *
    UPDATE t SET t.UpdateStatus = 1
    FROM ast.TmpAhsPlansToTerm T
        JOIN adw.A_ALT_MemberPlanHistory PH ON t.A_ALT_MemberPlanHistory_ID = ph.A_ALT_MemberPlanHistory_ID
    where t.UpdateStatus = 0 
        and t.NewTermDate = ph.stopDate
    ;
    --COMMIT tran UpdateUhcAhsPlans
END;

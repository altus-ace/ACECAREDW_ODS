
Create View dbo.[zz_vw_ACE_Validation_Chk_UHC_ActiveMemberToCsPlans]
AS 
    
    /*Compare Active Members to Currently active CS Plans (alt plans) */
    SELECT UHC_SUBSCRIBER_ID , 'vw_UHC_ActiveMembers' AS  InvalidSource
    FROM dbo.vw_UHC_ActiveMembers m
    Except
    SELECT  m.Client_Member_ID, 'vw_UHC_ActiveMembers'
    FROM adw.A_ALT_MemberPlanHistory m
    where (SELECT max(a_Last_update_date) from dbo.Uhc_MembersByPcp) between m.startDate and m.stopDate
        and planHistoryStatus =1 
    UNION
    /* compare Currently active CS Plans (alt plans) to Active Members */
    SELECT  m.Client_Member_ID, 'A_ALT_MemberPlanHistory' AS  InvalidSource
    FROM adw.A_ALT_MemberPlanHistory m
    where (SELECT max(a_Last_update_date) from dbo.Uhc_MembersByPcp) between m.startDate and m.stopDate
        and planHistoryStatus =1 
    EXCEPT
    SELECT UHC_SUBSCRIBER_ID , 'A_ALT_MemberPlanHistory'
    FROM dbo.vw_UHC_ActiveMembers m
    
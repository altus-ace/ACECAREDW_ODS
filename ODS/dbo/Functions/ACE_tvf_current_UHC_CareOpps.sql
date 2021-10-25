
CREATE FUNCTION [dbo].[ACE_tvf_current_UHC_CareOpps]
 
(	@anchor_mth int,@anchor_year int
)
RETURNS TABLE 
As
RETURN
(	
select 
a.MemberID,
a.NameFirst,
a.NameLast,
a.DOB,
a.TIN_Num,
d.[GROUP NAME],
a.ProviderID,
a.Provider_NPI,
a.Prov_Last_Name,
a.Prov_First_Name,
a.ACE_MEMBER,
a.[AWC(Default)],
a.[CDC1 HbA1c<8%],
a.[PPC Postpartum Care],
a.[PPC Prenatal Care],
a.[WC3456(Default)],
a.[BCS(Default)],
a.[CCS2(Default)],
a.[FUH 7-Day Follow-Up],
a.[WC015(6orMoreVisits)],
b.MEMBER_HOME_PHONE,
b.MEMBER_MAIL_PHONE,
case when c.uhc_subscriber_id is null then 'NO' else 'YES' end as NEW_MEMBER
FROM [ACECAREDW].[dbo].[vw_current_UHC_CareOpps] a
join [ACECAREDW].[dbo].[vw_UHC_ActiveMembers] b on a.memberID = b.Member_id
left join (SELECT 

distinct e2.UHC_SUBSCRIBER_ID
FROM (SELECT  DENSE_RANK ( )OVER( ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
		
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		) e1
 right join (SELECT  DENSE_RANK ( )OVER(ORDER BY A_LAST_UPDATE_DATE ASC)  as date_order 
	
		, UHC_SUBSCRIBER_ID
		, A_LAST_UPDATE_DATE		
		FROM            dbo.UHC_MembersByPCP
		)  e2 
on month(e1.A_LAST_UPDATE_DATE) = month(e2.A_LAST_UPDATE_DATE)-1
and e1.UHC_SUBSCRIBER_ID = e2.UHC_SUBSCRIBER_ID
where month(e2.A_LAST_UPDATE_DATE) = month(getdate())
and e1.UHC_SUBSCRIBER_ID is null
)c on a.MemberID = c.UHC_SUBSCRIBER_ID
left join (select distinct [TAX ID], [GROUP NAME] from [ACECAREDW].[dbo].[vw_UHC_ProviderRoster] )d 
on case when len(a.TIN_Num)=8 then concat('0',a.TIN_Num) else a.TIN_Num end = d.[TAX ID]
where update_month = @anchor_mth and Update_year= @anchor_year
)

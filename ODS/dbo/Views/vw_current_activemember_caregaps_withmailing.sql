

CREATE view [dbo].[vw_current_activemember_caregaps_withmailing] as
SELECT  [MemberID]
	  ,case when c.uhc_subscriber_id is null then 'NO' else 'YES' end as NEW_MEMBER
      ,[update_month]
      ,[NameFirst]
      ,[NameLast]
	  ,case when e.MEMBER_ADDRESS is null then rtrim(b.MEMBER_HOME_ADDRESS) + ' ' + rtrim(b.MEMBER_HOME_ADDRESS2) else e.MEMBER_ADDRESS end as MEMBER_ADDRESS
	  ,case when e.MEMBER_CITY is null then b.MEMBER_HOME_CITY else e.MEMBER_CITY end as MEMBER_CIT
      ,case when e.MEMBER_STATE is null then b.MEMBER_HOME_STATE else e.MEMBER_STATE end as MEMBER_STATE
      ,case when e.MEMEBR_ZIP is null then b.MEMBER_HOME_ZIP_C else e.MEMEBR_ZIP end as MEMBER_ZIP
	  ,b.[MEMBER_HOME_PHONE]
	  ,[Prov_Last_Name]
      ,[Prov_First_Name]
	  ,b.PCP_ADDRESS
	  ,b.[PCP_ADDRESS2]
	  ,b.[PCP_CITY]
	  ,b.[PCP_STATE]
	  ,b.[PCP_ZIP_C]
	  ,b.PCP_PHONE
      ,[DOB]
      ,[TIN_Num]
      ,[ProviderID]
      ,[Provider_NPI]
      ,[AWC(Default)]
      ,[CDC1 HbA1c<8%]
      ,[PPC Postpartum Care]
      ,[PPC Prenatal Care]
      ,[WC3456(Default)]
      ,[BCS(Default)]
      ,[CCS2(Default)]
      ,[FUH 7-Day Follow-Up]
  FROM [ACECAREDW].[dbo].[vw_current_UHC_CareOpps] a
  join ACECAREDW.dbo.vw_UHC_ActiveMembers b on a.MemberID = b.member_id
  left join (SELECT * FROM [Ahs_Altus_Prod].[dbo].ACE_VW_RP_WelcomeLetter ) e on a.MemberID = e.MEMBER_ID
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
  where update_month = month(getdate())

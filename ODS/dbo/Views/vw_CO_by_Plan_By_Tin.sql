create view vw_CO_by_Plan_By_Tin
as
SELECT  distinct
           [QmMsrID],
	       [QM_DESC],
           [Member_ID],
		   b.MEMBER_FIRST_NAME as [NameFirst],
           b.MEMBER_LAST_NAME  as [NameLast],

		   b.DESTINATION_VALUE,

		   b.MEDICAID_ID,
           convert(date,b.DATE_OF_BIRTH,101) AS DOB,
           [Gender],
		   CASE WHEN b.MEMBER_HOME_PHONE ='' THEN '' ELSE  SUBSTRING('('+b.MEMBER_HOME_PHONE, 1, 4) + ')' +  SUBSTRING(b.MEMBER_HOME_PHONE, 4, 3) + '-' +   SUBSTRING(b.MEMBER_HOME_PHONE, 7, 4) END as [Member_Phone],
           b.PCP_PRACTICE_TIN                              as [TIN_Num],
           d.[PRACTICE NAME]                                              as [TIN_Name],
           b.PCP_LAST_NAME     as               [Prov_Last_Name],
           b.PCP_FIRST_NAME                   as            [Prov_First_Name],
           [QMDate] as [A_LAST_UPDATE_DATE]

      
  FROM (select * from 
acecaredw.[adw].[QM_ResultByMember_History] where case when qmmsrid = 'UHC_CDC_G_9' and qmcntcat = 'NUM' then 'COP'
when qmmsrid = 'UHC_CDC_G_9' and qmcntcat = 'COP' then 'NUM'

 else qmcntcat end = 'COP' and qmdate = (select max(qmdate) from acecaredw.[adw].[QM_ResultByMember_History] )
) a
  join 
  (select  a.*, b.* from [vw_UHC_ActiveMembers] a left join (select distinct SOURCE_VALUE, MeasureID , destination_value from 
[ACECAREDW].[lst].[lstCareOpToPlan] a left join (SELECT source_value, DESTINATION_VALUE
  FROM [ACECAREDW].[dbo].[ALT_MAPPING_TABLES]) b on a.CsPlan = b.DESTINATION_VALUE where measureID not in ('unkn_UHC'))  b on a.SUBGRP_ID = b.SOURCE_VALUE   
) b on a.clientMemberKey = b.member_id and a.QmMsrId = b.MeasureID
   join  
[ACECAREDW].[lst].[LIST_QM_Mapping] c on a.QmMsrId = c.qm
left join 
(
    SELECT DISTINCT
           [Tax id],
           [PRACTICE NAME]
    FROM [ACECAREDW].[dbo].[vw_NetworkRoster]
) d ON CONVERT(INT, b.PCP_PRACTICE_TIN  ) = CONVERT(INT, d.[TAX ID])

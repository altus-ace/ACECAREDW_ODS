CREATE view tmp_vw_PCP_Visits_2018_uHC_Mbrship
As
select  
distinct mbr.uhc_subscriber_id
,concat (Month(convert(date,mbr.A_LAST_UPDATE_DATE)), '-',YEar(convert(date,mbr.A_LAST_UPDATE_DATE))) as Member_Mth
,case when ch.primary_svc_date is null then 'NO' else 'YES' end as PCP_Visit
from [dbo].[UHC_MembersbyPCP] mbr

left join [ACECAREDW_TEST].[dbo].[Claims_Headers] CH on mbr.UHC_SUBSCRIBER_ID = CH.SUBSCRIBER_ID   
and CH.PRIMARY_SVC_DATE between '2018-01-01' and '2018-12-31'
 left join ACECAREDW_TEST.dbo.Claims_Details CD on CH.CLAIM_NUMBER = CD.CLAIM_NUMBER and CD.PROCEDURE_CODE IN ('99201', '99202', '99203', '99204', '99205', '99211', '99212', '99213'
                                                     , '99214', '99215', '99304', '99305', '99306', '99307', '99308', '99309'
                                                     , '99310', '99315', '99316', '99318', '99324', '99325', '99326', '99327'
                                                     , '99328', '99334', '99335', '99336', '99337', '99339', '99340', '99341'
                                                     , '99342', '99343', '99344', '99345', '99347', '99348', '99349', '99350'
                                                     , 'G0402', 'G0438', 'G0439', 'G0463')
where convert(DATE, mbr.[A_LAST_UPDATE_DATE]) between '2018-01-01' and '2018-12-31'












CREATE view [dbo].[zz_vw_ACE_Validation_Chk_UHC_MembersbyPCP]
AS
Select * , Sum([TX-STAR]+[TX-STAR PREGNANT WOMEN]+[TX-CHIP]+[TX-STAR+PLUS]+[TX-CHIP PREGNANT WOMEN]+[N/A]) as TOTAL_MEMBERS
from(
select  A_LAST_UPDATE_DATE
,LOADTYPE
,[TX-STAR] 
,[TX-STAR PREGNANT WOMEN]
,[TX-CHIP]
,[TX-STAR+PLUS]
,[TX-CHIP PREGNANT WOMEN]
,[N/A]
from (
select  UHC_SUBSCRIBER_id ,c.A_last_update_date,c.a_last_update_flag
,C.LoadType
,c.member_term_Date
,CASE WHEN mp.DESTINATION_VALUE IS NULL THEN 'N/A' ELSE MP.DESTINATION_VALUE END as plan_name
 from UHC_Membersbypcp c 

 LEFT join ALT_MAPPING_TABLES mp on mp.source_value=c.SUBGRP_ID and mp.DESTINATION='ALTRUISTA' and mp.source='UHC' and mp.tYPE='PLAN CODE'
) as p
Pivot
(
count(p.UHC_subscriber_id) for Plan_name in ([TX-STAR] ,[TX-STAR Pregnant Women],[TX-CHIP],[TX-STAR+PLUS],[TX-CHIP PREGNANT WOMEN],[N/A]) )as pvt) as s
Group by 
 A_LAST_UPDATE_DATE
--,A_LAST_UPDATE_FLAG
,LOADTYPE
,[TX-STAR] 
,[TX-STAR PREGNANT WOMEN]
,[TX-CHIP PREGNANT WOMEN]
,[TX-CHIP]
,[TX-STAR+PLUS]
,[N/A]

--order by A_LAST_UPDATE_date









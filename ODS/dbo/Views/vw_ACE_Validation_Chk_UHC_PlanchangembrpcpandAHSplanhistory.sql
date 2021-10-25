CREATE view [vw_ACE_Validation_Chk_UHC_PlanchangembrpcpandAHSplanhistory]
as 
select cc.cur_id,cc.cur_plan,cc.old_plan from (
SELECT pp.uhc_subscriber_id as cur_id,
           ss.destination_value AS  cur_plan,
		 c.old_id,
		 c.old_plan,
		 case when ss.DESTINATION_VALUE <> c.old_plan then 1 else 0 end as planchange,
		 case when old_id is null then 1 else 0 end as newmem
    FROM uhc_membersbypcp pp
         INNER JOIN [ALT_MAPPING_TABLES] ss ON ss.source_value = pp.subgrp_id
                                               AND source = 'UHC'
                                               AND ss.destination = 'ALTRUISTA'
									    and ss.URN not between 61 and 71
left join ( 
SELECT pp1.uhc_subscriber_id as old_id,
           ss1.destination_value  AS old_plan
    FROM uhc_membersbypcp pp1
         INNER JOIN [ALT_MAPPING_TABLES] ss1 ON ss1.source_value = pp1.subgrp_id
                                               AND source = 'UHC'
                                               AND ss1.destination = 'ALTRUISTA'
									  and ss1.URN not between 61 and 71

    WHERE MONTH(pp1.A_LAST_UPDATE_DATE)=MONTH(getdate())-1 and YEAR(pp1.A_LAST_UPDATE_DATE)=YEAR(getdate()) and pp1.LoadType='S') as c on c.old_id=pp.UHC_SUBSCRIBER_ID

    
    WHERE pp.a_last_update_flag = 'Y' and pp.LoadType='p'

    )as cc
    where cc.planchange=1  and cc.cur_id not in (select  Client_Member_ID from [adw].[A_ALT_MemberPlanHistory]
    where  convert(date,stopdate)='12-31-2099'-- and planHistoryStatus=1  -- and  Client_Member_ID='109418594'
    and client_member_id in (
    SELECT distinct client_member_id
      
FROM [adw].[A_ALT_MemberPlanHistory]
where CONVERT(date,stopdate) =convert(date,DATEADD(day,-day(getdate()),GETDATE())))) 
   


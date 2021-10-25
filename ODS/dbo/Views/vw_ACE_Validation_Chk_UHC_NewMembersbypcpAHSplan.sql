

CREATE view [dbo].[vw_ACE_Validation_Chk_UHC_NewMembersbypcpAHSplan]
as
select cc.cur_id,cc.cur_plan,h.client_Member_id,h.startdate 
from (
SELECT pp.uhc_subscriber_id as cur_id,
           ss.destination_value AS  cur_plan,
		 c.old_id,
	
		 case when old_id is null then 1 else 0 end as newmem
    FROM uhc_membersbypcp pp
         INNER JOIN [ALT_MAPPING_TABLES] ss ON ss.source_value = pp.subgrp_id
                                               AND source = 'UHC'
                                               AND ss.destination = 'ALTRUISTA'
									    and ss.URN not between 61 and 71
left join ( 
SELECT distinct pp1.uhc_subscriber_id as old_id,
           ss1.destination_value  AS old_plan
    FROM uhc_membersbypcp pp1
         INNER JOIN [ALT_MAPPING_TABLES] ss1 ON ss1.source_value = pp1.subgrp_id
                                               AND source = 'UHC'
                                               AND ss1.destination = 'ALTRUISTA'
									  and ss1.URN not between 61 and 71

    WHERE MONTH(pp1.A_LAST_UPDATE_DATE)=MONTH(getdate())-1 and YEAR(pp1.A_LAST_UPDATE_DATE)=YEAR(getdate()) ) as c on c.old_id=pp.UHC_SUBSCRIBER_ID

    
    WHERE pp.a_last_update_flag = 'Y' and pp.LoadType='p'

    )as cc
    left join
    (SELECT  Client_member_id,startdate
      
FROM [adw].[A_ALT_MemberPlanHistory] where getdate() between startdate and stopdate and planhistorystatus=1 ) h on h.Client_Member_id=cc.cur_id
    where cc.newmem=1 and convert(date,h.startdate) <> convert(date,dateadd(day,-day(GETDATE())+1,GETDATE()))


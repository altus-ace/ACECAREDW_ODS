
CREATE view vw_new_members_since_052018
as
select c.member_id , d.[phoneNumber] from (
SELECT distinct b.[MEMBER_ID]

  FROM [ACECAREDW].[dbo].[vw_uhc_active_members_all_first_load] b
  where b.date >= '2018-05-01'
  except
  SELECT distinct a.[MEMBER_ID]
   
  FROM [ACECAREDW].[dbo].[vw_uhc_active_members_all_first_load] a 
  where date <= '2018-04-01'
)c left join 
(select * from 

(

select *, row_number() over (partition by clientMemberKey order by  [mbrPhoneMobileValidationKey] desc) as rank 
from (select * from [AceCareDw_Qa].[adw].[mbrPhoneMobileValidation2] where carrier_type = 'Mobile') b)c
 where c.rank=1)d on c.member_id = d.[ClientMemberKey]
where d.phoneNumber is not null



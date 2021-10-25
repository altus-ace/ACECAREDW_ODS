
CREATE view 

 dbo.VW_TMP_NEW2PCP_2019
as
select a.* from (select distinct UHC_SUBSCRIBER_ID,MEMBER_CONT_EFF_DATE,MEMBER_ORG_EFF_DATE,MEMBER_CUR_TERM_DATE, PCP_EFFECTIVE_DATE, A_LAST_UPDATE_DATE, ROW_NUMBER() over(partition by UHC_SUbscriber_id order by A_LAST_UPDATE_DATE asc)  as rnk
from UHC_MembersByPCP 
) a 
inner join vw_uhc_activemembers b on b.uhc_subscriber_id = a.uhc_subscriber_id
where a.rnk = 1







	 CREATE view [dbo].[VW_RP_UHC_NewAndNewPrenatalMemberPannel]
	 as
	

(

SELECT p.UHC_SUBSCRIBER_ID,
       p.MEMBER_FIRST_NAME,
       p.MEMBER_MI,
       p.MEMBER_LAST_NAME,
       p.MEDICAID_ID,
       p.DATE_OF_BIRTH,
       p.GENDER,
       p.PCP_FIRST_NAME,
       p.PCP_LAST_NAME,
       p.PCP_NPI,
       p.PCP_PRACTICE_TIN,
       p.PCP_PRACTICE_NAME,
       p.AUTO_ASSIGN,
--       p.MEMBER_STATUS,
--       p.MEMBER_TERM_DATE,
--	    p.MEMBER_CUR_EFF_DATE,
--	  p.MEMBER_ORG_EFF_DATE,
	  p.a_last_update_date as Report_As_Of,
	  m.Destination_value as [PLAN]
	  --P.SUBGRP_ID,
	  --P.SUBGRP_NAME

FROM UHC_MembersByPCP p
left join [ACECAREDW].[dbo].[ALT_MAPPING_TABLES] m on m.source_value = p.subgrp_id
WHERE  month(p.a_last_update_date) in ( month(getdate()
	 )) and year(p.a_last_update_date) = YEAR(getdate())
	and month(p.MEMBER_ORG_EFF_DATE) in ( month(getdate()
	)) and year(p.MEMBER_ORG_EFF_DATE) = YEAR(getdate())
	 );





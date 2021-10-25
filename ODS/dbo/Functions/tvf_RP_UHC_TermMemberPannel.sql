



	 CREATE FUNCTION [dbo].[tvf_RP_UHC_TermMemberPannel](@month int,@year int)
RETURNS TABLE
AS
    RETURN
(
	select UHC_SUBSCRIBER_ID as SUBSCRIBER_ID,
       MEMBER_FIRST_NAME,
       MEMBER_MI,
       MEMBER_LAST_NAME,
       MEDICAID_ID,
       DATE_OF_BIRTH,
       GENDER,
       PCP_FIRST_NAME,
       PCP_LAST_NAME,
       PCP_NPI,
       PCP_PRACTICE_TIN,
       PCP_PRACTICE_NAME,
       AUTO_ASSIGN from (
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
       p.MEMBER_STATUS,
       p.MEMBER_TERM_DATE,
	  p.a_last_update_date,
	  mp.UHC_SUBSCRIBER_ID as term,
	  mp.a_last_update_date as term_date
FROM UHC_MembersByPCP p
left join ( 
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
      -- p.MEMBER_STATUS,
   --  p.MEMBER_TERM_DATE,
	  p.a_last_update_date
FROM UHC_MembersByPCP p
WHERE LoadType = 'P'
     -- AND SUBGRP_ID NOT IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
	 and month(p.a_last_update_date) = @month and year(p.a_last_update_date)=@year) as mp on convert(int,mp.uhc_subscriber_id)=convert(int,p.UHC_Subscriber_id)
WHERE LoadType = 'P'
    --  AND SUBGRP_ID NOT IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
	 and month(p.a_last_update_date)  in (case when @month-1=0 then 12 else @month-1 end) 
	 and year(p.a_last_update_date) in  (case when @month-1=0 then (@year-1) else @year end) --and p.UHC_SUBSCRIBER_ID='117246368'
) as s where s.term is null
);






	 CREATE FUNCTION [dbo].[tvf_RP_UHC_NewAndNewPrenatalMemberPannel](@month int,@year int)
RETURNS TABLE
AS
   RETURN
 -- Declare @month int,@year int
 -- set @month=3
 --set @year=2019
(
select distinct 	Ltrim(rtrim(Upper(P.UHC_SUBSCRIBER_ID))) as MEMBER_ID,
		Ltrim(rtrim(Upper(p.MEMBER_FIRST_NAME))) AS MEMBER_FNAME,
		Ltrim(rtrim(Upper(p.MEMBER_MI))) AS MEMBER_MI,
        Ltrim(rtrim(Upper(p.MEMBER_LAST_NAME))) AS MEMBER_LN,
        Ltrim(rtrim(Upper(p.MEDICAID_ID))) AS MEDCAID_ID,
        Ltrim(rtrim(Upper(p.DATE_OF_BIRTH))) AS DOB,
        Ltrim(rtrim(Upper(p.GENDER))) AS GENDER,
        Ltrim(rtrim(Upper(p.PCP_FIRST_NAME))) AS PCP_FNAME,
        Ltrim(rtrim(Upper(p.PCP_LAST_NAME))) AS PCP_LNAME,
        Ltrim(rtrim(Upper(p.PCP_NPI))) AS PCP_NPI,
		case when p.PCP_PRACTICE_TIN = '043751219' then '43751219' else p.PCP_PRACTICE_TIN end as PCP_PRACTICE_TIN,
        Ltrim(rtrim(Upper(p.PCP_PRACTICE_NAME))) as PCP_PRACTICE,
        Ltrim(rtrim(Upper(p.AUTO_ASSIGN))) AS ASSIGNEMENT,
	    Concat(Ltrim(rtrim(Upper(month(p.PCP_EFFECTIVE_DATE)))),'-',Ltrim(rtrim(Upper(year(p.PCP_EFFECTIVE_DATE))))) AS MEMBER_EFF_DATE
 from acecaredw.dbo.UHC_membersbyPCP p
 --inner join acecaredw.dbo.vw_uhc_activemembers b on b.uhc_subscriber_id = p.uhc_subscriber_id
WHERE  month(P.A_LAst_update_date) = @month and year(P.A_LAst_update_date)=@year
--and month(MEMBER_ORG_EFF_DATE) = (@month) and year(MEMBER_ORG_EFF_DATE)=@year
and p.LoadType = 'P'
and month(convert(date,p.PCP_EFFECTIVE_DATE)) = @month and Year(convert(date,p.PCP_EFFECTIVE_DATE)) = @year
)

;







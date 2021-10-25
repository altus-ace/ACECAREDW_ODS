





CREATE FUNCTION [dbo].[tvf_RP_Scripts_Mnthly_Stats] (
	--@year int
	--,@month int 
	)
RETURNS TABLE 
AS RETURN
 -- Declare @month int,@year int
 -- set @month=5
 --set @year=2019
(

	           SELECT DISTINCT
					 lob.LOB_NAME,
                                 PD.CLIENT_PATIENT_ID,
                                 convert(date,srl.END_DATE,101) as End_Date,
                                 srs.VALUE as Status,
                                 sas.SCRIPT_NAME,
                                 concat(csd.FIRST_NAME,' ',csd.LAST_NAME) as Care_Staff_Name                                
                     FROM [Ahs_Altus_Prod].[dbo].[PATIENT_DETAILS] PD
                      JOIN [Ahs_Altus_Prod].[dbo].[SCPT_PATIENT_SCRIPT_RUN_LOG] srl on pd.patient_id = srl.patient_id
                      join [Ahs_Altus_Prod].[dbo].[SCPT_PATIENT_SCRIPT_RUN_LOG_DETAIL] srld on srld.SCRIPT_RUN_LOG_ID = srl.SCRIPT_RUN_LOG_ID
                      JOIN [Ahs_Altus_Prod].[dbo].[SCPT_SCRIPT_RUN_STATUS] srs on srs.STATUS_ID = srl.STATUS_ID
                      join [Ahs_Altus_Prod].[dbo].[SCPT_ADMIN_SCRIPT] sas on sas.SCRIPT_ID = srld.SCRIPT_ID
                      join [Ahs_Altus_Prod].[dbo].[CARE_STAFF_DETAILS] csd on csd.MEMBER_ID = srl.STAFF_ID
                      JOIN ahs_altus_prod.dbo.MEM_BENF_PLAN AS mbp on mbp.member_id = pd.patient_id
                      JOIN ahs_altus_prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID
                      JOIN ahs_altus_prod.dbo.BENEFIT_PLAN AS bpl ON lbp.BENEFIT_PLAN_ID = bpl.BENEFIT_PLAN_ID
              join ahs_altus_prod.dbo.lob as LOB on lob.lob_id = lbp.lob_ID
		where 
		--year(srld.RESPONSE_TIME_TO) = @year
		--and month(srld.RESPONSE_TIME_TO) = @month
		CLIENT_PATIENT_ID not like ('ALT%')
		and csd.ROLE_ID in ('25','14','9')
		and csd.FIRST_NAME not in ('Tonya', 'Wendy')
		--and srl.STATUS_ID not in (3,5)   --To remove Cancelled-3 and Inactive-5

)



CREATE VIEW [dbo].[VW_RPT_1444_Letter_run_Stats]
AS

SELECT lob.LOB_name
	  ,pd.CLIENT_PATIENT_ID
      ,[TEMPLATE_CONTENT] as Letter_Name
      ,convert(date,lq.[CREATED_ON],101) as Run_Date
	  ,concat(csd.FIRST_NAME,' ',csd.LAST_NAME) as Care_Staff_Name 
  FROM [Ahs_Altus_Prod].[dbo].[LETTER_QUEUE]lq
  join [Ahs_Altus_Prod].[dbo].[CARE_STAFF_DETAILS] csd on lq.CREATED_BY = csd.MEMBER_ID
  JOIN [Ahs_Altus_Prod].[dbo].[PATIENT_DETAILS] PD on pd.PATIENT_ID = lq.PATIENT_ID
                        JOIN ahs_altus_prod.dbo.MEM_BENF_PLAN AS mbp on mbp.member_id = pd.patient_id
                      JOIN ahs_altus_prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID
                      JOIN ahs_altus_prod.dbo.BENEFIT_PLAN AS bpl ON lbp.BENEFIT_PLAN_ID = bpl.BENEFIT_PLAN_ID
   join ahs_altus_prod.dbo.lob as LOB on lob.lob_id = lbp.lob_ID
  		Where CLIENT_PATIENT_ID not like ('ALT%')







  

CREATE VIEW [dbo].[vw_care_op_distr_list2]
AS
select 
 [member_id]
,NameFirst
,NameLast
,DOB
,GENDER
,Member_Phone
,MEDICAID_ID
,CASE WHEN LEN(TIN_Num) = 8 THEN concat('0', TIN_Num) ELSE TIN_Num END AS [Membership_TIN]
,case when TIN_Num ='752894111' then upper('Topcare Medical PA') else TIN_Name end AS Membership_Practice_Name
,TIN_Num
,TIN_Name
,Prov_Last_Name
,Prov_First_Name
,concat(prov_last_name,', ',prov_first_name) as Provider_Name
,LINE_OF_BUSINESS  as [PLAN]
,[A_LAST_UPDATE_DATE]
,[UHC_AWC]                      as [AWC :  Adolescent Well-Care Visits .]
,[UHC_BCS]                      as [BCS :  Breast Cancer Screening .]
,[UHC_CCS]                      as [CCS :  Cervical Cancer Screening .]
,[UHC_W15]                      as [W15 :  Well-Child Visits in the First 15 Months of Life - Six or more well-child visits .]
,[UHC_W34]                      as [W34 :  Well-Child Visits in the Third, Fourth, Fifth and Sixth Years of Life .]
,[UHC_WCC_BMI]                  as [WCC :  Weight Counseling for Nutrition and Physical Activity for Children/Adolescents - BMI Percentile .]
,[UHC_WCC_CN]                   as [WCC :  Weight Counseling for Nutrition and Physical Activity for Children/Adolescents - Counseling for Nutrition .]
,[UHC_WCC_PA]                   as [WCC :  Weight Counseling for Nutrition and Physical Activity for Children/Adolescents - Counseling for Physical Activity .]
,[UHC_SSD]                      as [SSD :  Diabetes Screening for People With Schizophrenia or Bipolar Disorder Who Are Using Antipsychotic Medications .]
,[UHC_ADD_CM]       			as [ADD :  Follow-Up Care for Children Prescribed ADHD Medication - Continuation and Maintenance Phase .]
,[UHC_ADD_I]					as [ADD :  Follow-Up Care for Children Prescribed ADHD Medication - Initiation Phase .]
,[UHC_CAP]						as [CAP :  Children and Adolescents Access to Primary Care Practitioners .]
,[UHC_CBP]						as [CBP :  Controlling High Blood Pressure .]
,[UHC_CDC_G_9]                  as [CDC :  Comprehensive Diabetes Care - HbA1c Poor Control (>9.0%) .]
,[UHC_CDC_L_8]					as [CDC :  Comprehensive Diabetes Care - HbA1c control (<8.0%) .]
,[UHC_CDC_HB]					as [CDC :  Comprehensive Diabetes Care - HbA1c (HbA1c) Testing .]
,[UHC_COA_MR]					as [COA : Care for Older Adults - Medication review]
,[UHC_CIS]						as [CIS :  Childhood Immunization Status - Combination 10  (DTap , IPV , MMR , HiB , Hep B , VZV , PCV , Hep A , RV , Influenza) .]
,[UHC_FUH_30_0617]				as [FUH :  Follow-Up After Hospitalization for Mental Illness - 30-day follow-up for discharge-6-17 years old]
,[UHC_FUH_30_1864]				as [FUH :  Follow-Up After Hospitalization for Mental Illness - 30-day follow-up for discharge-18-64 years old]
,[UHC_FUH_30_G_65]				as [FUH :  Follow-Up After Hospitalization for Mental Illness - 30-day follow-up for discharge-65 years and older .]
,[UHC_FUH_7_0617]				as [FUH :  Follow-Up After Hospitalization for Mental Illness - 7-day follow-up for discharge-6-17 years old .]
,[UHC_FUH_7_1864]				as [FUH :  Follow-Up After Hospitalization for Mental Illness - 7-day follow-up for discharge-18-64 years old .]
,[UHC_FUH_7_G_65]				as [FUH :  Follow-Up After Hospitalization for Mental Illness - 7-day follow-up for discharge-65 years and older .]
,[uhc_mpm_a]					as [MPM :  Annual Monitoring for Patients on Persistent Medications - ACE Inhibitors or ARBs]
,UHC_MPM_D						as [MPM :  Annual Monitoring for Patients on Persistent Medications - Diuretics]
,[UHC_PPC_POST]					as [PPC :  Prenatal and Postpartum Care - Post Partum Care .]
,[UHC_PPC_PRE]					as [PPC :  Prenatal and Postpartum Care - Timeliness of Prenatal Care .]
,[UHC_SAA]						as [SSA : Adherence to Antipsychotic Medications for Individuals with Schizopherenia]
,[UHC_URI]						as [URI :  Appropriate Treatment for Children With Upper Respiratory Infection .]
from (
SELECT  distinct
           [QmMsrID],
	       [QM_DESC],
           [Member_ID],
		   b.MEMBER_FIRST_NAME as [NameFirst],
           b.MEMBER_LAST_NAME  as [NameLast],

		   b.LINE_OF_BUSINESS ,

		   b.MEDICAID_ID,
           convert(date,b.DATE_OF_BIRTH,101) AS DOB,
           [Gender],
		   CASE WHEN b.MEMBER_HOME_PHONE ='' THEN '' ELSE  SUBSTRING('('+b.MEMBER_HOME_PHONE, 1, 4) + ')' +  SUBSTRING(b.MEMBER_HOME_PHONE, 4, 3) + '-' +   SUBSTRING(b.MEMBER_HOME_PHONE, 7, 4) END as [Member_Phone],
           b.PCP_PRACTICE_TIN                              as [TIN_Num],
           d.[PRACTICE NAME]                                              as [TIN_Name],
           b.PCP_LAST_NAME     as               [Prov_Last_Name],
           b.PCP_FIRST_NAME                   as            [Prov_First_Name],
           [QMDate] as [A_LAST_UPDATE_DATE]

      
  FROM (select * from 
acecaredw.[adw].[QM_ResultByMember_History] where case when qmmsrid = 'UHC_CDC_G_9' and qmcntcat = 'NUM' then 'COP'
when qmmsrid = 'UHC_CDC_G_9' and qmcntcat = 'COP' then 'NUM'

 else qmcntcat end = 'COP' and qmdate = (select max(qmdate) from acecaredw.[adw].[QM_ResultByMember_History] )
) a
  join 
  (select  a.* from [vw_UHC_ActiveMembers] a 
) b on a.clientMemberKey = b.member_id
   join  
[ACECAREDW].[lst].[LIST_QM_Mapping] c on a.QmMsrId = c.qm
left join 
(
    SELECT DISTINCT
           [Tax id],
           [PRACTICE NAME]
    FROM [ACECAREDW].[dbo].[vw_NetworkRoster]
) d ON CONVERT(INT, b.PCP_PRACTICE_TIN  ) = CONVERT(INT, d.[TAX ID])
) zz
PIVOT(COUNT(qm_desc) FOR [qmMsrID] IN(
 [UHC_ADD_CM]         
,[UHC_ADD_I]
,[UHC_AWC]
,[UHC_BCS]
,[UHC_CAP]
,[UHC_CBP]
,[UHC_CCS]
,[UHC_CDC_G_9]
,[UHC_CDC_HB]
,[UHC_CDC_L_8]
,[UHC_CIS]
,[UHC_COA_MR]
,[UHC_FUH_30_0617]
,[UHC_FUH_30_1864]
,[UHC_FUH_30_G_65]
,[UHC_FUH_7_0617]
,[UHC_FUH_7_1864]
,[UHC_FUH_7_G_65]
,[uhc_mpm_a]
,[UHC_MPM_D]
,[UHC_PPC_POST]
,[UHC_PPC_PRE]
,[UHC_SSD]
,[UHC_SAA]
,[UHC_URI]
,[UHC_W15]
,[UHC_W34]
,[UHC_WCC_BMI]
,[UHC_WCC_CN]
,[UHC_WCC_PA]





) ) as pvt 








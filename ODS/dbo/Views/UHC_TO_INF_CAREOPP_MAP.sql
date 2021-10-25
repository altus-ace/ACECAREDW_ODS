CREATE VIEW UHC_TO_INF_CAREOPP_MAP
AS
SELECT distinct [Measure_Desc]
      ,[Sub_Meas]
      --,[MemberID]      ,[UniversalMemberId]      ,[A_LAST_UPDATE_DATE]
	  ,   case 												
when measure_desc  = 	'Comprehensive Diabetes Care (Commercial/Medicaid)'	and 	Sub_Meas =	'HbA1c <8%'	then	'CDC-1-UHC'
when measure_desc  = 	'Follow-Up After Hospitalization for Mental Illness'	and 	Sub_Meas =	'7-Day Follow-Up'	then	'TCM-1-UHC'
when measure_desc  = 	'Prenatal and Postpartum Care'	and 	Sub_Meas =	'Postpartum Care'	then	'PPC-2-UHC'
when measure_desc  = 	'Well Child Visits in the Third, Fourth, Fifth and Sixth Year of Life'	and 	Sub_Meas =	'(Default)'	then	'WC36-UHC'
when measure_desc  = 	'Comprehensive Diabetes Care (Commercial/Medicaid)'	and 	Sub_Meas =	'HbA1c Poor Control'	then	'CDC-1-UHC'
when measure_desc  = 	'Breast Cancer Screening'	and 	Sub_Meas =	'(Default)'	then	'BCS-UHC'
when measure_desc  = 	'Cervical Cancer Screening (Medicaid/Marketplace)'	and 	Sub_Meas =	'(Default)'	then	'CCS-UHC'
when measure_desc  = 	'Prenatal and Postpartum Care'	and 	Sub_Meas =	'Prenatal Care'	then	'PPC-UHC'
when measure_desc  = 	'Adolescent Well Care Visits'	and 	Sub_Meas =	'(Default)'	then	'AWC-UHC'
end as Measure_ID			
	,  case 												
when measure_desc  = 	'Comprehensive Diabetes Care (Commercial/Medicaid)'	and 	Sub_Meas =	'HbA1c <8%'	then	'UHC - Specific Blood Sugar Controlled - Members 18-75  (Diabetes type 1 and type 2)'
when measure_desc  = 	'Follow-Up After Hospitalization for Mental Illness'	and 	Sub_Meas =	'7-Day Follow-Up'	then	'Follow-Up with a mental health provider within 7 days after hospitalization for Mental Illness'
when measure_desc  = 	'Prenatal and Postpartum Care'	and 	Sub_Meas =	'Postpartum Care'	then	'Postpartum visit between 21 and 56 days post delivery after live birth. 	'
when measure_desc  = 	'Well Child Visits in the Third, Fourth, Fifth and Sixth Year of Life'	and 	Sub_Meas =	'(Default)'	then	'Well child exams 3-6 years'
when measure_desc  = 	'Comprehensive Diabetes Care (Commercial/Medicaid)'	and 	Sub_Meas =	'HbA1c Poor Control'	then	'UHC - Specific Blood Sugar Controlled - Members 18-75  (Diabetes type 1 and type 2)'
when measure_desc  = 	'Breast Cancer Screening'	and 	Sub_Meas =	'(Default)'	then	'Breast Cancer Screening '
when measure_desc  = 	'Cervical Cancer Screening (Medicaid/Marketplace)'	and 	Sub_Meas =		'(Default)'	then	'Cervical Cancer Screening'
when measure_desc  = 	'Prenatal and Postpartum Care'	and 	Sub_Meas =	'Prenatal Care'	then	'Pregnant Women - Prenatal Visits within first trimester or within 42 days of enrollment'
when measure_desc  = 	'Adolescent Well Care Visits'	and 	Sub_Meas =	'(Default)'	then	'Adolescent Well Care visits Ages 12-21 years'
end as Measure_Description											
FROM [ACECAREDW].[dbo].[UHC_CareOpps]

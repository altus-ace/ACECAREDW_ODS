


CREATE VIEW [adi].[vw_pdwSrc_CopUhcPcor_V1] 
    /* Pdw: process data warehouse, src: Load Source     */
AS 
    /* purpose:  
	   1. Finds the set with the Latest load date, not the latest row for each care op
	   2. Unpivots each Measure as a CopMsrStatus and CopMsrName
	   3. convert compliance/non-compliance to NUM or COP
		  '0/1' = COP
		  '1/1' = NUM
		  'X'	= COP
	       '-'	= NUM
	   */
SELECT copMsr.MemberId, copMsr.DateOfLastService, copMsr.IncentiveProgram, copMsr.CareScore, copMsr.HealthPlanName
    , copMsr.Product, copMsr.copUhcPcor AS AdiKey, copMsr.[loadDate], copMsr.SrcFileName
    , CASE WHEN (copMsr.CopMsrStatus = '0/1') THEN 'COP'
		 WHEN (copMsr.CopMsrStatus = '1/1') THEN 'NUM'
		 WHEN (copMsr.CopMsrStatus = 'X'	 ) THEN 'COP'
		 WHEN (copMsr.CopMsrStatus = '-'	 ) THEN 'NUM'
		 WHEN (copMsr.CopMsrStatus = '0'	 ) THEN 'COP'
		 WHEN (copMsr.CopMsrStatus = '1'	 ) THEN 'NUM'
		 ELSE 'Unk'
	   END AS CopMsrStatus
    , copMsr.CopMsrName
    , copMsr.QM_Date
    , map.Destination
    , qm.QM As QM_ID
FROM (SELECT p.copUhcPcor, 
		 p.LoadDate, 
		 p.SrcFileName, 
		 p.DataDate AS QM_Date, 
           p.MemberID, 
           p.DateOfLastService, 
           p.IncentiveProgram, 
           p.CareScore, 
           p.HealthPlanName, 
           p.Product
		 ,p.FUH_FollowUpHospMentalIllness_30
		 ,p.FUH_FollowUpHospMentalIllness_30_6_17_years
		 ,p.FUH_FollowUpHospMentalIllness_30_18_64_years
		 ,p.FUH_FollowUpHospMentalIllness_30_65_years
		 ,p.FUH_FollowUpAfterHospMentIllness7Day
		 ,p.FUH_FollowUpAfterHospMentIllness7Day_6_17_years
		 ,p.FUH_FollowUpAfterHospMentIllness7Day_18_64_years
		 ,p.FUH_FollowUpAfterHospMentIllness7Day_65_years
		 ,p.PPC_PostPartumCare
		 ,p.PPC_TimelinessPrenatalCare
		 ,p.ADD_FollowUpCareChild_ADHD_ContMaintPhase
		 ,p.ADD_FollowUpCareChild_ADHD_InitiationPhase
		 ,p.AWC_AdolescentWellCareVisits
		 ,p.BCS_BreastCancerScreening
		 ,p.CAP_ChildrenAdolescentsAccessPrimaryCare
		 ,p.CBP_ControllingHighBloodPressure
		 ,p.CCS_CervicalCancerScreening
		 ,p.CDC_CompDiabetesCareHbA1cControl
		 ,p.CDC_CompDiabetesCareHbA1cPoorControl
		 ,p.CIS_ChildImmunizationStatusCombo10
		 ,p.CTM_STWAWC_AdolescentWellCareVisits
		 ,p.SSD_DiabetesScreeningSchizophreniaBipolar
		 ,p.URI_ChildUpperRespInfection
		 ,p.W15_WellChildVisitsFirst_15_Months
		 ,p.W34_WellChildVisits_3_6_Years
		 ,p.WCC_WeightCounselingChildBMIPercentile
		 ,p.WCC_WeightCounselingChildNutrition
		 ,p.WCC_WeightCounselingChildPhysicalActivity
		 ,p.CDC_ComprehensiveDiabetesCare_HbA1c_Testing 
		 ,p.COA_CareForOlderAdults_MedicationReview		 
		 ,p.MPM_AnnualMonitoringForPatientsOnPersistentMedicationsACEInhibitorsOrARBs 
		 ,p.MPM_AnnualMonitoringForPatientsOnPersistentMedicationsDiuretics 
		 ,p.AdherenceToAntipsychoticMedicationsForIndividualsWithSchizophreniaAges19_64 
		 ,p.CareForOlderAdults_COA_MedicationReviewAges66OrOlder 
		 ,p.MedicationReconciliationPostDischargeAges18OrOlder 
		 ,p.ComprehensiveDiabetesCareHemoglobinA1CTesting 
		 ,p.AAP_AdultsAccesstoPreventiveAmbulatoryHealthServices 
		 ,p.CHL_ChlamydiaScreeningInWomen 
	   FROM adi.copUhcPcor p
		  JOIN (SELECT MAX(p.DataDate) LatestLoadDate
				FROM adi.copUhcPcor p ) AS LatestLoadDate  
			 ON p.DataDate = LatestLoadDate.LatestLoadDate
    ) AS src
   UNPIVOT 
    (
	   copMsrStatus FOR CopMsrName IN (
		  FUH_FollowUpHospMentalIllness_30_6_17_years,	    
		  FUH_FollowUpHospMentalIllness_30_18_64_years, 
		  FUH_FollowUpHospMentalIllness_30_65_years, 
		  FUH_FollowUpAfterHospMentIllness7Day,
		  FUH_FollowUpAfterHospMentIllness7Day_6_17_years, 
		  FUH_FollowUpAfterHospMentIllness7Day_18_64_years, 
		  FUH_FollowUpAfterHospMentIllness7Day_65_years, 
		  PPC_PostPartumCare, 
		  PPC_TimelinessPrenatalCare, 
		  ADD_FollowUpCareChild_ADHD_ContMaintPhase, 
		  ADD_FollowUpCareChild_ADHD_InitiationPhase, 
		  AWC_AdolescentWellCareVisits, 
		  BCS_BreastCancerScreening, 
		  CAP_ChildrenAdolescentsAccessPrimaryCare, 
		  CBP_ControllingHighBloodPressure, 
		  CCS_CervicalCancerScreening, 
		  CDC_CompDiabetesCareHbA1cControl, 
		  CDC_CompDiabetesCareHbA1cPoorControl, 
		  CIS_ChildImmunizationStatusCombo10, 
		  CTM_STWAWC_AdolescentWellCareVisits, 
		  SSD_DiabetesScreeningSchizophreniaBipolar, 
		  URI_ChildUpperRespInfection, 
		  W15_WellChildVisitsFirst_15_Months, 
		  W34_WellChildVisits_3_6_Years, 
		  WCC_WeightCounselingChildBMIPercentile, 
		  WCC_WeightCounselingChildNutrition, 
		  WCC_WeightCounselingChildPhysicalActivity,
		  CDC_ComprehensiveDiabetesCare_HbA1c_Testing,
		  COA_CareForOlderAdults_MedicationReview
		  ,FUH_FollowUpHospMentalIllness_30 
		  ,MPM_AnnualMonitoringForPatientsOnPersistentMedicationsACEInhibitorsOrARBs 
		  ,MPM_AnnualMonitoringForPatientsOnPersistentMedicationsDiuretics 
		  ,AdherenceToAntipsychoticMedicationsForIndividualsWithSchizophreniaAges19_64 
		  ,CareForOlderAdults_COA_MedicationReviewAges66OrOlder 
		  ,MedicationReconciliationPostDischargeAges18OrOlder 
		  ,ComprehensiveDiabetesCareHemoglobinA1CTesting 
		  ,AAP_AdultsAccesstoPreventiveAmbulatoryHealthServices 
		  ,CHL_ChlamydiaScreeningInWomen 

		  )
	 )AS CopMsr     
	LEFT JOIN  (SELECT m.lstAceMappingKey, m.Destination, m.Source
				FROM lst.ListAceMapping m 
				WHERE m.MappingTypeKey = 12 
				    AND ClientKey = 1 
				    AND IsActive = 1) AS map
			 ON CopMsr.CopMsrName = map.Source
    LEFT JOIN (SELECT QM, QM_DESC 
			 FROM lst.LIST_QM_Mapping qm				 
			 ) qm 
		  ON  map.Destination = qm.QM_DESC
WHERE MemberID <> ''
    AND CopMsrStatus <> ''   
    /* Remove unmapped? or leave in so we can test downstream? */
    --AND NOT Destination is null     AND NOT qm IS NULL

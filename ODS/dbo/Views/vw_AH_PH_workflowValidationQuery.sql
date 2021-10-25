create view  [vw_AH_PH_workflowValidationQuery]
as
SELECT pd.client_patient_id,
       omd.Measure_code,
	  oc.opp_name,
       omd.Measure_category,
       omd.Measure_version,       
       cco.Identified_date,
       cco.Quality_action_status_id,
       cqas.QUALITY_ACTION_STATUS_NAME,
       cco.Quality_measure_status_id,
       cqms.QUALITY_MEASURE_STATUS_NAME
FROM ahs_altus_QA.dbo.CPL_CARE_OPPORTUNITY cco
     INNER JOIN ahs_altus_QA.dbo.CPL_QUALITY_MEASURE_STATUS cqms ON cqms.QUALITY_MEASURE_STATUS_ID = cco.QUALITY_MEASURE_STATUS_ID
     INNER JOIN ahs_altus_QA.dbo.CPL_QUALITY_ACTION_STATUS cqas ON cqas.QUALITY_ACTION_STATUS_ID = cco.QUALITY_ACTION_STATUS_ID
     INNER JOIN ahs_altus_QA.dbo.CPL_OPPORTUNITY_MEASURE_DETAIL omd ON omd.OPP_ID = cco.OPPORTUNITY_ID
     INNER JOIN ahs_altus_QA.dbo.CPL_OPPORTUNITY oc ON oc.OPP_ID = omd.Opp_id
     INNER JOIN ahs_altus_QA.dbo.PATIENT_DETAILS pd ON pd.patient_id = cco.patient_id
WHERE cco.Opportunity_id IN('32576', '32577', '32578', '32579', '32580', '32581');
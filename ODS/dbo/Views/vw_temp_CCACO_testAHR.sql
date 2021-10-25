
CREATE VIEW [dbo].[vw_temp_CCACO_testAHR]
AS

	SELECT DISTINCT a.Measure_Desc
		,a.MemberID
		,a.MedicaidID
		,a.DOB
		,a.Gender
		,a.NameFirst AS FirstName
		,a.NameLast AS Lastname
		,a.Member_Address_1
		,a.Member_City
		,a.Member_State
		,a.Member_Phone
		,a.Provider_NPI
		,'UHG' AS client
		,b.PRIMARY_DIAGNOSIS_CODE as ER_Primary_DX
		,b.SECONDARY_DIAGNOSIS_CODE as ER_Secondary_DX
		,b.VISIT_DATE as ER_visit_dt
		,b.VISIT_HOSPITAL as ER_Visit_Hospital
		,c.DISCHARGE_DATE
		,c.ADMIT_DATE
		,c.PRIMARY_DIAGNOSIS_CODE as IP_Primary_DX
		,c.SECONDARY_DIAGNOSIS_CODE as IP_Secondary_DX
		,c.ADMIT_HOSPITAL as IP_Hospital
	FROM UHC_CareOpps a
	INNER JOIN (
		SELECT UHC_SUBSCRIBER_ID
			,PRIMARY_DIAGNOSIS_CODE
			,SECONDARY_DIAGNOSIS_CODE
			,VISIT_DATE
			,VISIT_HOSPITAL
		FROM UHC_ER_Visits
		) b ON a.memberID = b.UHC_SUBSCRIBER_ID
	INNER JOIN (
	select UHC_SUBSCRIBER_ID 
		,DISCHARGE_DATE
		,ADMIT_DATE
		,PRIMARY_DIAGNOSIS_CODE 
		,SECONDARY_DIAGNOSIS_CODE
		,ADMIT_HOSPITAL
		 from UHC_IP_Admits
		) c ON a.memberID = c.UHC_SUBSCRIBER_ID
--	) AS test

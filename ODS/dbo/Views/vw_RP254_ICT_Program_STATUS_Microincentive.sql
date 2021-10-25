
CREATE VIEW [dbo].[vw_RP254_ICT_Program_STATUS_Microincentive]
AS
SELECT DISTINCT CLIENT_PATIENT_ID
	,
	--LOB,
	PROGRAM_NAME
	,
	--		START_DATE,
	--		 end_date,
	--		plan_start_date,
	--		  plan_end_date,
	PROGRAM_STATUS_NAME
	,convert(DATE, UPDATED_ON, 101) as Updated_ON
--	,month(convert(DATE, Updated_on, 101)) AS STATUS_UPTADED_MONTH
FROM (
	SELECT DISTINCT pd.CLIENT_PATIENT_ID
		,bpr.PROGRAM_NAME
		,mbpr.START_DATE
		,mbpr.end_date
		,mbp.start_date AS plan_start_date
		,mbp.end_date AS plan_end_date
		,ps.PROGRAM_STATUS_NAME
		,mbpr.updated_on
		,row_Number() OVER (
			PARTITION BY pd.CLIENT_PATIENT_ID
			,bpr.program_name
			,mbpr.start_Date ORDER BY mbp.end_date DESC
			) AS arn
	FROM ahs_altus_prod.dbo.MEM_BENF_PLAN AS mbp
	INNER JOIN ahs_altus_prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID
	INNER JOIN ahs_altus_prod.dbo.BENEFIT_PLAN AS bpl ON lbp.BENEFIT_PLAN_ID = bpl.BENEFIT_PLAN_ID
	LEFT JOIN ahs_altus_prod.dbo.MEM_BENF_PROG AS mbpr ON mbp.MEMBER_ID = mbpr.MEMBER_ID
	LEFT JOIN ahs_altus_prod.dbo.BENF_PLAN_PROG AS bpp ON mbpr.BEN_PLAN_PROG_ID = bpp.BEN_PLAN_PROG_ID
	LEFT JOIN ahs_altus_prod.dbo.BENEFIT_PROGRAM AS bpr ON bpp.BENEFIT_PROGRAM_ID = bpr.BENEFIT_PROGRAM_ID
	INNER JOIN ahs_altus_prod.dbo.PATIENT_DETAILS AS pd ON mbp.MEMBER_ID = pd.PATIENT_ID
		AND pd.DELETED_ON IS NULL
	INNER JOIN ahs_altus_prod.dbo.PROGRAM_STATUS AS ps ON mbpr.PROGRAM_STATUS_ID = ps.PROGRAM_STATUS_ID
		AND ps.DELETED_ON IS NULL
		AND ps.IS_ACTIVE = 1
	INNER JOIN ACECAREDW.adi.mbruhcMicroincentives as active ON Active.SUBSCRIBER_ID = pd.CLIENT_PATIENT_ID
	WHERE (mbp.DELETED_ON IS NULL)
		AND mbpr.deleted_on IS NULL /*Deleted the duplicate programs so need to add this condition to eliminate wrong program( Enrollment) 28*/
		AND PS.PROGRAM_STATUS_NAME NOT IN ('ERROR')
		AND bpr.PROGRAM_NAME IN (
			'C-Comprehensive Diabetes Care'
			,'C-Hypertension'
			)
	GROUP BY pd.CLIENT_PATIENT_ID
		,bpr.PROGRAM_NAME
		,mbpr.START_DATE
		,PS.PROGRAM_STATUS_NAME
		,mbpr.end_date
		,mbpr.updated_on
		,mbp.start_date
		,mbp.end_date
	) AS s


CREATE VIEW [adi].[vw_pdwSrc_CopUhcQualityGapReport] 
    /* Pdw: process data warehouse, src: Load Source     */
AS 

SELECT     adiData.[MemberID]
		,adiData.[DateOfLastService]
		,adiData.[IncentiveProgram]		
		,adiData.[HealthPlan] AS HealthPlanName
		,adiData.[LOB]	AS Product
		,adiData.AdiKey
		,adiData.[loadDate]
		,adiData.[SrcFileName]
		,(CASE WHEN adiData.[Compliant] = 'Yes' THEN 'NUM'
				WHEN adiData.[Compliant] = 'No'   THEN 'COP'
		   ELSE 'Unk'END) as CopMsrStatus
		,adiData.[MeasureDesc] AS CopMsrName
		,adiData.[DataDate] as QM_Date
		,[MeasureCode]+' :  '+[MeasureDesc]+ (CASE WHEN SubMeasure = '(Default)' THEN +' .' ELSE ' - '+SubMeasure+' .'END) as Destination /* To concatenate Destination so as to mapped Data running downstream*/
		,qm.QM as QM_ID
		,adiData.DataDate
		,'adi.[UHCQualityGapReport]' AS adiTableName
FROM (SELECT adiData.UHCQualityGapReportKey adiKey, adiData.LoadDate, adiData.DataDate, adiData.SrcFileName, ''IncentiveProgram, -- adiData.OriginalFileName,               
		  '' Category, adidata.ProductSugroup [HealthPlan], adiData.LOB, adiData.MeasureId MeasureCode, adiData.MeasureDescription MeasureDesc, 
		  adiData.SubmeasureDescription AS SubMeasure, adiData.COMPLIANCE Compliant, adiData.MemberId, ''[DateOfLastService]
	   FROM [adi].[UHCQualityGapReport] adiData
	   WHERE adidata.loadCareOppStatus = 0 
	   )  adiData
	LEFT JOIN (SELECT QM, QM_DESC
			  FROM [lst].[LIST_QM_Mapping] qm  ) qm 
			ON  [MeasureCode]+' :  '+[MeasureDesc]+ (CASE WHEN SubMeasure = '(Default)' THEN +' .' ELSE ' - '+SubMeasure+' .'END)
				 = LTRIM(RTRIM(qm.QM_DESC))    
WHERE adidata.MemberID <> '' 
    AND ISNULL(adidata.[Compliant], '') <> ''




CREATE VIEW [adi].[vw_pdwSrc_CopUhcPcor] 
    /* Pdw: process data warehouse, src: Load Source     */
AS 

SELECT     PcorData.[MemberID]
		,PcorData.[DateOfLastService]
		,PcorData.[IncentiveProgram]		
		,PcorData.[HealthPlan] AS HealthPlanName
		,PcorData.[LOB]	AS Product
		,PcorData.[copUhcPcorKey]  AS AdiKey
		,PcorData.[loadDate]
		,PcorData.[SrcFileName]
		,(CASE WHEN PcorData.[Compliant] = 'Yes' THEN 'NUM'
				WHEN PcorData.[Compliant] = 'No'   THEN 'COP'
		   ELSE 'Unk'END) as CopMsrStatus
		,PcorData.[MeasureDesc] AS CopMsrName
		,PcorData.[DataDate] as QM_Date
		,[MeasureCode]+' :  '+[MeasureDesc]+ (CASE WHEN SubMeasure = '(Default)' THEN +' .' ELSE ' - '+SubMeasure+' .'END) as Destination /* To concatenate Destination so as to mapped Data running downstream*/
		,qm.QM as QM_ID
		, PcorData.DataDate
		, 'adi.copUhcPcorMbrMeasureView' AS adiTableName
FROM (SELECT c.copUhcPcorKey, c.loadDate, c.DataDate, c.SrcFileName, c.IncentiveProgram, 
		  c.Category, c.HealthPlan, c.LOB, RTRIM(LTRIM(c.MeasureCode))MeasureCode, RTRIM(LTRIM(c.MeasureDesc)) MeasureDesc, 
		  RTRIM(LTRIM(c.SubMeasure))SubMeasure, c.Compliant, c.MemberID, c.DateOfLastService
	 FROM [adi].[copUhcPcorMbrMeasureView] c)  PcorData 
	LEFT JOIN (SELECT QM, QM_DESC
			  FROM [lst].[LIST_QM_Mapping] qm  ) qm 
			ON  [MeasureCode]+' :  '+[MeasureDesc]+ (CASE WHEN SubMeasure = '(Default)' THEN +' .' ELSE ' - '+SubMeasure+' .'END)
				 = LTRIM(RTRIM(qm.QM_DESC))    
WHERE PcorData.MemberID <> '' 
    AND ISNULL(PcorData.[Compliant], '') <> ''



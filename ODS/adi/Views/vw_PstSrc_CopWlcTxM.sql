


CREATE VIEW [adi].[vw_PstSrc_CopWlcTxM]
AS 
    SELECT 
	   SUBSTRING(adiData.Subscriber, 0, CHARINDEX('-', adiData.Subscriber) ) As MemberID
	   , adiData.LastKnownServiceDate AS DateOfLastService
	   , 'IncentiveProgram' AS IncentiveProgram
	   , 'HealtPlanName' AS HealthPlanName
	   , 'LOB' as Product
	   , adiData.URN AS AdiKey
	   , 'CopWlcTxM' AS AdiTableName
	   , adiData.DataDate  AS LoadDate
	   , adidata.OriginalFileName AS SrcFileName
	   , CASE WHEN (adiData.ComplianceStatus = 'Compliant') THEN 'NUM'
		  WHEN (adiData.ComplianceStatus = 'Non-Compliant') OR(adiData.ComplianceStatus = 'In-Play') OR (adiData.ComplianceStatus = 'Unattainable')  THEN 'COP'     
		  ELSE 'Unk' END AS CopMsrStatus
	   , adiData.Measure AS CopMsrName	   
	   , adiData.DataDate AS QM_Date
	   , adiData.Measure
	   , Client.ClientKey , adiData.Subscriber, adiData.ComplianceStatus
	   , adiData.ServiceStartDate, adiData.ServiceEndDate
	   , adiData.Measure AS MeasureName	  , lstAce.Destination AS QM_ID, lstAce.lstAceMappingKey, adiData.DataDate
	   , qm.MeasureID, lstAce.Destination AS srcQMID
    FROM adi.CopWlcTxM adiData 
	   JOIN lst.List_Client Client ON 2 = client.ClientKey 
	   /*Matching on lst Ace Mapping for common values*/
	   LEFT JOIN (SELECT lstAceMappingKey,Source,Destination 
					FROM lst.ListAceMapping
					WHERE	ClientKey = 2
					AND ACTIVE = 'Y'
					AND IsActive = 1
					AND	MappingTypeKey = 14 ) lstAce 
		ON adiData.Measure = lstAce.Source
		/* Matching on lst care op to plan to retrieve Measure IDs*/
	LEFT JOIN (SELECT DISTINCT MeasureID,MeasureDesc
				FROM lst.lstCareOpToPlan
				WHERE ClientKey = 2
				AND ACTIVE = 'Y') qm
	ON			lstAce.Destination = qm.MeasureID
    WHERE adiData.Status = 0
	   and adiData.Subscriber <> ''
	   

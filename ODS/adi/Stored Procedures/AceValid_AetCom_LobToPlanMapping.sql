Create Procedure adi.AceValid_AetCom_LobToPlanMapping
    @adiLoadDate date = '06/12/2019'
AS 
SELECT m.mbrAetComMbr, m.SrcFileName, m.CreatedDate, m.MEMBER_ID , m.EffectiveMonth, m.Line_of_Business, SubPlanName.TargetValue
FROM adi.mbrAetCom m
    JOIN lst.List_Client c ON c.ClientKey = 9
    JOIN (SELECT t.ClientMemberKey, t.EffectiveMonth, t.LastClientUpdateDate, t.adiKey, t.adiTableName, t.LoadDate
		  FROM adi.tvf_MbrAetCom_GetCurrentMembers(@adiLoadDate) t
		  ) mf ON m.mbrAetComMbr = mf.AdiKey    
    LEFT JOIN lst.lstPlanMapping SubPlanName  
		  ON m.Line_of_Business = subPlanName.SourceValue 
		  AND SubPlanName.TargetSystem = 'ACDW'
		  AND @adiLoadDate BETWEEN SubPlanName.EffectiveDate and SubPlanName.ExpirationDate	        
WHERE SubPlanName.lstPlanMappingKey is null

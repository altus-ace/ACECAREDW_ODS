CREATE FUNCTION ast.tvf_mbrUhcMember_Validation(@LoadDate Date)
RETURNS TABLE
AS RETURN

    SELECT m.URN, m.UHC_SUBSCRIBER_ID, m.SUBGRP_ID, m.PCP_PRACTICE_TIN, m.PCP_NPI
        , pr.TIN 
        , pm.TargetValue AS CsPlan
    FROM dbo.Uhc_MembersByPcp m
        LEFT JOIN (SELECT pr.TIN 
    		  FROM dbo.vw_AllClient_ProviderRoster pr 
    		  WHERE pr.CalcClientKey = 1
    			 and @LoadDate between pr.EffectiveDate AND pr.ExpirationDate
    		  GROUP BY pr.TIN ) pr
    		  ON m.PCP_PRACTICE_TIN = pr.TIN
        LEFT JOIN lst.lstPlanMapping PM 
    	   ON pm.ClientKey = 1
    	   and m.SUBGRP_ID = pm.SourceValue 
    	   and pm.TargetSystem = 'CS_AHS'
    	   and @LoadDate BETWEEN pm.EffectiveDate and pm.ExpirationDate
    where m.A_LAST_UPDATE_FLAG = 'Y'

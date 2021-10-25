
CREATE PROCEDURE ast.GK_Get_TmpMbrGetCsPlan( @MaxLoadDate DATE)
AS 
BEGIN
    --DECLARE @MaxLoadDate date = '2020-06-16';
    DECLARE @lLoadDate DATE ;
    DECLARE @PrEffDate DATE;
    SELECT @lLoadDate = MAX(m.A_LAST_UPDATE_DATE)
    FROM dbo.Uhc_MembersByPcp m
    WHERE m.A_LAST_UPDATE_DATE < @MaxLoadDate;
    DECLARE @StartDate Date  = DATEFROMPARTS(Year(@lLoadDate), Month(@lLoadDate), 1);
    DECLARE @TermDate DATE = dateadd(day, -1, @StartDate);
    DECLARE @StopDate DATE = '12/31/2099'
    
    SELECT @PrEffDate = Max(Pr.RowEffectiveDate)	   
    FROM adw.fctProviderRoster PR
    WHERE @lLoadDate > pr.RowEffectiveDate
    IF (@PrEffDate IS NULL) 
	   BEGIN
		  SET @PrEffDate = (SELECT MIN(pr.RowEffectiveDate) from adw.fctProviderRoster pr) 
	   END;    
    
    SELECT @lLoadDate, @PrEffDate, @MaxLoadDate, @StartDate, @StopDate, @TermDate
    --SELECT * FROM ast.MbrMonthProcessed
    
    SELECT m.UHC_SUBSCRIBER_ID CMK, pm.TargetValue CsPlanValue, m.SUBGRP_ID SubGrpID, Pr.TIN , CASE WHEN (Pr.Tin is null) THEN 0 ELSE 1 END AS IsProvActive
		 , @StartDate AS StartDateCandidate, @TermDate TermDate, @StopDate As StopDate
    INTO #Tmp_MbrMonthSet -- drop table #tmp_MbrMonthSet
    FROM dbo.Uhc_MembersByPcp m
	   JOIN lst.lstPlanMapping pm 
		ON m.SUBGRP_ID = pm.SourceValue		  
		  and '2021-01-22' between pm.EffectiveDate and pm.ExpirationDate
        LEFT JOIN (Select pr.TIN, pr.EffectiveDate, pr.ExpirationDate
				 , ROW_NUMBER() OVER (PARTITION BY pr.TIN ORDER BY pr.EffectiveDate ASC, pr.ExpirationDate DESC) ARN
			 FROM vw_AllClient_ProviderRoster pr 
			 WHERE pr.CalcClientKey = 1
			 GROUP BY pr.TIN, pr.EffectiveDate, pr.ExpirationDate) pr
			 ON m.PCP_PRACTICE_TIN = pr.TIN
				and '2021-03-22' BETWEEN pr.EffectiveDate AND pr.ExpirationDate
    WHERE m.A_LAST_UPDATE_DATE = '2021-01-22'--@lLoadDate
	   AND pm.TargetSystem = 'CS_AHS' 
	   AND pm.ClientKey =1 
	   AND PR.ARN = 1	   
	   ;
	
    INSERT INTO ast.TmpMbrCsPlan (CMK,CsPlanValue, SubGrpId, EffDate, expDate)
    SELECT mm.CMK, mm.CsPlanValue, mm.SubGrpID, mm.StartDateCandidate, mm.StopDate
    FROM ast.TmpMbrCsPlan ast
	   RIGHT JOIN #Tmp_MbrMonthSet  MM 
		  ON ast.CMK = mm.Cmk
		  AND ast.CsPlanValue = mm.CsPlanValue
    WHERE ast.Skey is null;

    -- >Term - > INsert (up sert)
    SELECT ast.Skey TermKey, mm.CMK InsertMemberKey
    INTO #tmp_Upsert  --  drop table #tmp_Upsert
    FROM ast.TmpMbrCsPlan ast
	   LEFT JOIN #Tmp_MbrMonthSet  MM 
		  ON ast.CMK = mm.Cmk
		  AND ast.CsPlanValue <> mm.CsPlanValue
    WHERE ast.Skey is null;
    
    -- Upsert - TERM
    UPDATE m SET m.expDate = @TermDate
    FROM ast.TmpMbrCsPlan m
	   JOIN #tmp_Upsert US ON m.Skey = US.TermKey
    -- Upsert - insert
    INSERT INTO ast.TmpMbrCsPlan (CMK, CsPlanValue, SubGrpId, EffDate, expDate)
    SELECT m.CMK, m.CsPlanValue, m.SubGrpID, m.StartDateCandidate, m.StopDate
    FROM #Tmp_MbrMonthSet m
	   JOIN #tmp_Upsert US ON m.CMK = US.InsertMemberKey

    -- Term - term    SELECT ast.Skey TermKey, mm.CMK InsertMemberKey
    UPDATE ast SET ast.expDate = @TermDate    
    FROM ast.TmpMbrCsPlan ast
	   LEFT JOIN #Tmp_MbrMonthSet  MM 
		  ON ast.CMK = mm.Cmk		  
    WHERE mm.CMK is null
    ;
    --select * from #tmp_Upsert
    --select * from #Tmp_MbrMonthSet
    --SELECT * FROM ast.TmpMbrCsPlan
END;

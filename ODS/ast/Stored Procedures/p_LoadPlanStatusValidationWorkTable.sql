CREATE PROCEDURE [ast].[p_LoadPlanStatusValidationWorkTable](@CLIENTKEY INT)
AS
     DECLARE @LoadDate DATE;
     DECLARE @ASOFDATE DATE= GETDATE();
     DECLARE @ACTIVE TINYINT= 1;
     SELECT @LoadDate = MAX(loadDate)--, max(datadate) 
     FROM ast.MbrStg2_MbrData ST
     WHERE st.ClientKey = @clientKey;
     DECLARE @TotalMemberCount INT;
     SELECT @TotalMemberCount = COUNT(DISTINCT st.ClientSubscriberId)
     FROM acecaredw.ast.MbrStg2_MbrData st
     WHERE ClientKey = @ClientKey
           AND LoadDate = @LoadDate;
     DECLARE @ValRunSumSKey TABLE(SKey INT);
     INSERT INTO amd.AceValidationRunSummary(
		  TotalMemberCount, ClientKey, LoadDate, AsOfDate, Active, TestCaseName
		  )
     OUTPUT inserted.SKey INTO @ValRunSumSkey(Skey)
     SELECT @TotalMemberCount TotMemCount
	   , @CLientKey CLientKey
	   , @LoadDate LoadDate
	   , @AsOfDate AsOfDate
	   , @Active [Active]
	   ,  'PlanStatus' TestCaseName;

     BEGIN TRAN;
     DECLARE @SumSKey INT;
     SELECT @SumSKey = s.SKey
     FROM @ValRunSUmSKey s;
     INSERT INTO amd.AceValidationDetails([SrcRowSkey], [TestedColumnValue], [TestCase], 
				[srcTableName], [SummarySkey], [TestResultStatus])
            SELECT st.mbrStg2_MbrDataUrn, ST.TestedColumnValue, st.TestCase, 
                   st.SrcTableName, @SumSkey, st.TestResultStatus
            FROM(SELECT ST.mbrStg2_MbrDataUrn, pm.ACTIVE TestedColumnValue, ' PlanStatus' TestCase, 
                       'ast.MbrStg2_MbrData' SrcTableName, st.ClientSubscriberId, st.ClientKey, st.LoadDate,
                       CASE WHEN (pm.TargetValue IS NULL AND PM.ACTIVE = 'Y') THEN 2
                           ELSE 1 END AS TestResultStatus
                FROM acecaredw.ast.MbrStg2_MbrData ST
                     LEFT JOIN (SELECT DISTINCT pm.clientkey, pm.targetsystem, pm.TargetValue, pm.EffectiveDate, pm.ExpirationDate, pm.ACTIVE--, pm.sourceValue
						  FROM ACECAREDW.[lst].[lstPlanMapping] PM
						  WHERE pm.TargetSystem = 'CS_AHS'
				    ) pm 
				ON PM.TargetValue = ST.plnProductSubPlanName
                WHERE ST.LoadDate = @Loaddate	  AND @LoadDate BETWEEN PM.EffectiveDate AND PM.ExpirationDate
                      AND ST.ClientKey = @ClientKey AND PM.ClientKey = @CLIENTKEY                      
                      
            ) ST
            
     COMMIT TRAN;

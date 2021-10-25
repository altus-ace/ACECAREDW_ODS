




CREATE PROCEDURE [ast].[p_LoadPlanMAppingCheckValidationWorkTable]  (@CLIENTKEY INT )
AS 
DECLARE @LoadDate DATE;
     DECLARE @ASOFDATE DATE = getdate();
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

	INSERT INTO amd.AceValidationRunSummary
     (TotalMemberCount, 
      ClientKey, 
      LoadDate, 
      AsOfDate, 
      Active, 
      TestCaseName
     )
	OUTPUT inserted.SKey INTO @ValRunSumSkey(Skey)
            SELECT @TotalMemberCount TotMemCount, 
                   @CLientKey CLientKey, 
                   @LoadDate LoadDate, 
                   @AsOfDate AsOfDate, 
                   @Active [Active], 
                   'PlanMAppingCheck' TestCaseName;
     
	BEGIN TRAN;
	
	DECLARE @SumSKey INT;
	SELECT @SumSKey = s.SKey from @ValRunSUmSKey s
	

     INSERT INTO amd.AceValidationDetails
     ([SrcRowSkey], 
      [TestedColumnValue], 
      [TestCase], 
      [srcTableName], 
      [SummarySkey],
	  [TestResultStatus]
     )
	  SELECT st.mbrStg2_MbrDataUrn, ST.TestedColumnValue, st.TestCase, 
       st.SrcTableName, @SumSkey, st.TestResultStatus
	   FROM(SELECT st.mbrStg2_MbrDataUrn, st.plnProductSubPlanName TestedColumnValue
			 , ' PlanMAppingCheck' TestCase, 'ast.MbrStg2_MbrData' SrcTableName
			 , st.ClientSubscriberId, st.ClientKey, st.LoadDate
			 , CASE WHEN pm.TargetValue IS NULL THEN 2 ELSE 1 END AS TestResultStatus
		  FROM acecaredw.ast.MbrStg2_MbrData ST
         LEFT JOIN (SELECT DISTINCT  pm.clientkey, pm.targetsystem, pm.TargetValue
				    , pm.EffectiveDate, pm.ExpirationDate, pm.ACTIVE--, pm.sourceValue
				FROM ACECAREDW.[lst].[lstPlanMapping] PM
				WHERE pm.TargetSystem = 'CS_AHS'
				) pm 
			 ON PM.TargetValue = ST.plnProductSubPlanName
    WHERE ST.LoadDate = @Loaddate
          AND ST.ClientKey = @ClientKey
          AND PM.ClientKey = @CLIENTKEY
          AND @LoadDate BETWEEN PM.EffectiveDate AND PM.ExpirationDate
    ) ST;

	COMMIT TRAN; 
  	   



CREATE PROCEDURE [ast].[p_LoadPrvTinNotNullValidationWorkTable]  (@CLIENTKEY INT )
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
                   'PrvTinNotNull' TestCaseName;
     
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
	     SELECT st.mbrStg2_MbrDataUrn
			  ,ST.TestedColumnValue
			  ,st.TestCase
			  ,st.SrcTableName
			  ,@SumSkey
			  ,st.TestResultStatus
            FROM( SELECT st.MbrStg2_MbrDataUrn,prvTin TestedColumnValue, 'PrvTinNotNull' TestCase, 'ast.MbrStg2_MbrData'SrcTableName
				    ,st.ClientKey,st.LoadDate,case when   st.MstrMrnKey is null then 2  else 1 end as TestResultStatus
			 FROM acecaredw.ast.MbrStg2_MbrData st
			 WHERE ClientKey = @clientkey
			 AND LoadDate = @Loaddate
			 )st;

	   COMMIT TRAN; 
	  

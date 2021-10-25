CREATE PROCEDURE [ast].[p_LoadPhnMmbrsInMmbrDtlNotNullValidationWorkTable](@CLIENTKEY INT)
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
     INSERT INTO amd.AceValidationRunSummary
     (TotalMemberCount, 
      ClientKey, 
      LoadDate, 
      AsOfDate, 
      Active, 
      TestCaseName
     )
     OUTPUT inserted.SKey
            INTO @ValRunSumSkey(Skey)
            SELECT @TotalMemberCount TotMemCount, 
                   @CLientKey CLientKey, 
                   @LoadDate LoadDate, 
                   @AsOfDate AsOfDate, 
                   @Active [Active], 
                   'PhoneMembersInMemberDetail' TestCaseName;
     BEGIN TRAN;
     DECLARE @SumSKey INT;
     SELECT @SumSKey = s.SKey
     FROM @ValRunSUmSKey s;
     INSERT INTO amd.AceValidationDetails
     ([SrcRowSkey], 
      [TestedColumnValue], 
      [TestCase], 
      [srcTableName], 
      [SummarySkey], 
      [TestResultStatus]
     )
            SELECT st.MbrStg2_PhoneAddEmailUrn, 
                   ST.TestedColumnValue, 
                   st.TestCase, 
                   st.SrcTableName, 
                   @SumSkey, 
                   st.TestResultStatus
            FROM
            (
                SELECT st.MbrStg2_PhoneAddEmailUrn, 
                       st.ClientMemberKey TestedColumnValue, 
                       'PhoneMembersInMemberDetail' TestCase, 
                       'ast.MbrStg2_MbrData' SrcTableName, 
                       st.ClientMemberKey, 
                       st.ClientKey, 
                       st.LoadDate,
                       CASE
                           WHEN mbr.ClientSubscriberId IS NULL
                           THEN 2
                           ELSE 1
                       END AS TestResultStatus
                FROM ast.MbrStg2_PhoneAddEmail st
                     LEFT JOIN ast.MbrStg2_MbrData Mbr ON st.ClientMemberKey = Mbr.ClientSubscriberId
                WHERE st.ClientKey = @CLientkey and mbr.ClientKey = @CLientkey 
                      AND st.LoadDate = @LoadDate and mbr.LoadDate = @LoadDate
            ) ST;
     COMMIT TRAN;

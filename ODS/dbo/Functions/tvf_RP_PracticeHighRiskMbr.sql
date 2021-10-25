/****** Script for SelectTopNRows command from SSMS  ******/
/*Request number 71-NCQA identify high risk memebrs for pcp*/
CREATE FUNCTION [dbo].[tvf_RP_PracticeHighRiskMbr](@Name nvarchar(100))
RETURNS TABLE
AS
     RETURN
( 

SELECT  AM.[PCP_PRACTICE_TIN]
      ,ltrim(rTRIM(UPPER(A.Name))) AS PCP_PRACTICE_NAME
     ,AM.[PCP_NPI]
     ,AM.[PCP_FIRST_NAME]+' '+[PCP_LAST_NAME] As PCP_NAME 
	 ,AM.[MEMBER_ID]
      ,AM.[MEMBER_FIRST_NAME]+' '+[MEMBER_LAST_NAME] AS MEMBER_NAME
      ,AM.[DATE_OF_BIRTH]
      ,convert(float,AM.[IPRO_ADMIT_RISK_SCORE]) AS RISK_SCORE
	-- ,AM.[IPRO_ADMIT_RISK_SCORE] AS RISK_SCORE1
      ,AM.[LAST_PCP_VISIT]
  FROM [ACECAREDW].[dbo].[vw_UHC_ActiveMembers] AM
  INNER JOIN tmpSalesforce_Account A ON CONVERT(INT,A.Tax_ID_Number__c)=
  CONVERT(INT,AM.PCP_PRACTICE_TIN)
  
  where A.Name=@name
  --ORDER BY IPRO_ADMIT_RISK_SCORE DESC
  );
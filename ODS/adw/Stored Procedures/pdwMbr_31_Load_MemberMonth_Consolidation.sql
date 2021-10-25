
CREATE PROCEDURE	[adw].[pdwMbr_31_Load_MemberMonth_Consolidation]
					(@LoadDate DATE, @ClientKey INT)

AS

BEGIN  --  DECLARE @LoadDate DATE = '2021-04-12' DECLARE @ClientKey INT = 12

		INSERT INTO		 [dbo].[TmpAllMemberMonths]
						([MemberMonth]
						,[CLientKey]
						,[LOB]
						,[ClientMemberKey]
						,[PCP_NPI]
						,[PLAN_ID]
						,[PLAN_CODE]
						,[SUBGRP_ID]
						,[SUBGRP_NAME]
						,[PCP_PRACTICE_TIN]
						,[PCP_PRACTICE_NAME]
						,[MEMBER_FIRST_NAME]
						,[MEMBER_LAST_NAME]
						,[GENDER]
						,[AGE]
						,[DATE_OF_BIRTH]
						,[MEMBER_HOME_ADDRESS]
						,[MEMBER_HOME_ADDRESS2]
						,[MEMBER_HOME_CITY]
						,[MEMBER_HOME_STATE]
						,[MEMBER_HOME_ZIP]
						,[MEMBER_HOME_PHONE]
						,[IPRO_ADMIT_RISK_SCORE]
						,[RunDate]
						,[RunBy])  --  DECLARE @LoadDate DATE = '2021-04-12' DECLARE @ClientKey INT = 12
			 SELECT   ---All Clients with the exception of UHC 
						MemberMonth,
						a.CLientKey,
						a.LOB,
						a.Client_SubScriber_ID,
						a.NPI, 
						a.PLAN_ID,
						a.PLAN_CODE,
						a.SUBGRP_ID,
						a.SUBGRP_NAME,
						a.PCP_PRACTICE_TIN,
						a.PCP_PRACTICE_NAME,
						a.MEMBER_FIRST_NAME,
						a.MEMBER_LAST_NAME,
						a.GENDER,
						a.AGE, 
						a.DATE_OF_BIRTH,
						a.MEMBER_HOME_ADDRESS,
						a.MEMBER_HOME_ADDRESS2,
						a.MEMBER_HOME_CITY,
						a.MEMBER_HOME_STATE,
						a.MEMBER_HOME_ZIP_C,
						a.MEMBER_HOME_PHONE,
						a.ClientRiskScore,
						GETDATE() [RunDate],
						SUSER_NAME() [RunBy]
			FROM		(
							SELECT   ---All Clients with the exception of UHC
											@LoadDate MemberMonth,
											a.CLientKey,
											(SELECT LobName FROM lst.List_Client WHERE ClientKey = @ClientKey)  AS LOB,  
											a.Client_SubScriber_ID,
											a.NPI,		/*Replaced PCP_Client_ID, */
											'' AS PLAN_ID,
											a.PLAN_CODE,
											a.SUBGRP_ID,
											a.SUBGRP_NAME,
											a.PCP_PRACTICE_TIN,
											a.PCP_PRACTICE_NAME,
											a.MEMBER_FIRST_NAME,
											a.MEMBER_LAST_NAME,
											a.GENDER,
											a.AGE, 
											a.DATE_OF_BIRTH,
											a.MEMBER_HOME_ADDRESS,
											a.MEMBER_HOME_ADDRESS2,
											a.MEMBER_HOME_CITY,
											a.MEMBER_HOME_STATE,
											a.MEMBER_HOME_ZIP_C,
											a.MEMBER_HOME_PHONE,
											a.ClientRiskScore,
											GETDATE() [RunDate],
											SUSER_NAME() [RunBy]
											,ROW_NUMBER()OVER(PARTITION BY a.Client_SubScriber_ID ORDER BY Client_SubScriber_ID)RwCnt
								FROM		dbo.tvf_Activemembers(@LoadDate) a  -- @LoadDate
								WHERE		ClientKey =  @ClientKey -- 9
					 )a
			WHERE	a.RwCnt = 1
		
	END


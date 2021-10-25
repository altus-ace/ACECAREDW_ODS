

 CREATE VIEW  [dbo].[vw_Active_Member_Trend_by_Practice_LOB_Client] AS
SELECT DISTINCT  S.TIN ,CASE WHEN S.CLIENT = 'AET' THEN 'AETNA MA' 
							 WHEN S.CLIENT = 'AetCom' THEN 'AETNA Comm'
							 ELSE S.CLIENT END AS CLIENT,
							 PRACTICE_NAME,NA.ACE_CONTACT,na.POD,
	   S.MEMBER_ID,S.[MEMBER_FIRST_NAME] AS [FIRST NAME],
				   S.[MEMBER_LAST_NAME] AS [LAST NAME],
				   S.[DATE_OF_BIRTH] AS DOB,
				   S.MEMBER_HOME_ADDRESS AS [HOME ADDRESS1],
				   S.MEMBER_HOME_ADDRESS2 AS [HOME ADDRESSS2],
				   S.MEMBER_HOME_CITY AS CITY,
				   S.MEMBER_HOME_STATE AS STATE,
				   S.MEMBER_HOME_ZIP AS ZIPCODE,
				   S.MEMBER_HOME_PHONE AS PHONE,
				   s.SUBGRP_NAME as PLAN_NAME,
				   S.[IPRO_ADMIT_RISK_SCORE] as Client_Risk_Score

	  FROM (
			SELECT  DISTINCT CONVERT(INT,a.Tax_ID_number__c) AS TIN,
					   a.Name AS PRACTICE_NAME,
					   a.network_contact__c AS ACE_CONTACT,
					   cc.Provider_NPI__c AS NPI,
					   cc.firstName,
					   cc.Lastname,
					 z.Quadrant__C as pod
				FROM tmpsalesforce_account a
					 INNER JOIN tmpsalesforce_contact cc ON cc.accountId = a.id
					inner join tmpsalesforce_account_locations__C ac on ac.account_name__c=a.id and ac.location_type__C='Primary'
					inner join tmpsalesforce_zip_code__C z on z.id=ac.zip_code__c
				WHERE --a.Termination_with_cause__c = 'ACTIVE' and 
				cc.status__C = 'Active'
				--and a.Tax_ID_number__c = '10972233'
			) AS na
 right JOIN(
		   SELECT DISTINCT a.client,a.Member_id,
				   CONVERT(INT,a.pcp_practice_tin) AS TIN,
				   a.NPI,
				   a.[MEMBER_FIRST_NAME],
				   a.[MEMBER_LAST_NAME],
				   a.[DATE_OF_BIRTH],
				   a.MEMBER_HOME_ADDRESS,
				   a.MEMBER_HOME_ADDRESS2,
				   a.MEMBER_HOME_CITY,
				   a.MEMBER_HOME_STATE,
				   a.MEMBER_HOME_ZIP_C  AS MEMBER_HOME_ZIP,
				   a.MEMBER_HOME_PHONE,
				   a.SUBGRP_NAME,
				   a.[IPRO_ADMIT_RISK_SCORE]
			FROM acecaredw.dbo.vw_activeMembers a 
			inner join [dbo].[vw_Aetna_ProviderRoster] p on convert(int,p.[tax id])=CONVERT(INT,a.pcp_practice_tin) 
			and p.lob='Medicare Advantage' and p.term_date__C is null
			WHERE a.CLIENT='AET' 

			UNION

			SELECT DISTINCT 
					a.client,
					a.Member_id,
				   CONVERT(INT,a.pcp_practice_tin) AS TIN,
				   a.NPI,
				   a.[MEMBER_FIRST_NAME],
				   a.[MEMBER_LAST_NAME],
				   a.[DATE_OF_BIRTH],
				   a.MEMBER_HOME_ADDRESS,
				   a.MEMBER_HOME_ADDRESS2,
				   a.MEMBER_HOME_CITY,
				   a.MEMBER_HOME_STATE,
				   a.MEMBER_HOME_ZIP_C  AS MEMBER_HOME_ZIP,
				   a.MEMBER_HOME_PHONE,
				   a.SUBGRP_NAME,
				   a.[IPRO_ADMIT_RISK_SCORE]
			FROM acecaredw.dbo.vw_activeMembers a 
			inner join [dbo].[vw_Aetna_ProviderRoster] p on convert(int,p.[tax id])=CONVERT(INT,a.pcp_practice_tin) 
			and p.lob='Commercial'	-- Added by Robert for differentiate ACETA MA VS COMMERCIAL ON 6/28/2019
			and p.term_date__C is null
			WHERE a.CLIENT='AetCom'

			UNION

			SELECT DISTINCT A.client,A.Member_id,
				   CONVERT(INT,A.pcp_practice_tin) AS TIN,
				 a.NPI,
				   a.[MEMBER_FIRST_NAME],
				   a.[MEMBER_LAST_NAME],
				   a.[DATE_OF_BIRTH],
				   a.MEMBER_HOME_ADDRESS,
				   a.MEMBER_HOME_ADDRESS2,
				   a.MEMBER_HOME_CITY,
				   a.MEMBER_HOME_STATE,
				   a.MEMBER_HOME_ZIP_C  AS MEMBER_HOME_ZIP,
				   a.MEMBER_HOME_PHONE,
				   a.SUBGRP_NAME,
				   a.[IPRO_ADMIT_RISK_SCORE]
			FROM acecaredw.dbo.vw_activeMembers A
		   INNER JOIN ACECAREDW.ADW.MbrWlcProviderLookup L ON convert(int,l.npi)=convert(int,a.npi)
			 WHERE CLIENT='WLC'

			UNION

			SELECT DISTINCT 'UHC' AS Client,Member_id,
				  case when  pcp_practice_tin='752894111' then '300491632' else CONVERT(INT,pcp_practice_tin) end AS TIN,
				   PCP_NPI AS NPI,
				   a.[MEMBER_FIRST_NAME],
				   a.[MEMBER_LAST_NAME],
				   a.[DATE_OF_BIRTH],
				   a.MEMBER_HOME_ADDRESS,
				   a.MEMBER_HOME_ADDRESS2,
				   a.MEMBER_HOME_CITY,
				   a.MEMBER_HOME_STATE,
				   a.MEMBER_HOME_ZIP_C  AS MEMBER_HOME_ZIP,
				   a.MEMBER_HOME_PHONE,
				   a.SUBGRP_NAME,
				   a.[IPRO_ADMIT_RISK_SCORE]
			FROM acecaredw.dbo.vw_UHC_ActiveMembers a
			--where pcp_practice_tin = '200462905'
			) s ON CONVERT(INT, na.tin) = CONVERT(INT, S.TIN)


			--SELECT * FROM dbo.vw_Active_Member_Trend_by_Practice_LOB_Client






/*****************************************************************
CREATED BY : TS
CREATE DATE : 01/08/2020
vw_Member_Master_Trend_by_Practice_LOB_Client
DESCRIPTION : The Process to create data for Historical members months for All Members for ALL CLIENTS IN PRODUCTION

Tasks to make deploy ready: 
0. get bus and IT requirements		    -> docuement
1. ACECAREDW.[dbo].[tmpAllMemberMonths]	    -> convert to a adw table until Fct Mbr is implement
2.ACECAREDW.DBO.GetMemberAllMonths(Proc)    -> run each for each month to get history caught up, after it needs to be scheduled to run 
3.Acecaredw.dbo.load_tmpAllMemberMonths	    -> called by GetMemberAllMonths - make callable for a historical month
4.change to use vw_allclient_providerROster ->
5.add other clients					    -> 
    a. Add SHCN					    ->not sure of impact or work load for SHCN will be differnt
    b. Add DHTX, cignaMa:			    ->DHTX, cignaMa: should be call Load_tmpAllMemberMonths for dhtx

MODIFICATION:
USER        DATE        COMMENT
TS      1/13/2020    update to be done using [dbo].[vw_NetworkRoster] to replace all the Salesforce tables
TS      1/30/2020    Added Subgroupname field for the purpose of identifying and grouping plan name
Brit    2021/01/27   Added NPI 

 
******************************************************************/


CREATE VIEW  [dbo].[yy_vw_Member_Master_Trend_by_Practice_LOB_Client] 
AS
/*
The Object is created to get All Members Historical Data of Plans for AETNA MA & COMMERCIAL, WELLCARE of TX AND UCH
Note: update to be done using [dbo].[vw_NetworkRoster] to replace all the Salesforce tables


*/
SELECT   Distinct        S.MemberMonth,
                 S.PCP_PRACTICE_TIN AS TIN, 
                 CASE WHEN S.ClientKey = CONVERT(INT,3) THEN 'AETNA MA' 
							 WHEN S.ClientKey  = CONVERT(INT,9)THEN 'AETNA Comm'
							 WHEN S.ClientKey  = CONVERT(INT,2) THEN 'WLC'
							 WHEN S.ClientKey  = CONVERT(INT,1) THEN 'UHC'
							 ELSE '' END AS CLIENT,
                S.LOB,
				S.SUBGRP_NAME,
				S.PCP_PRACTICE_NAME AS PRACTICE_NAME,
				'' as ACE_CONTACT,
				s.BillingPOD,
	            S.ClientMemberKey AS MEMBER_ID,
				S.[MEMBER_FIRST_NAME] AS [FIRST NAME],
				S.[MEMBER_LAST_NAME] AS [LAST NAME],
				S.GENDER,
				S.AGE,
				S.[DATE_OF_BIRTH] AS DOB,
				S.MEMBER_HOME_ADDRESS AS [HOME ADDRESS1],
				S.MEMBER_HOME_ADDRESS2 AS [HOME ADDRESSS2],
				S.MEMBER_HOME_CITY AS CITY,
				S.MEMBER_HOME_STATE AS STATE,
				S.MEMBER_HOME_ZIP AS MEMBER_ZIPCODE,
				S.MEMBER_HOME_PHONE AS PHONE,
				S.PLAN_ID,
				s.SUBGRP_NAME as PLAN_NAME,
				S.[IPRO_ADMIT_RISK_SCORE] as Client_Risk_Score,
				s.primaryzip as PROVIDER_ZIPCODE,
				s.PCP_NPI
				,s.AccountType

	  FROM		(		SELECT DISTINCT * FROM [dbo].[tmpAllMemberMonths] t
						LEFT JOIN   ( 
										SELECT 
										a.BillingPOD,
										a.TIN,
										a.Primaryzip,
										a.npi
										,a.AccountType
						FROM			[ACECAREDW].[dbo].[vw_AllClient_ProviderRoster_PCPANDSPEC]a 
									)a   
						ON t.pcp_npi=a.npi
				) S
	--order by client

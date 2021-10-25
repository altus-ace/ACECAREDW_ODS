
CREATE VIEW [dbo].[yy_vw_RP_LOBPracticeActiveMembership_HQ]
AS
    /* Purpose: Extract PCP TIN pivot by LOB/Client 
    
    VERSION History :  RPT_182
    GK: 09/28: Add 
	   1. CMS MSSP Membership  Pivot to new SHCN_MSSP Column
	   2. Rows are Pcp TIN level	   
	   3. New State column (2-letter abbrev.) from AllClientProviderRoster	  '
    gk: 11/09: Added Provider roster to the active members, to get Group Name and pod, joined  accross pivot on tin, group name and pod

	   */

      SELECT DISTINCT TIN, PRACTICE_NAME, ACE_CONTACT, AccountType, PrimaryState,POD
		  , [UHC]
		  , [WLC] AS [WellCare MA]
		  , [AET] AS [AETNA MA]
		  , [CIGNA_MA], [AetCom] AS [AETNA COMM]
		  , 0 AS [CIGNA COMM]
		  , [DHTX] AS Devoted
		  , [SHCN_MSSP] AS ShcnMssp
     FROM(SELECT DISTINCT S.TIN, s.CLIENT, PRACTICE_NAME, AccountType, NA.ACE_CONTACT, na.PrimaryState,na.POD, S.MEMBER_ID
         FROM(SELECT DISTINCT a.TIN, a.GroupName AS PRACTICE_NAME, a.NetworkContact AS ACE_CONTACT, a.PrimaryState, a.PrimaryPOD AS pod, HealthPlan, AccountType			 
			 FROM adw.fctproviderroster a             
			 WHERE CONVERT(DATE, GETDATE()) BETWEEN a.effectivedate AND a.expirationdate
				AND a.LastUpdatedDate =(SELECT MAX(LastUpdatedDate) FROM adw.fctproviderroster)
                    AND (TIN <> '300491632' OR PrimaryPOD = 3) -- to remove multiple occurances of this TIN         				
		  ) AS na
         RIGHT JOIN (SELECT DISTINCT a.Member_id, client.clientshortname AS Client, CONVERT(INT, a.pcp_practice_tin) AS TIN, a.NPI, pr.GroupName As PracticeName
				   , a.PCP_POD_C
				FROM acecaredw.dbo.vw_activeMembers a    
				    JOIN lst.list_client client ON a.ClientKey = client.clientkey -- 48325 all clients 
				    LEFT JOIN dbo.vw_AllClient_ProviderRoster PR  
					   ON a.NPI = pr.NPI
					   and a.PCP_PRACTICE_TIN = pr.TIN 	   
					   and client.ClientKey = pr.CalcClientKey        ) s 
					   ON CONVERT(INT, na.tin) = CONVERT(INT, S.TIN)  
						  and na.PRACTICE_NAME = s.PracticeName     
						  and na.pod = s.PCP_POD_C
	   ) AS P PIVOT(COUNT(MEMBER_ID) FOR CLIENT IN([UHC], 
                                                 [WLC], 
                                                 [AET], 
                                                 [AetCom], 
									    Cigna_MA,
                                                 [DHTX],
									    [SHCN_MSSP] )) pvt
	   ;




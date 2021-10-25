CREATE procedure [ast].[pstLoadExpAhsMemberByPcp] 
AS  
    INSERT INTO ast.[pstExpAhsMemberByPcp] (ClientKey, ClientMemberKey, 
		  expMember_ID, expMemberPcpNpi, ExpProviderRelationshipType, expLOB
		  , expPcpEffectiveDate
		  , expPcpTermDateDate
		  , expMemPcpAddInfo
		  , AdiKey, AdiTableName)
    SELECT DISTINCT mpcp.ClientKey, mpcp.MEMBER_ID Cmk, 
		  mpcp.MEMBER_ID expMemberKey, mpcp.MEMBER_PCP, mpcp.PROVIDER_RELATIONSHIP_TYPE, mpcp.LOB, 
		  mpcp.PCP_EFFECTIVE_DATE, 
		  mpcp.PCP_TERM_DATE, 
		  mpcp.MEMBER_PCP_ADDITIONAL_INFORMATION_1,
		  mpcp.adiKey,
		  Mpcp.adiTableName		  
    FROM (/* New */
		  /* old uhc */
		  (SELECT DISTINCT  uam.MEMBER_ID
			 , 'UHC' AS CLIENT_ID, 1 AS clientKey
			 , uam.PCP_NPI AS MEMBER_PCP
			 , 'PCP' AS PROVIDER_RELATIONSHIP_TYPE
			 , CASE WHEN ALT_MAPPING_TABLES.DESTINATION_VALUE IS NOT NULL
			       THEN ALT_MAPPING_TABLES.DESTINATION_VALUE 
			 	 ELSE 'UHC' END AS LOB
			 , CONVERT(DATE, uam.PCP_EFFECTIVE_DATE) AS PCP_EFFECTIVE_DATE
			 , CONVERT(DATE, '2099-12-31') AS PCP_TERM_DATE
			 , 'A' AS MEMBER_PCP_ADDITIONAL_INFORMATION_1
			 , uam.ACE_MemberByPCP_URN AS adiKey
			 , 'dbo.Uhc_MembersByPcp' AS adiTableName 
		  FROM dbo.vw_UHC_ActiveMembers uam
			 LEFT JOIN dbo.ALT_MAPPING_TABLES ON dbo.ALT_MAPPING_TABLES.SOURCE_VALUE = uam.LINE_OF_BUSINESS
				AND dbo.ALT_MAPPING_TABLES.SOURCE = 'UHC'
				AND dbo.ALT_MAPPING_TABLES.DESTINATION = 'ALTRUISTA'
				AND dbo.ALT_MAPPING_TABLES.TYPE = 'LINE OF BUSINESS'    
		  UNION
		  SELECT DISTINCT utm.MEMBER_ID
			 , 'UHC' AS CLIENT_ID, 1 AS clientKey
			 , utm.PCP_NPI AS MEMBER_PCP
			 , 'PCP' AS PROVIDER_RELATIONSHIP_TYPE
			 , CASE WHEN ALT_MAPPING_TABLES.DESTINATION_VALUE IS NOT NULL
			       THEN ALT_MAPPING_TABLES.DESTINATION_VALUE 
				  ELSE 'UHC' END AS LOB
			 , RTRIM(CONVERT(VARCHAR(10), CONVERT(DATE, utm.PCP_EFFECTIVE_DATE))) AS Pcp_Effective_date
			 , utm.MEMBER_TERM_DATE AS PCP_TERM_DATE 		
			 , 'A' AS MEMBER_PCP_ADDITIONAL_INFORMATION_1
			 , utm.ACE_MemberByPCP_URN AS AdiKey
			 , 'dbo.Uhc_MembersByPcp' AS adiTableName 
		  FROM dbo.vw_UHC_TermedMembers utm
			 LEFT JOIN dbo.ALT_MAPPING_TABLES ON dbo.ALT_MAPPING_TABLES.SOURCE_VALUE = utm.LINE_OF_BUSINESS
				AND dbo.ALT_MAPPING_TABLES.SOURCE = 'UHC'
				AND dbo.ALT_MAPPING_TABLES.DESTINATION = 'ALTRUISTA'
				AND dbo.ALT_MAPPING_TABLES.TYPE = 'LINE OF BUSINESS'

		  ) 
		  UNION /* new UHC Storage */
		  SELECT DISTINCT mbr.ClientMemberKey AS MEMBER_ID, 
			 lc.ClientName AS [CLIENT_ID], lc.ClientKey AS ClientKey,
			 mpcp.NPI AS [MEMBER_PCP], 
			 'PCP' AS [PROVIDER_RELATIONSHIP_TYPE],   			 
			 lc.CS_Export_LobName AS [LOB], 
			 mpcp.EffectiveDate AS [PCP_EFFECTIVE_DATE], 
			 mpcp.ExpirationDate AS [PCP_TERM_DATE], 
			 'A' AS [MEMBER_PCP_ADDITIONAL_INFORMATION_1]
			 , mpcp.mbrPcpKey AS AdiKey
			 , 'adw.mbrpcp' AS adiTableName
		  FROM [adw].mbrMember mbr
			 INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey	
			 INNER JOIN adw.mbrCsPlanHistory cs ON mbr.mbrMemberKey = cs.mbrMemberKey         
				AND GETDATE() BETWEEN cs.EffectiveDate and cs.ExpirationDate
			 INNER JOIN [adw].mbrpcp mpcp ON mpcp.mbrMemberKey = mbr.mbrMemberKey
				AND GETDATE() BETWEEN mpcp.EffectiveDate and mpcp.ExpirationDate
		  WHERE DATEDIFF(day, mpcp.effectivedate, mpcp.expirationdate) > 0
			 --AND Mbr.ClientKey <> 1
			 AND cs.EffectiveDate < cs.ExpirationDate	   
		  ) Mpcp
		
    ;

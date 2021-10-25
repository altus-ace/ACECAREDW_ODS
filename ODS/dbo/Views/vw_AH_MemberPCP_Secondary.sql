


CREATE VIEW [dbo].[vw_AH_MemberPCP_Secondary]
AS
     SELECT DISTINCT
            uam.UHC_SUBSCRIBER_ID AS  MEMBER_ID
          , 'UHC' AS CLIENT_ID
          , uam.PCP_NPI AS MEMBER_PCP
          , 'PCP' AS PROVIDER_RELATIONSHIP_TYPE
          , CASE
                WHEN ALT_MAPPING_TABLES.DESTINATION_VALUE IS NOT NULL
                THEN ALT_MAPPING_TABLES.DESTINATION_VALUE
                ELSE 'UHC'
            END AS LOB
          , RTRIM(CONVERT(VARCHAR(10),CONVERT(DATE, uam.PCP_EFFECTIVE_DATE))) AS PCP_EFFECTIVE_DATE
          , '2099-12-31' AS PCP_TERM_DATE
          , 'A' AS MEMBER_PCP_ADDITIONAL_INFORMATION_1
     FROM dbo.UHC_MembersByPcp uam
          LEFT JOIN (SELECT um.URN, um.UHC_SUBSCRIBER_ID, um.IPRO_ADMIT_RISK_SCORE, um.LINE_OF_BUSINESS AS LOB
				FROM dbo.UHC_Membership AS um
				WHERE(um.A_LAST_UPDATE_FLAG = 'Y')) AS mbrShp ON uam.Uhc_subscriber_id = mbrShp.UHC_Subscriber_id
		LEFT JOIN dbo.ALT_MAPPING_TABLES ON dbo.ALT_MAPPING_TABLES.SOURCE_VALUE = MbrShp.LOB
                                              AND dbo.ALT_MAPPING_TABLES.SOURCE = 'UHC'
                                              AND dbo.ALT_MAPPING_TABLES.DESTINATION = 'ALTRUISTA'
                                              AND dbo.ALT_MAPPING_TABLES.TYPE = 'LINE OF BUSINESS'
	    
	    JOIN (SELECT m.URN
			 , ROW_NUMBER() OVER(PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.A_LAST_UPDATE_DATE ASC) arn
		    FROM dbo.uhc_membersByPcp m
			 WHERE m.A_last_update_FLAG in ('Y', 'L')) urns ON uam.Urn = urns.Urn AND urns.arn = 1
    
    
     UNION
     SELECT DISTINCT
            utm.MEMBER_ID
          , 'UHC' AS CLIENT_ID
          , utm.PCP_NPI AS MEMBER_PCP
          , 'PCP' AS PROVIDER_RELATIONSHIP_TYPE
          , CASE
                WHEN ALT_MAPPING_TABLES.DESTINATION_VALUE IS NOT NULL
                THEN ALT_MAPPING_TABLES.DESTINATION_VALUE
                ELSE 'UHC'
            END AS LOB
          , RTRIM(CONVERT(VARCHAR(10), CONVERT(DATE, utm.PCP_EFFECTIVE_DATE))) AS Pcp_Effective_date
          , utm.MEMBER_TERM_DATE AS PCP_TERM_DATE 

/* terminate the member pcp relationship on member term */

          , 'A' AS MEMBER_PCP_ADDITIONAL_INFORMATION_1
     FROM dbo.vw_UHC_TermedMembers utm
          LEFT JOIN dbo.ALT_MAPPING_TABLES ON dbo.ALT_MAPPING_TABLES.SOURCE_VALUE = utm.LINE_OF_BUSINESS
                                              AND dbo.ALT_MAPPING_TABLES.SOURCE = 'UHC'
                                              AND dbo.ALT_MAPPING_TABLES.DESTINATION = 'ALTRUISTA'
                                              AND dbo.ALT_MAPPING_TABLES.TYPE = 'LINE OF BUSINESS';
    

CREATE VIEW [dbo].[vw_AH_WC_IProInterface]
AS
    /* version history:
	   12/02/2019: GK: added a MbrMember.ClientKey <> 1 clause for member model rollout 
	   */
     SELECT DISTINCT
            mbr.ClientMemberKey AS MEMBER_ID,
            lc.ClientName AS [CLIENT_ID],
            md.FirstName AS [MEMBER_FIRST_NAME],
            md.LastName AS [MEMBER_LAST_NAME],
            md.DOB AS DATE_OF_BIRTH,
            md.[Gender] AS GENDER,
            'N/A' AS RISK_CATEGORY_C,
            'N/A' AS RISK_TYPE,
            '' AS RISK_SCORE,
            CONVERT(DATE, CONVERT(DATETIME, '01/01/2018'),23) AS GC_START_DATE,
            CONVERT(DATE, CONVERT(DATETIME, '12/31/2099'), 23)  AS GC_END_DATE
     FROM [adw].mbrMember mbr
          INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey        
		  --
          INNER JOIN [adw].MbrDemographic md ON md.mbrMemberKey = mbr.mbrMemberKey
          INNER JOIN [adw].mbrpcp mpcp ON mpcp.mbrMemberKey = mbr.mbrMemberKey
	WHERE Mbr.ClientKey <> 1
	--   AND lc.ClientKey in (2,3)                                                     
	  
    ;

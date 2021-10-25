




/* view for exporting members by pcp */
CREATE VIEW [dbo].[vw_AH_WC_MemberPCP]
AS
    /* version history:
	   12/02/2019: GK: added a MbrMember.ClientKey <> 1 clause for member model rollout 
	   */
    SELECT DISTINCT 
           mbr.ClientMemberKey AS MEMBER_ID, 
           lc.ClientName AS [CLIENT_ID], 
           mpcp.NPI AS [MEMBER_PCP], 
           'PCP' AS [PROVIDER_RELATIONSHIP_TYPE],   
           /* GK CHanged to use the new CS_Export_LobName field */    
           -- 'Wellcare' AS [LOB],
           lc.CS_Export_LobName AS [LOB], 
           mpcp.EffectiveDate AS [PCP_EFFECTIVE_DATE], 
           mpcp.ExpirationDate AS [PCP_TERM_DATE], 
           'A' AS [MEMBER_PCP_ADDITIONAL_INFORMATION_1]
		   , mpcp.mbrPcpKey 
		   , mpcp.mbrPcpKey  as FctMemberKey
    FROM [adw].mbrMember mbr
         INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
	    /* GK: 06/04/19 Added a filter for active members per the CS Plan, */
	    INNER JOIN adw.mbrCsPlanHistory cs ON mbr.mbrMemberKey = cs.mbrMemberKey         
		  AND GETDATE() BETWEEN cs.EffectiveDate and cs.ExpirationDate
         INNER JOIN [adw].mbrpcp mpcp ON mpcp.mbrMemberKey = mbr.mbrMemberKey
		  AND GETDATE() BETWEEN mpcp.EffectiveDate and mpcp.ExpirationDate
    WHERE DATEDIFF(day, mpcp.effectivedate, mpcp.expirationdate) > 0
	   --AND Mbr.ClientKey <> 1
	   AND cs.EffectiveDate < cs.ExpirationDate	   
    ;

	
/* Union not required after adding cs_Export_LobName field 
    UNION
     SELECT DISTINCT
            mbr.ClientMemberKey AS MEMBER_ID,
            lc.ClientName AS [CLIENT_ID],
            mpcp.NPI AS [MEMBER_PCP],
            'PCP' AS [PROVIDER_RELATIONSHIP_TYPE],
            'Aetna' AS [LOB],
            mpcp.EffectiveDate AS [PCP_EFFECTIVE_DATE],
            mpcp.ExpirationDate AS [PCP_TERM_DATE],
            'A' AS [MEMBER_PCP_ADDITIONAL_INFORMATION_1]
     FROM [adw].mbrMember mbr
          INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
                                             AND lc.ClientKey = 3
          INNER JOIN [adw].mbrpcp mpcp ON mpcp.mbrMemberKey = mbr.mbrMemberKey;
		*/


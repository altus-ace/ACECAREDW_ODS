




CREATE VIEW [dbo].[vw_AH_WC_Eligibility]
AS
    /* version history:
	   12/02/2019: GK: added a MbrMember.ClientKey <> 1 clause for member model rollout 
	   10/29/2020: GK Added effective> expiration to where clause. 
	   11/19 GK Added Inline View and row number to sort for Latest only Eligiblity
	   11/20 GK Removed the RowNumber Filter to allow only valid effective date rows to be exported 
	   */
     SELECT DISTINCT
            mbr.ClientMemberKey AS [MEMBER_ID],
            lc.ClientName AS CLIENT_ID,
            /* GK: changed to use lc.CS_Export_LobName
		  CASE WHEN (lc.ClientKey = 2) THEN 'WellCare' 
			 WHEN (lc.ClientKey = 3) THEN  'Aetna' 
			 ELSE 'UHC' END AS [LOB],
			 */
		  lc.CS_Export_LobName AS [LOB],
            mpl.MbrCsSubPlanName AS [BENEFIT PLAN],
            'E' AS [INTERNAL/EXTERNAL INDICATOR],
            mpl.effectiveDate AS [START_DATE],
            mpl.ExpirationDate AS [END_DATE]
		  , lc.ClientKey 
     FROM [adw].mbrMember mbr
	   -- add LOB to the lst.List_client table so it can be queried 
          INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
                                        --     AND lc.ClientKey IN (2, 3)
          INNER JOIN 
		  (SELECT CS.MbrMemberKey, cs.MbrCsSubPlanName, cs.EffectiveDate, cs.ExpirationDate		
			  FROM [adw].mbrCsPlanHistory CS
			  WHERE cs.EffectiveDate < cs.ExpirationDate	   ) mpl 
		  ON mpl.mbrMemberKey = mbr.mbrMemberKey
	-- WHERE mbr.ClientKey <> 1 
        
	;


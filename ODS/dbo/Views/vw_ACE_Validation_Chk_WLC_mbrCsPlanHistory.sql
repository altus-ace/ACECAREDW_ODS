

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_mbrCsPlanHistory]
AS
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
     FROM [adw].mbrMember mbr
	-- add LOB to the lst.List_client table so it can be queried 
          INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
                                             AND lc.ClientKey IN (2, 3)
          left JOIN [adw].mbrCsPlanHistory mpl ON mpl.mbrMemberKey = mbr.mbrMemberKey
		where mpl.MbrMemberKey is null
		and GETDATE() between EffectiveDate and ExpirationDate

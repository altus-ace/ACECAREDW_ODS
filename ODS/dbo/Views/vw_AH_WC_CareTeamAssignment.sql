

/* view for Clinical system Care team assignments */
CREATE VIEW [dbo].[vw_AH_WC_CareTeamAssignment]
AS
    /*  PER dbecerril, Assign all team assignment to dbecerril*/
    /* version history:
	   12/02/2019: GK: added a MbrMember.ClientKey <> 1 clause for member model rollout 
	   */
    
     SELECT DISTINCT
           /* GK: Changed to use CS_Export_LobName field 
		 CASE WHEN  lc.clientkey=2 THEN 'Wellcare' ELSE lc.ClientName END AS CLIENT_ID,*/
		 lc.CS_Export_LobName AS [CLIENT_ID],
            mbr.ClientMemberKey AS [MEMBER_ID],
            'dbecerril' AS [USERNAME],
            '8575' AS [CARE_STAFF_ID],
            'E' AS [INTERNAL/EXTERNAL INDICATOR],
            CONVERT(DATE, mbr.CreatedDate)  AS [START_DATE], -- start on the create of the member, this should possibly be a assignment start date if we create an assignment table
            CONVERT(DATE, '12/31/' + convert(VARCHAR(4),YEar(GETDATE())), 101) AS [END_DATE] -- this is the end of the year
     FROM [adw].mbrMember mbr
		JOIN Adw.MbrPlan pln ON mbr.MbrMemberKey = pln.MbrMemberKey
		  AND GETDATE() BETWEEN pln.EffectiveDate and pln.ExpirationDate
		JOIN Adw.MbrPcp  pcp ON mbr.MbrMemberKey = pcp.MbrMemberKey		
		  AND GETDATE() BETWEEN pcp.EffectiveDate and pcp.ExpirationDate
          INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
    WHERE mbr.ClientKey <> 1
	   ;



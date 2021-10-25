
CREATE VIEW [dbo].[vw_PDW_NewMembersNotFromList]
AS	  /* 
	   Version History:
	   12/2/2019: gk: added  MbrMember.clientKey <> 1 clause For MbrModel rollout
	   3/10/2020: GK: cleaned up the code to get a list of effective members, and carve out the members who previously exist 
    */
     SELECT DISTINCT 
            m.clientKey AS [ClientKey], 
            'TOC1' AS [PROG_ID], 
            csp.EffectiveDate AS CREATE_DATE, 
            SYSTEM_USER AS [CREATE_BY], 
            m.ClientMemberkey AS Member_id, 
            csp.EffectiveDate AS DateAppeared, 
            DATEADD(DAY, 90, csp.effectivedate) AS ApptDueDate, 
            lc.ClientKey AS CK
     FROM [adw].[MbrMember] m
	   JOIN adw.mbrCsPlanHistory csp ON m.mbrMemberKey = csp.MbrMemberKey
        INNER JOIN [lst].[List_Client] lc ON lc.Clientkey = m.clientkey 		 
	   JOIN (SELECT src.mbrMemberKey, src.ClientKey
			 FROM (/* get a list of members that are active on the effective date */
				    SELECT mbr.mbrMemberKey, mbr.ClientKey
				    FROM adw.MbrMember mbr
					   JOIN adw.mbrCsPlanHistory Pln	   ON mbr.mbrMemberKey = pln.mbrMemberKey
					   JOIN adw.MbrPcp Pcp	   ON mbr.mbrMemberKey = pcp.mbrMemberKey
				    where 1 = 1 --mbr.clientKey = 11mbr.clientKey = 11
					   AND getdate()  BETWEEN pln.EffectiveDate and pln.ExpirationDate
					   AND getdate()  BETWEEN pcp.EffectiveDate and pcp.ExpirationDate
				    EXCEPT
				    /* carve out the members who have an effective record prior to the PriorMonth Date */
				    SELECT mbr.mbrMemberKey, mbr.ClientKey
				    FROM adw.MbrMember mbr
				        JOIN adw.mbrCsPlanHistory Pln	   ON mbr.mbrMemberKey = pln.mbrMemberKey
				        JOIN adw.MbrPcp Pcp	   ON mbr.mbrMemberKey = pcp.mbrMemberKey
				    where 1 = 1 --mbr.clientKey = 11
				        AND (((DATEADD(day, (-1 * DAY(getDate())), getDate())) > pln.EffectiveDate) AND pln.EffectiveDate < pln.ExpirationDate)
				        AND (((DATEADD(day, (-1 * DAY(getDate())), getDate())) > pcp.EffectiveDate) AND pcp.EffectiveDate < pcp.ExpirationDate)
				    ) src
		  ) MP ON MP.mbrMemberKey = m.mbrMemberKey
          LEFT JOIN adw.MbrPcp mpcp ON mpcp.mbrmemberkey = mp.mbrMemberKey
     WHERE mpcp.mbrmemberkey IS NOT NULL
           AND NOT m.CLIENTKEY IN(1);

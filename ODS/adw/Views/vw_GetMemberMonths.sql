CREATE VIEW [adw].[vw_GetMemberMonths]  
  AS            
  /* purpose: returns member months for each client.       GK: 07/10/2019       
    -- 12/2/2019: added a <> 1 clientKey clause 
  CHANGES NEEDED:       
    1. Uses the Uhc dbo members to creat months, this should be a date dim      
    2. UHC when converted to new model will need to have the dbo clause removed      
    3. the LOB field is a kludged together mess         
    */        
    SELECT 'UHC' AS CLIENT, m.UHC_SUBSCRIBER_ID AS ClientMemberKey
	   , am.Destination as LOB, m.A_LAST_UPDATE_DATE as MemberMonth      
    FROM dbo.UHC_MembersByPCP m          
	   JOIN lst.ListAceMapping am ON m.SUBGRP_ID = am.Source   
		  AND am.MappingTypeKey = 2      
    WHERE m.LoadType = 'P'      
    --ORDER BY m.UHC_SUBSCRIBER_ID, m.A_LAST_UPDATE_DATE asc;            
    UNION            
    SELECT lc.ClientShortName, Mbr.ClientMemberKey          
	   , CASE WHEN (lc.ClientShortName = 'AET') THEN 'MA'               
		  WHEN (lc.ClientShortName = 'AetCom') THEN 'Com'         
		  WHEN (lc.ClientShortName = 'WLC') THEN 'MA' END AS LOB
	   , mbrMonth.MemberMonth      
    FROM adw.MbrMember Mbr
	   JOIN lst.List_Client lc ON Mbr.ClientKey = lc.ClientKey          
	   JOIN adw.MbrCsPlanHistory pl ON Mbr.mbrMemberKey = pl.mbrMemberKey          
	   JOIN (SELECT CONVERT(DATE, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,m.A_LAST_UPDATE_DATE)+1,0))) AS MemberMonth          
			 FROM dbo.UHC_MembersByPCP m              
			 WHERE m.LoadType = 'P'          
			 GROUP BY m.A_LAST_UPDATE_DATE
			 ) MbrMonth 
			 ON MbrMonth.MemberMonth between pl.effectiveDate and pl.ExpirationDate 
	WHERE Mbr.ClientKey <> 1       
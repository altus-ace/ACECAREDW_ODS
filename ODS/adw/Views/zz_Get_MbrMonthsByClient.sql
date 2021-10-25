

CREATE view adw.[zz_Get_MbrMonthsByClient]

AS -- need to add other clients 
    SELECT  lc.ClientShortName ClientShortName, m.URN mbrMonthKey, m.uhc_subscriber_id ClientMemberKey, m.A_LAST_UPDATE_DATE LoadDate
	       , DATEFROMPARTS(Year(m.A_LAST_UPDATE_DATE), month(m.A_LAST_UPDATE_DATE) , 1) MemberMonth
	   from dbo.UHC_MembersByPCP m
		  JOIN lst.List_Client lc ON 1 = lc.ClientKey
	   where m.LoadType = 'P'
	       AND SUBGRP_ID NOT IN ('TX99','1001','1002','1003','0603','0601','0602','0600','0606','0604','0605')
    



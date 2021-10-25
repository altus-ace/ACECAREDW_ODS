CREATE VIEW [adw].[vw_Dashboard_GHHIncomingNotifications]
  AS  
select * 
     FROM ACECAREDW.adi.NtfGhhNotifications a
	       left JOIN
     (
         SELECT ms.MstrMrnKey, 
                od.ClientKey, 
				clt.ClientName,
                od.ClientMemberKey
         FROM acempi.adw.MPI_ClientMemberAssociationHistoryODS od
              JOIN acempi.adw.MPI_MstrMrn ms ON od.MstrMrnKey = ms.MstrMrnKey
			  JOin lst.List_Client clt ON clt.ClientKey = od.ClientKey
     ) b ON b.MstrMrnKey = a.AceID;



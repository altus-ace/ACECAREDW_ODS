
CREATE VIEW [ast].[VW_Pst2_StagingTableRowStatus]
AS 
    /* Purpose:  what is the status of the pst tables */
    SELECT Client.ClientShortName, Client.ClientKey, rs.Type, rs.LoadDate, rs.stgRowStatus, rs.CountRows
    FROM (
	   SELECT 'mbr' type, s.loadDate, s.stgRowStatus, count(s.mbrStg2_MbrDataUrn) CountRows, s.ClientKey
	   FROM (SELECT m.mbrStg2_MbrDataUrn, m.ClientSubscriberID, m.LoadDate, m.stgRowStatus, m.ClientKey
	   	  FROM [ast].[MbrStg2_MbrData] m		  
	   	  ) s
	   Group by s.ClientKey, s.loadDate , s.stgRowStatus
	   --order by s.loadDate DESC, s.stgRowStatus    
	   UNION ALL
	   SELECT 'Phn' Type, s.LoadDate, s.stgRowStatus, count(s.MbrStg2_PhoneAddEmailUrn) CountRows, s.ClientKey
	   FROM(SELECT p.MbrStg2_PhoneAddEmailUrn, p.ClientMemberKey, p.loadDate, p.stgRowStatus, p.ClientKey
	   	  FROM [ast].[MbrStg2_PhoneAddEmail] p		  
	   	  ) s
	   Group by s.ClientKey, s.loadDate , s.stgRowStatus
	   ) rs
    JOIN lst.List_Client Client ON rs.ClientKey = Client.ClientKey
    --order by ClientKey, loadDate DESC, stgRowStatus, Type
    

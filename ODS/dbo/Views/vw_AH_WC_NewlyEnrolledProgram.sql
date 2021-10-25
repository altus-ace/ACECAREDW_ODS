

/* dev view for exporting Newly Enrolled into Clinical System */
CREATE VIEW [dbo].[vw_AH_WC_NewlyEnrolledProgram]
AS
    /* version history:
	   12/02/2019: GK: added a MbrMember.ClientKey <> 1 clause for member model rollout
		  Needs to be made to work for all clients.
	   */
     SELECT client.CS_Export_LobName, 
	'Newly Enrolled' as [Program_Name],
	'2018-03-01' as [Enroll_date],
	'2018-03-22' as [Create_date],
	Mbr.ClientMemberKey AS [MEMBER_ID],
	'2018-05-31' as [Enroll_END_DATE],
	--SUBSTRING(patient, CHARINDEX('(', patient)+1, CHARINDEX(')', patient)-CHARINDEX('(', patient)-1) AS [MEMBER_ID],
		  'ACTIVE' as Program_status,
		  'Enrolled in a Program' as REASON_DESCRIPTION,
          'External' as [REFERAL_TYPE]
		, Client.ClientKey
     FROM adw.MbrMember Mbr
	   JOIN lst.List_Client Client on mbr.ClientKey = Client.ClientKey
     WHERE Mbr.ClientKey = 2 
	   AND Mbr.ClientKey <> 1
  /*  UNION 
    SELECT pe.Client_id, 
       pe.Program_Name, 
       pe.Enroll_date, 
       pe.Create_date, 
       pe.Member_id, 
       pe.Enroll_END_DATE, 
       pe.PROGRAM_STATUS, 
       pe.REASON_DESCRIPTION, 
       pe.REFERAL_TYPE    
	  , client.ClientKey
    FROM ACDW_CLMS_CIGNA_MA.[dbo].[tmp_VW_AH_PROGRAMENROLLMENT] pe
	   JOIN (SELECT  * FROM lst.List_Client WHERE ClientKey = 12) AS Client 
		  ON pe.Client_id = Client.CS_Export_LobName
     WHERE Client.ClientKey = 12
	;*/
	   



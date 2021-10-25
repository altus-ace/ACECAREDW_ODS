CREATE FUNCTION [abl].[tvf__AH_PE_CareOps_ByClient](@ClientKey int)
RETURNS TABLE
AS RETURN
(	   
	SELECT co.[CLIENT_ID]
	         ,co.[PROGRAM_NAME]
	         ,co.[MEMBER_ID]
		    /* format dates for AHS Export */
	         ,CONVERT(DATE, co.[ENROLL_DATE]	  , 101) AS ENROLL_DATE
	         ,CONVERT(DATE, co.[CREATE_DATE]	  , 101) AS CREATE_DATE
	         ,CONVERT(DATE, co.[ENROLL_END_DATE]   , 101) AS ENROLL_END_DATE
	         ,co.[PROGRAM_STATUS]
	         ,co.[REASON_DESCRIPTION]
	         ,co.[REFERAL_TYPE]
	   	 , c.ClientKey
	   	 , c.ClientShortName
	       FROM [dbo].[vw_AH_PE_UHC_Careopps] co
	           JOIN lst.List_Client c ON co.CLIENT_ID = c.CS_Export_LobName    
	       WHERE-- Enroll_Date >= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) AND 
			 (((@clientKEY <> 0) AND (c.ClientKey = @ClientKey))
				OR (@ClientKey = 0))
	
) 

CREATE Function [abl].[tvf_AH_PE_NewlyEnrolledFromActiveMembers]
     ( 
	@ClientKey INT    
	)    
    RETURNS TABLE 
AS 
RETURN
    SELECT Client.CS_Export_LobName AS CLIENT_ID
        , TRY_CONVERT(VARCHAR(1000), ClinicalPrograms.ProgramName) AS PROGRAM_NAME
        , TRY_CONVERT(DATE,GETDATE()) as ENROLL_DATE
        , TRY_CONVERT(DATE,GETDATE()) AS Create_date
        , TRY_CONVERT(DATE,DATEADD(day, 90, getdate())) Enroll_End_date
        , AM.MEMBER_ID
        , 'ACTIVE' PROGRAM_STATUS 
        , 'Enrolled in a Program' AS REASON_DESCRIPTION
        , Client.CS_Export_LobName + ' ' + 'New Membership' AS REFERAL_TYPE
        , client.ClientKey
    FROM dbo.vw_activemembers AM
        JOIN lst.List_Client Client ON am.clientKey = Client.ClientKey
        JOIN lst.lstClinicalPrograms ClinicalPrograms
    	   ON ClinicalPrograms.PRogramName = 'Newly Enrolled'
    WHERE am.ClientKey = @ClientKey
;



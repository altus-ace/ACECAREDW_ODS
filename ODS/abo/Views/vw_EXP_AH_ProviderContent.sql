

CREATE VIEW [abo].[vw_EXP_AH_ProviderContent]
AS 
    /* Objective: Extract from the provider roster the data for AHS Provider details
        Version History:
    	   9/3/2020: Created view from old view dbo.vw_AH_ProviderContent
    	   */
    SELECT pr.NPI AS PROVIDER_ID
        , Client.ClientShortName AS CLient_ID
        , pr.NPI AS PROVIDER_NPI
        , [adi].[udf_ConvertToCamelCase](pr.FirstName) + ' ' + [adi].[udf_ConvertToCamelCase](pr.LastName)  AS PROVIDER_FULLNAME    
        , pr.AceProviderID AS ACE_PROVIDER_ID -- WHAT IS THIS? WHERE DOES IT COME FROM WHY IS IT IN AHS?
        , pr.ProviderType AS PROVIDERTYPE
        , pr.AceAccountID AS [GROUP ID] -- what is this where does it come from ? why is it in aHS
        , pr.GroupName AS AFFILIATED_GROUP_NAME
        , pr.FirstName, '' AS MiddleName, pr.LastName
        , CASE WHEN ISNULL(pr.Sub_Speciality, '') <> '' THEN  pr.PrimarySpeciality + ', ' + pr.Sub_Speciality ELSE pr.PrimarySpeciality END AS  SPECIALTY
        , pr.Degree AS DEGREE
        , pr.ethnicity AS ETHNICITY
        , pr.LanguagesSpoken AS LANGUAGESSPOKEN
        , pr.Provider_DOB AS PROVIDER_DATE_OF_BIRTH
        , 'U' AS PROVIDER_GENDER
        , pr.NetworkContact AS ACE_NETWORK_CONTACT        
    FROM [dbo].[vw_AllClient_ProviderRoster] pr
        JOIN lst.List_Client Client ON pr.CalcClientKey = Client.ClientKey
    WHERE ISNULL(pr.TIN, '0') <> '0' and ISNULL(pr.NPI, '0') <> '0'
	UNION
	
    SELECT DISTINCT CONVERT(NVARCHAR(50), pcp.NPI) AS [PROVIDER_ID], 
             Client.ClientShortName AS [CLIENT_ID], 
             CONVERT(NVARCHAR(50), pcp.NPI) AS [PROVIDER_NPI], 
             pcp.PCP_FIRST_NAME +' ' + pcp.PCP_LAST_NAME AS [PROVIDER_FULLNAME], 
             '' [ACE_PROVIDER_ID], 
             Client.ClientShortName  + ' PCP' AS [PROVIDERTYPE], 
             isnull(pcp.PCP_PRACTICE_TIN ,'') AS [GROUP ID], 
             isnull(pcp.PCP_PRACTICE_NAME,'') AS [AFFILIATED_GROUP_NAME], 
             pcp.PCP_FIRST_NAME [FIRSTNAME], 
             '' [MIDDLENAME], 
             pcp.PCP_LAST_NAME [LASTNAME], 
             '' [SPECIALTY], 
             '' [DEGREE], 
             '' [ETHNICITY], 
             '' [LANGUAGESSPOKEN], 
             '' [PROVIDER_DATE_OF_BIRTH], 
             '' [PROVIDER_GENDER], 
             '' [ACE_NETWORK_CONTACT]             
      FROM dbo.vw_ActiveMembers Pcp
    	JOIN lst.List_Client Client ON pcp.ClientKey = Client.ClientKey 
    	LEFT JOIN dbo.vw_AllClient_ProviderRoster pr 
	   ON pr.TIN = pcp.PCP_PRACTICE_TIN AND pr.NPI = pcp.NPI
    	    AND pr.npi IS NULL
      WHERE ISNULL(pcp.PCP_PRACTICE_TIN, '0') <> '0' and ISNULL(pcp.NPI, '0') <> '0'
	 ;


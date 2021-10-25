

CREATE VIEW [dbo].[vw_RP_PracticesLOBContractActiveMembership_HQ]
AS
    
     SELECT DISTINCT 
            P.[TAX_ID], 
            P.[PRACTICE_NAME],
		  CASE WHEN P.UHC = 'X' THEN CONVERT(NVARCHAR(50), AM.UHC) ELSE 'NO' END AS UHC,
		  CASE WHEN P.UHC = 'X'THEN AM.UHC ELSE 0 END AS UHC1,
		  CASE WHEN P.WEllcare = 'X' THEN CONVERT(NVARCHAR(50), [WellCare MA]) ELSE 'NO' END AS WELLCARE,
            CASE WHEN P.WEllcare = 'X'THEN [WellCare MA] ELSE 0 END AS WELLCARE1,
            CASE WHEN P.[AETNA MEDICARE] = 'X' THEN CONVERT(NVARCHAR(50), AM.[AETNA MA]) ELSE 'NO' END AS [AETNA MEDICARE],
            CASE WHEN P.[AETNA MEDICARE] = 'X' THEN AM.[AETNA MA] ELSE 0 END AS AETNA1,
            CASE WHEN P.[AETNA COMM] = 'X' THEN CONVERT(NVARCHAR(50), AM.[AETNA COMM]) ELSE 'NO' END AS [AETNA COMM],
            CASE WHEN P.[AETNA COMM] = 'X' THEN AM.[AETNA COMM] ELSE 0 END AS [AETNA COMM1],
            CASE WHEN P.devoted = 'X' THEN CONVERT(NVARCHAR(50), AM.devoted) ELSE 'NO' END AS DEVOTED,
            CASE WHEN P.devoted = 'X' THEN AM.devoted ELSE 0 END AS DEVOTED1, 
            --     ,'' AS [MOLINA] 
            '' AS [IMPERIAL],             
            CASE WHEN p.[CIGNA MA] = 'X' THEN  CONVERT(NVARCHAR(50), AM.devoted) ELSE 'NO' END AS [CIGNA MA]
		  ,CASE WHEN P.[CIGNA MA] = 'X' THEN am.[CIGNA_MA]  ELSE '0' END AS [CIGNA MA1] 
     -- ,CASE WHEN P.[no contract] ='X' THEN CONVERT(NVARCHAR(50),P.[NO CONTRACT]) ELSE 'NO' END AS NO_CONTRACT	
	
     FROM (SELECT DISTINCT c.TAX_ID, c.Practice_name, c.UHC, c.[AETNA MEDICARE], 
                c.[AETNA COMM],--c.WELLCARE , /* why was this removed? */
                s.WELLCARE, c.DEVOTED, c.[CIGNA MA]		 
		  FROM [dbo].[vw_RP_ProviderReferenceTool_HQ] c
			 LEFT JOIN (SELECT DISTINCT tax_id, Practice_name, Wellcare
					   FROM [dbo].[vw_RP_ProviderReferenceTool_HQ]
					   WHERE WELLCARE = 'X') s 
			 ON s.TAX_ID = c.TAX_ID
			 ) P
	   LEFT JOIN(SELECT DISTINCT [TIN], [PRACTICE_NAME], [ACE_CONTACT], [POD], [UHC], [WellCare MA], 
				    [AETNA MA], [AETNA COMM], Devoted, --,[MOLINA] 
				    [CIGNA_MA]
				FROM [dbo].[vw_RP_LOBPracticeActiveMembership_HQ]) AS AM 
				ON CONVERT(INT, AM.TIN) = CONVERT(INT, P.TAX_ID)
	

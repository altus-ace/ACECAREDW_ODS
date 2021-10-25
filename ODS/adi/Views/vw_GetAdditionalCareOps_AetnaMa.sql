CREATE VIEW [adi].[vw_GetAdditionalCareOps_AetnaMa]
AS 
    -- OBJECTIVE to create AHS programs for awv and chronic visit to send to AHS

SELECT am.ClientKey, 
       ClientMemberKey,
	  ProgName.DESTINATION_PROGRAM_NAME AS Program, 
	  '10/01/2020' StartDate,
	  '12/31/2020' EndDate
FROM ( SELECT DISTINCT m.MEMBER_ID, 
           CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), m.MEMBER_ID)) AS ClientMemberKey
		  --distinct datadate
	   FROM [ACECAREDW].[adi].[copAetmaCareopps] c
		  JOIN adi.MbrAetMaTx m ON c.memberid = m.Member_Source_Member_ID	
	   WHERE c.loadDate = (SELECT MAX(loadDate) FROM [ACECAREDW].[adi].[copAetmaCareopps])
		  AND c.lastofficevisit = 'N') tmp
    JOIN dbo.vw_ActiveMembers am ON tmp.ClientMemberKey = am.CLIENT_SUBSCRIBER_ID
    JOIN (SELECT c.DESTINATION_PROGRAM_NAME,SOURCE_MEASURE_NAME
		  FROM lst.lstMapCareoppsPrograms c
		  WHERE c.SOURCE = 'AETNA') ProgName ON ProgName.SOURCE_MEASURE_NAME = 'LastOfficeVisit'
UNION
    --Last Office Visit-Chronic - N load into C- Chronic visit 2
    --If member is found in both load into AWV only
SELECT src.clientKey,    
	   src.ClientMemberKey, 
	   ProgName.DESTINATION_PROGRAM_NAME AS Program,
	   '10/01/2020' StartDate,
    	  '12/31/2020' EndDate
FROM (SELECT am.clientKey, 
        ClientMemberKey      
    FROM (SELECT DISTINCT m.MEMBER_ID, CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), m.MEMBER_ID)) AS ClientMemberKey    
    	   FROM [ACECAREDW].[adi].[copAetmaCareopps] c
    		  JOIN adi.MbrAetMaTx m ON c.memberid = m.Member_Source_Member_ID
    	   WHERE c.loadDate =(SELECT MAX(loadDate)FROM [ACECAREDW].[adi].[copAetmaCareopps])
              AND c.[Last OfficeVisit-Chronic] = 'N'
        ) tmp
        JOIN dbo.vw_ActiveMembers am ON tmp.ClientMemberKey = am.CLIENT_SUBSCRIBER_ID
    EXCEPT
        SELECT am.clientkey,ClientMemberKey
        FROM (SELECT distinct m.MEMBER_ID, CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), m.MEMBER_ID)) AS ClientMemberKey
    		  FROM [ACECAREDW].[adi].[copAetmaCareopps] c
    			 JOIN adi.MbrAetMaTx m on c.memberid = m.Member_Source_Member_ID
    			WHERE c.loadDate = (select max(loadDate)FROM [ACECAREDW].[adi].[copAetmaCareopps])
    and c.lastofficevisit = 'N') tmp
    JOIN dbo.vw_ActiveMembers am ON tmp.ClientMemberKey = am.CLIENT_SUBSCRIBER_ID    			 
    ) src
    JOIN (SELECT c.DESTINATION_PROGRAM_NAME, c.SOURCE_MEASURE_NAME 
		  FROM lst.lstMapCareoppsPrograms c
		  WHERE c.SOURCE = 'AETNA') ProgName ON ProgName.SOURCE_MEASURE_NAME = 'OfficeVisits-Chronic2ndHalf' 

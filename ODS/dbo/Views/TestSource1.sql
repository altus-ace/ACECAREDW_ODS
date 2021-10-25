CREATE view dbo.TestSource1 
as 

SELECT DISTINCT 
           S.TIN, 
           s.CLIENT, 
           PRACTICE_NAME, 
           AccountType, 
           NA.ACE_CONTACT, 
           na.PrimaryState, 
           na.POD, 
           S.MEMBER_ID
    FROM (SELECT DISTINCT 
                   a.TIN, 
                   a.GroupName AS PRACTICE_NAME, 
                   a.NetworkContact AS ACE_CONTACT, 
                   a.PrimaryState, 
                   a.PrimaryPOD AS pod, 
                   HealthPlan, 
                   AccountType
            FROM adw.fctproviderroster a
            WHERE CONVERT(DATE, GETDATE()) BETWEEN a.effectivedate AND a.expirationdate
                  AND a.LastUpdatedDate =
            (
                SELECT MAX(LastUpdatedDate)
                FROM adw.fctproviderroster
            )
                  AND (TIN <> '300491632'
                       OR PrimaryPOD = 3) -- to remove multiple occurances of this TIN         				
        
    ) AS na
    RIGHT JOIN(
        SELECT DISTINCT 
               a.Member_id, 
               client.clientshortname AS Client, 
               CONVERT(INT, a.pcp_practice_tin) AS TIN
        FROM acecaredw.dbo.vw_activeMembers a
             JOIN lst.list_client client ON a.ClientKey = client.clientkey
    ) s ON CONVERT(INT, na.tin) = CONVERT(INT, S.TIN)
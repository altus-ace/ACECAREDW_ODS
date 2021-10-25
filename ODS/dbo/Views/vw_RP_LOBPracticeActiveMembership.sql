
CREATE view [dbo].[vw_RP_LOBPracticeActiveMembership]
As
SELECT TIN,PRACTICE_NAME,ACE_CONTACT,POD,[UHC],[WLC] as [WellCare MA],[AET] as [AETNA MA]--,0 AS [MOLINA]
,0 AS [CIGNA] ,[AetCom] AS [AETNA COMM],0 AS [CIGNA COMM]
FROM (
SELECT DISTINCT  S.TIN ,S.CLIENT,PRACTICE_NAME,NA.ACE_CONTACT,na.POD,
	   S.MEMBER_ID
	  FROM
(

SELECT  DISTINCT CONVERT(INT,a.Tax_ID_number__c) AS TIN,
           a.Name AS PRACTICE_NAME,
           a.network_contact__c AS ACE_CONTACT,
           cc.Provider_NPI__c AS NPI,
           cc.firstName,
           cc.Lastname,
		 z.Quadrant__C as pod
    FROM tmpsalesforce_account a
         INNER JOIN tmpsalesforce_contact cc ON cc.accountId = a.id
	    inner join tmpsalesforce_account_locations__C ac on ac.account_name__c=a.id and ac.location_type__C='Primary'
	    inner join tmpsalesforce_zip_code__C z on z.id=ac.zip_code__c
    WHERE --a.Termination_with_cause__c = 'ACTIVE' and 
    cc.status__C = 'Active'
	--and a.Tax_ID_number__c = '10972233'



   
) AS na
 right JOIN
(
   SELECT DISTINCT a.client,a.Member_id,
           CONVERT(INT,a.pcp_practice_tin) AS TIN,
           a.NPI
    FROM acecaredw.dbo.vw_activeMembers a 
    inner join [dbo].[vw_Aetna_ProviderRoster] p on convert(int,p.[tax id])=CONVERT(INT,a.pcp_practice_tin) and p.lob='Medicare Advantage' and p.term_date__C is null
    WHERE a.CLIENT='AET'
	--and a.pcp_practice_tin = '200462905'
	UNION
	SELECT DISTINCT a.client,a.Member_id,
           CONVERT(INT,a.pcp_practice_tin) AS TIN,
           a.NPI
    FROM acecaredw.dbo.vw_activeMembers a 
    inner join [dbo].[vw_Aetna_ProviderRoster] p on convert(int,p.[tax id])=CONVERT(INT,a.pcp_practice_tin) and p.lob='Medicare Advantage' and p.term_date__C is null
    WHERE a.CLIENT='AetCom'
	--select * from acecaredw.dbo.vw_activeMembers where pcp_practice_tin = '201709356' 
	--		and CLIENT = 'AetCom'
    UNION
    SELECT DISTINCT A.client,A.Member_id,
           CONVERT(INT,A.pcp_practice_tin) AS TIN,
         a.NPI
    FROM acecaredw.dbo.vw_activeMembers A
   INNER JOIN ACECAREDW.ADW.MbrWlcProviderLookup L ON CONVERT(INT,L.TIN)=CONVERT(INT,A.pcp_practice_tin) 
    and convert(int,l.npi)=convert(int,a.npi)
     WHERE CLIENT='WLC'
    UNION
    SELECT DISTINCT 'UHC' AS Client,Member_id,
          case when  pcp_practice_tin='752894111' then '300491632' else CONVERT(INT,pcp_practice_tin) end AS TIN,
           PCP_NPI AS NPI
    FROM acecaredw.dbo.vw_UHC_ActiveMembers
	--where pcp_practice_tin = '200462905'
) s ON CONVERT(INT, na.tin) = CONVERT(INT, S.TIN)
       -- AND CONVERT(INT, na.NPI) = CONVERT(INT, s.NPI)


	   ) AS P
	   pivot 
(
count(MEMBER_ID) for CLIENT in ([UHC],[WLC],[AET],[AetCom])) pvt
--ORDER  BY PRACTICE_NAME












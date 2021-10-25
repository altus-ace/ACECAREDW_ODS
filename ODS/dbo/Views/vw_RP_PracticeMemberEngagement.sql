CREATE VIEW [dbo].[vw_RP_PracticeMemberEngagement]
AS
     SELECT s.LOB,
            A.NAME AS PRACTICE_NAME,
            s.PCP_PRACTICE_TIN AS TAXID,
            S.MemberMonth AS MEM_MONTH,
		  s.MemberYear as MEM_YEAR,
		  s.MONTH_Year,
            COUNT(DISTINCT s.TotalMember) AS TOTALMEMBERS
     FROM Tmpsalesforce_Account a
          LEFT JOIN
(
    SELECT 'UHC-M' AS LOB,
           MONTH(P.a_last_update_date) as MemberMonth
		 ,YEAR(P.A_LAST_UPDATE_DATE) AS MemberYear,
		 CONCAT(MONTH(P.a_last_update_date),'-',YEAR(P.A_LAST_UPDATE_DATE)) AS MONTH_YEAR,
           P.Uhc_subscriber_id AS TotalMember,
           CASE
               WHEN pcp_practice_tin = '752894111'
               THEN '300491632'
               ELSE P.PCP_PRACTICE_TIN
           END AS PCP_PRACTICE_TIN
    FROM uhc_membersbypcp P
    WHERE YEAR(P.A_LAST_UPDATE_DATE) >= '2018'
          AND p.LoadType = 'P'
          AND p.SUBGRP_ID NOT IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
) AS s ON s.PCP_PRACTICE_TIN = a.Tax_ID_Number__c
     WHERE s.PCP_PRACTICE_TIN IS NOT NULL
     GROUP BY s.PCP_PRACTICE_TIN,
              S.MemberMonth,
		  s.MemberYear ,
              s.PCP_PRACTICE_TIN,
              s.LOB,
              a.name,
		    s.MONTH_Year
     UNION

     SELECT 'WELLCARE_MA' AS LOB,
            PL.PracticeName PRACTICE_NAME,
            PL.TIN TAXID,
            MONTH(P.LOADDATE) as MEM_MONTH, YEAR(P.LOADDATE) AS MEM_YEAR,
		  CONCAT( MONTH(P.LOADDATE) ,'-', YEAR(P.LOADDATE)) as MONTH_YEAR,
            COUNT(DISTINCT P.SUB_ID) AS TOTALMEMBERS
     FROM ADI.MbrWlcMbrByPcp P
          INNER JOIN [adw].[MbrWlcProviderLookup] PL ON PL.PROV_ID = P.PROV_ID
     WHERE YEAR(P.LOADDATE) >= '2018'
     GROUP BY MONTH(P.LOADDATE), YEAR(P.LOADDATE),
              MONTH(P.LOADDATE),
              PL.TIN,
              PL.PracticeName


     UNION
     SELECT 'AETNA_MA' AS LOB,
            PL.[GROUP NAME] PRACTICE_NAME,
            PL.[tax id] TAXID,
            MONTH(P.LOADDATE) as MEM_MONTH, YEAR(P.LOADDATE) AS MEM_YEAR,
		  CONCAT( MONTH(P.LOADDATE) ,'-', YEAR(P.LOADDATE)) as MONTH_YEAR,
            COUNT(DISTINCT P.AetSubscriberID) AS TOTALMEMBERS
     FROM ADI.MbrAetMbrByPcp P
          INNER JOIN [dbo].[vw_Aetna_ProviderRoster] PL ON CONVERT(INT, PL.[tax id]) = CONVERT(INT, P.TIN)
     WHERE YEAR(P.LOADDATE) >= '2018'
     GROUP BY MONTH(P.LOADDATE), YEAR(P.LOADDATE),
              MONTH(P.LOADDATE),
              PL.[GROUP NAME],
              PL.[tax id];

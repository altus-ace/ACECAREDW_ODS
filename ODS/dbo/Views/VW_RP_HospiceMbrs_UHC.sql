CREATE VIEW [dbo].[VW_RP_HospiceMbrs_UHC]
AS
     SELECT DISTINCT
            CONVERT(DATE, GETDATE(), 101) AS RUN_DATE,
            LTRIM(RTRIM(mbr.[UHC_SUBSCRIBER_ID])) AS MEMBER_ID,
            mbr.[MEDICAID_ID] AS MCAID,
            MCO = 'UHG',
            mbr.[MEMBER_LAST_NAME],
            mbr.[MEMBER_FIRST_NAME],
            g.GENDER,
            mbr.[DATE_OF_BIRTH] AS DOB,
            DATEDIFF(year, mbr.[DATE_OF_BIRTH], GETDATE()) AS AGE,
            CASE
                WHEN DATEDIFF(year, mbr.[DATE_OF_BIRTH], GETDATE()) BETWEEN 65 AND 70
                THEN '65-70'
                WHEN DATEDIFF(year, mbr.[DATE_OF_BIRTH], GETDATE()) BETWEEN 71 AND 75
                THEN '71-75'
                WHEN DATEDIFF(year, mbr.[DATE_OF_BIRTH], GETDATE()) BETWEEN 76 AND 80
                THEN '76-80'
                WHEN DATEDIFF(year, mbr.[DATE_OF_BIRTH], GETDATE()) BETWEEN 81 AND 85
                THEN '81-85'
                WHEN DATEDIFF(year, mbr.[DATE_OF_BIRTH], GETDATE()) BETWEEN 86 AND 90
                THEN '86-90'
                WHEN DATEDIFF(year, mbr.[DATE_OF_BIRTH], GETDATE()) > 90
                THEN 'ABOVE 90'
            END AS AGE_BUCKET,
            CAST(mbr.IPRO_ADMIT_RISK_SCORE AS DECIMAL) AS RISK,
            mbr.[PCP_PRACTICE_TIN] AS TIN,
            g.PCP_NPI AS NPI,
            mbr.[PCP_NAME] AS PCP_NAME,
            mbr.[PCP_ADDRESS],
            mbr.[PCP_CITY],
            mbr.[PCP_STATE],
            mbr.[PCP_ZIP_C],
            mbr.[PCP_PRACTICE_NAME],
            mbr.[PRIMARY_RISK_FACTOR],
            mbr.[TOTAL_COSTS_LAST_12_MOS],
            mbr.[INP_COSTS_LAST_12_MOS],
            mbr.[ER_COSTS_LAST_12_MOS],
            mbr.[OUTP_COSTS_LAST_12_MOS],
            mbr.[PHARMACY_COSTS_LAST_12_MOS],
            mbr.[PRIMARY_CARE_COSTS_LAST_12_MOS],
            mbr.[BEHAVIORAL_COSTS_LAST_12_MOS],
            mbr.[OTHER_OFFICE_COSTS_LAST_12_MOS],
            mbr.[INP_ADMITS_LAST_12_MOS],
            mbr.[LAST_INP_DISCHARGE],
            mbr.[ER_VISITS_LAST_12_MOS],
            mbr.[LAST_ER_VISIT],
            mbr.[LAST_PCP_VISIT],
            UPPER(CAST(STUFF(
(/*added ' ' because first character for diag code and description not populating**/
    SELECT ' '+dx2.diagcode+' | '
    FROM
(
    SELECT DISTINCT
           a.SUBSCRIBER_ID,
           a.DIAGCODE,
           ds1.[ICD-10-CM_CODE_DESCRIPTION]
    FROM ACECAREDW_TEST.dbo.CLAIMS_DIAGs a
         INNER JOIN
(
    SELECT [ICD-10-CM_CODE],
           [ICD-10-CM_CODE_DESCRIPTION]
    FROM [ACECAREDW_TEST].[dbo].[ICDCCS]
) ds1 ON ds1.[ICD-10-CM_CODE] = replace(a.diagCode, '.', '')
    WHERE a.DIAGCODE IN('J44.9', 'C34.90', 'I50.9', 'I67.9', 'N18.6', 'C61', 'C18.9', 'C50.919', 'C93.10', 'C22.8')
) dx2
    WHERE dx.SUBSCRIBER_ID = dx2.SUBSCRIBER_ID FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS DIAGCODE,
            UPPER(CAST(STUFF(
(
    SELECT ' '+dx3.[ICD-10-CM_CODE_DESCRIPTION]+' | '
    FROM
(
    SELECT DISTINCT
           a.SUBSCRIBER_ID,
           a.DIAGCODE,
           ds2.[ICD-10-CM_CODE_DESCRIPTION]
    FROM ACECAREDW_TEST.dbo.CLAIMS_DIAGs a
         INNER JOIN
(
    SELECT [ICD-10-CM_CODE],
           [ICD-10-CM_CODE_DESCRIPTION]
    FROM [ACECAREDW_TEST].[dbo].[ICDCCS]
) ds2 ON ds2.[ICD-10-CM_CODE] = replace(a.diagCode, '.', '')
    WHERE a.DIAGCODE IN('J44.9', 'C34.90', 'I50.9', 'I67.9', 'N18.6', 'C61', 'C18.9', 'C50.919', 'C93.10', 'C22.8')
) dx3
    WHERE dx.SUBSCRIBER_ID = dx3.SUBSCRIBER_ID FOR XML PATH('')
), 1, 1, '') AS VARCHAR(100))) AS [ICD-10-CM_CODE_DESCRIPTION],
      -- dx.diagCode, 
    --   ds.[ICD-10-CM_CODE_DESCRIPTION], 
            CONVERT(DATE, x.[PERFORMED_DATE], 101) AS ICT_TOUCH_DATE
     FROM [ACECAREDW].[dbo].vw_UHC_ActiveMembers mbr
          LEFT JOIN
(
    SELECT DISTINCT
           a.SUBSCRIBER_ID,
           a.DIAGCODE,
           ds.[ICD-10-CM_CODE_DESCRIPTION]
    FROM ACECAREDW_TEST.dbo.CLAIMS_DIAGs a
         INNER JOIN
(
    SELECT [ICD-10-CM_CODE],
           [ICD-10-CM_CODE_DESCRIPTION]
    FROM [ACECAREDW_TEST].[dbo].[ICDCCS]
) ds ON ds.[ICD-10-CM_CODE] = replace(a.diagCode, '.', '')
    WHERE a.DIAGCODE IN('J44.9', 'C34.90', 'I50.9', 'I67.9', 'N18.6', 'C61', 'C18.9', 'C50.919', 'C93.10', 'C22.8')
) dx ON mbr.UHC_SUBSCRIBER_ID = dx.SUBSCRIBER_ID
          LEFT JOIN
(
    SELECT *
    FROM
(
    SELECT DISTINCT
           b.[PATIENT_ID],
           a.client_patient_id,
           b.[PERFORMED_DATE],
           ROW_NUMBER() OVER(PARTITION BY a.client_patient_ID ORDER BY b.performed_Date DESC) AS Latest_Performed_date
    FROM [Ahs_Altus_Prod].[dbo].[PATIENT_FOLLOWUP] b
         LEFT JOIN
(
    SELECT client_patient_id,
           patient_id
    FROM ahs_altus_prod.dbo.patient_details
) a ON a.patient_ID = b.[PATIENT_ID]
) c
    WHERE c.Latest_Performed_date = 1
) x ON mbr.UHC_SUBSCRIBER_ID = x.CLIENT_PATIENT_ID
          LEFT JOIN
(
    SELECT gender,
           UHC_SUBSCRIBER_ID,
           PCP_NPI
    FROM acecaredw.dbo.vw_uhc_activemembers
) g ON mbr.UHC_SUBSCRIBER_ID = g.UHC_SUBSCRIBER_ID
     WHERE dx.diagCode IS NOT NULL
           AND DATEDIFF(year, CONVERT(DATE, mbr.Date_Of_Birth, 101), GETDATE()) >= '65' --and mbr.uhc_subscriber_id='101614567'
		 
		 /**Per #1226 excluding members with subgrps for starkids and starplus( 120,123,901)**/
		 and mbr.uhc_subscriber_id not in (
		 select uhc_subscriber_id from acecaredw.dbo.UHC_MembersByPCP
where SUBGRP_ID in ( '0600','0601','0602','0603','0604','0605','0606''600',
'601',
'602',
'603',
'604',
'605',
'606','120','123','901','0120','0123','0901','1003'))



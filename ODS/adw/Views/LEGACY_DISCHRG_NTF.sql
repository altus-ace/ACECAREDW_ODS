/*****************************************************************
CREATED BY : TS
CREATE DATE : 01/16/2020
DESCRIPTION : 

The objective of the view is to generate  Discharge Notification daily 
from all Clients: AETNA MA/COMM, WLC TX, GHH and UHC 
for Legacy and transmit it as CSV file in the 
Legacy Outbound folder.

The PROGRAM id is 7


MODIFICATION:
USER        DATE        COMMENT

 
******************************************************************/
CREATE VIEW [ADW].[LEGACY_DISCHRG_NTF]
AS

WITH CTE AS (SELECT DISTINCT 'uhc_ip' AS SRC, 
       PatientIdentifier AS [Visible Patient ID], 
       HospitalName AS [LOCATION], 
   	   DischargeDate as [EVENT DATE],
	   --'' as [Provide ID],
	   DispositionDesc AS [EVENT TYPE],
	   ROW_NUMBER()OVER(PARTITION BY PatientIdentifier  ORDER BY DischargeDate DESC )AS RN
FROM ADI.NtfUhcIpCensus
WHERE DischargeDate IS NOT NULL
AND DischargeDate <> ''
AND PatientIdentifier IS NOT NULL
AND PatientIdentifier <>''
AND HospitalName IS NOT NULL
AND HospitalName <> ''
AND DispositionDesc IS NOT NULL
AND DispositionDesc <> ''
 -- UHC IP NOTIFICATIONS
 UNION
SELECT DISTINCT 'AETMA' AS SRC, 
       RIGHT(DwMemberID, 18) AS [Visible Patient ID],
       [FacilityName/Role] AS [LOCATION], 
       ActualDischargeDate AS [EVENT DATE], 
	  -- '' as [Provide ID],
       DischargeDisposition AS [EVENT TYPE],
	   ROW_NUMBER()OVER(PARTITION BY RIGHT(DwMemberID, 18)  ORDER BY ActualDischargeDate DESC )AS RN
FROM ADI.NtfAetMaTxDlyCensus 
WHERE DwMemberID IS NOT NULL
AND   DwMemberID <> '' 
AND [FacilityName/Role] IS NOT NULL
AND [FacilityName/Role] <> ''
AND DischargeDisposition IS NOT NULL
AND DischargeDisposition <> ''   -- AETMA IP NOTIFICATIONS
AND ActualDischargeDate IS NOT NULL
AND ActualDischargeDate <> ''
UNION
SELECT 'GHH' AS SRC, 
        B.MEMBER_ID AS [Visible Patient ID], 
       AdmitHospital AS [LOCATION],  
       CONVERT(DATE,DischargeDateTime,112) AS [EVENT DATE], --ghh
	 -- '' as [Provide ID],
       EventType  AS [EVENT TYPE],
	   ROW_NUMBER()OVER(PARTITION BY B.MEMBER_ID   ORDER BY CONVERT(DATE,DischargeDateTime,112) DESC )AS RN
FROM ADI.NtfGhhNotifications A
JOIN DBO.VW_ACTIVEMEMBERS B ON B.Ace_ID = A.AceID
WHERE DischargeDateTime IS NOT NULL
AND DischargeDateTime <> ''
AND  B.MEMBER_ID IS NOT NULL
AND  B.MEMBER_ID <> ''
AND DischargeDateTime IS NOT NULL
AND DischargeDateTime <> ''
AND AdmitHospital IS NOT NULL
AND AdmitHospital <> ''
--WHERE B.PCP_PRACTICE_TIN = '760009637'
 -- GHH NOTIFICATIONS ALL CLIENTS) A
 UNION
SELECT DISTINCT 'AETCOM' AS SRC, 
SUBSTRING([DW Member ID], PATINDEX('%[^0]%', [DW Member ID]+'.'), LEN([DW Member ID])) AS [Visible Patient ID], 
       [Facility Name/Role] AS [LOCATION],  
       [Actual Discharge Date] AS [EVENT DATE], 
	   --[NPI Number] as [Provide ID],
       [Discharge Disposition ] AS [EVENT TYPE],
	   ROW_NUMBER()OVER(PARTITION BY SUBSTRING([DW Member ID], PATINDEX('%[^0]%', [DW Member ID]+'.'), LEN([DW Member ID]))  ORDER BY [Actual Discharge Date] DESC )AS RN
FROM ADI.NtfAetComDlyCensus
WHERE [Actual Discharge Date] IS NOT NULL
AND  [DW Member ID] IS NOT NULL
AND   [DW Member ID] <> '' 
AND [Facility Name/Role] IS NOT NULL
AND [Facility Name/Role] <> ''
AND [Discharge Disposition ] IS NOT NULL
AND [Discharge Disposition ] <> ''
AND [Actual Discharge Date] IS NOT NULL
AND [Actual Discharge Date] <> ''  -- AETNA COMM IP NOTIFICATIONS
 UNION
SELECT DISTINCT 'WLCMA' AS SRC, 
       SUBSCRIBER_ID AS [Visible Patient ID], 
       FACILITY AS [LOCATION],  
       DIS_DATE AS [EVENT DATE], 
	 -- '' as [Provide ID],
       'UNKNOWN'  AS [EVENT TYPE],
	   ROW_NUMBER()OVER(PARTITION BY SUBSCRIBER_ID  ORDER BY DIS_DATE DESC )AS RN
FROM ADI.NtfWlcTxCensus
WHERE DIS_DATE IS NOT NULL  -- WELLCARE IP NOTIFICATIONS
AND SUBSCRIBER_ID IS NOT NULL
AND SUBSCRIBER_ID <> ''
AND FACILITY IS NOT NULL
AND FACILITY <>''
AND DIS_DATE <> ''

) 
select
5 [Version Number] ,
RTRIM(LTRIM('Ace Feed'))[File Type],
RTRIM(LTRIM(t.MEMBER_ID)) [Visible Patient ID],
RTRIM(LTRIM(t.Ace_ID)) [Unique Patient ID],
RTRIM(LTRIM('7')) as [Program ID],
RTRIM(LTRIM(t.MEMBER_LAST_NAME)) [Last Name],
RTRIM(LTRIM(t.MEMBER_FIRST_NAME)) [First Name],
RTRIM(LTRIM(t.MEMBER_MI))   [Middle Name],
RTRIM(LTRIM('')) [Prefix],
RTRIM(LTRIM('')) [Suffix],
RTRIM(LTRIM(t.MEMBER_HOME_ADDRESS)) [Address Line1],
RTRIM(LTRIM(t.MEMBER_HOME_ADDRESS2)) [Address Line2],
RTRIM(LTRIM(t.MEMBER_HOME_CITY)) [City Name],
RTRIM(LTRIM(t.MEMBER_HOME_STATE)) [State],
RTRIM(LTRIM(t.MEMBER_HOME_ZIP_C)) [Postal Code],
RTRIM(LTRIM(CONVERT(VARCHAR(8),t.DATE_OF_BIRTH, 112))) [Date Of Birth],
RTRIM(LTRIM(t.GENDER)) [GENDER],
RTRIM(LTRIM('')) [Preffered Contact method] ,
RTRIM(LTRIM(t.MEMBER_HOME_PHONE ))[Home Phone],
RTRIM(LTRIM(t.MEMBER_HOME_PHONE)) [Mobile Phone],
RTRIM(LTRIM(t.MEMBER_BUS_PHONE)) [Work Phone],
RTRIM(LTRIM('')) [email],
RTRIM(LTRIM(t.RISK_CATEGORY_C)) [Risk Score],
RTRIM(LTRIM(t.NPI)) [Provider ID],
RTRIM(LTRIM(t.PCP_FIRST_NAME)) [Provider First Name],
RTRIM(LTRIM(t.PCP_LAST_NAME)) [Provider Last Name],
RTRIM(LTRIM('')) [Care Coordinator ID],
RTRIM(LTRIM('Active')) [PATIENT STATUS],
 RTRIM(LTRIM(t.[LOCATION])) as [LOCATION],
  RTRIM(LTRIM('Ace_DataSource')) as [Data Source],
RTRIM(LTRIM(t.LANG_CODE)) [PREFFERED LANGUAGE],
RTRIM(LTRIM(CONVERT(VARCHAR(8), t.[EVENT DATE], 112))) AS [EVENT DATE],
 RTRIM(LTRIM( t.[EVENT TYPE] ))[EVENT TYPE]
 from(  
SELECT 
A.*,B.*
 FROM CTE AS A
JOIN DBO.VW_ACTIVEMEMBERS B ON B.MEMBER_ID = A.[Visible Patient ID]
WHERE B.PCP_PRACTICE_TIN = '760009637'  AND A.RN=1
--and A.[EVENT DATE]= CONVERT(VARCHAR(8),(GETDATE() -2), 112)  /* the date criteria*/
)t
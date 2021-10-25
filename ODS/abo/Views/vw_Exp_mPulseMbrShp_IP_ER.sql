



CREATE  VIEW [abo].[vw_Exp_mPulseMbrShp_IP_ER] 
AS 

SELECT	
    'UHC' AS Client,
	[PatientCardID]	AS MemberID,
	[PatientFirstName]	AS MemberFirstName,
	[PatientLastName] AS MemberLastName,
  [PatientBirthDate]	AS DOB ,
  [ContactPhoneNumber] AS  phonenumber,
  'Emergency Room'  AS Discharge_Flag,
   [PrimaryLanguage]   AS Language

  FROM [adi].[tempmPulse_ER_Texting] 
  WHERE ([Text] = 'Text')
  UNION ALL
  SELECT 
  ENTITY             AS Cleint,
  MEMEBR_ID          AS MemberID,
  [MEMER_FIRST_NAME] AS MemberFirstName,
  [MEMBER_LAST_NAME] AS MemberLastName,
  [MEMBER_DOB]       AS DOB ,
  [PhoneNumber]     AS  phonenumber,
	'Hospital'		 AS Discharge_Flag,
	'English'		 AS Language

  FROM [adi].[tempmPulse_IP_Texting] 
  WHERE ([Text] ='Text')



 -- SELECT v1
---  FROM t1
--UNION ALL
--SELECT v2
 -- FROM t2;


CREATE PROCEDURE [adw].[NtfExportTable]
AS
BEGIN
INSERT		INTO			dbo.ntfExportTable([ENTITY], [SITE], [UID_STATE], [UID_PROVIDER], [PracticeName], [Treatment_Type], [Member_ID], [Case_ID], [CaseType], [ADMIT_NOTIFICATION_DATE], [ADIMSSION_DATE], [DISCHARGE_DATE], [DISCHARGE_DISPOSITION], [FOLLOW_UP_VISIT_DUE_DATE], [SCHEDULED_VISIT_DATE], [PRIMARY_DIAGNOSIS], [AdmitHospital], [Client_ID], [Exported], [ExportedDate], [Benefit_Plan], [PHoneNumber], [Carrier_Type], [Member_First_Name], [MEMBER_LAST_NAME], [MEMBER_DOB], [DataSource], [ntfEventType], [AdiLineneageKey])

SELECT 
    CONVERT(varchar(50),ENTITY) ENTITY
    ,CONVERT(varchar(50),SITE						 )SITE			 
    ,CONVERT(varchar(50),UID_STATE					 )UID_STATE
    ,CONVERT(varchar(50), UID_PROVIDER				 ) UID_PROVIDER
    ,CONVERT(varchar(50),PracticeName				 )PracticeName
    ,CONVERT(varchar(50),Treatment_Type				 )Treatment_Type
    ,CONVERT(varchar(50),Member_ID					 )Member_ID
    ,CONVERT(varchar(50), Case_ID					 ) Case_ID
    ,CONVERT(varchar(50),CaseType 					 )CaseType 
    ,CONVERT(varchar(50),ADMIT_NOTIFICATION_DATE		 )ADMIT_NOTIFICATION_DATE
    ,CONVERT(varchar(50),ADIMSSION_DATE				 )ADIMSSION_DATE
    ,CONVERT(varchar(50),DISCHARGE_DATE				 )DISCHARGE_DATE
    ,CONVERT(varchar(50),DISCHARGE_DISPOSITION		 )DISCHARGE_DISPOSITION
    ,CONVERT(varchar(50),FOLLOW_UP_VISIT_DUE_DATE		 )FOLLOW_UP_VISIT_DUE_DATE
    ,CONVERT(varchar(50),SCHEDULED_VISIT_DATE		 )SCHEDULED_VISIT_DATE
    ,CONVERT(varchar(50),PRIMARY_DIAGNOSIS			 )PRIMARY_DIAGNOSIS
    ,CONVERT(varchar(50),AdmitHospital)				 AdmitHospital
    ,CONVERT(varchar(50),Client_ID		 )	   Client_ID
    ,CONVERT(varchar(50),Exported 					 )Exported 
    ,CONVERT(varchar(50),ExportedDate				 )ExportedDate
    ,CONVERT(varchar(50),Benefit_Plan 				 )Benefit_Plan 
    ,CONVERT(varchar(50),PHoneNumber 				 )PHoneNumber 
    ,CONVERT(varchar(50),Carrier_Type 				 )Carrier_Type 
    ,CONVERT(varchar(50),Member_First_Name			 )Member_First_Name
    ,CONVERT(varchar(50),MEMBER_LAST_NAME 			 )MEMBER_LAST_NAME 
    ,CONVERT(varchar(50),MEMBER_DOB				 )MEMBER_DOB
    ,CONVERT(varchar(50),DataSource				 )DataSource
    ,CONVERT(varchar(50),ntfEventType				 )ntfEventType	
    ,AdiLineneageKey
		--,aRowNumber		
FROM (
SELECT	client.CS_Export_LobName AS ENTITY
    		,'' AS SITE 
    		,'TX' AS UID_STATE
		,CONVERT(varchar(100), am.PCP_NAME) AS UID_PROVIDER--    '' AS UID_Provider
		,am.PCP_PRACTICE_NAME AS PracticeName
		,NtfPatientType AS Treatment_Type
		,ntf.ClientMemberKey AS Member_ID
		--CASE_ID --Create a sequence dts creates a unique identifier for each case. this required by altruista to use as an identifier
		--,NEXT VALUE FOR [dbo].[Case_ID_Sequence]
		,CONVERT(VARCHAR(10),(SELECT '30000' + ntfNotificationKey)) AS Case_ID
		,CaseType AS CaseType 
		,ntf.LoadDate AS ADMIT_NOTIFICATION_DATE
		,ntf.AdmitDateTime AS ADIMSSION_DATE
		,ntf.ActualDischargeDate AS DISCHARGE_DATE 
    		,ntf.DischargeDisposition AS DISCHARGE_DISPOSITION
		,ntf.AceFollowUpDueDate AS FOLLOW_UP_VISIT_DUE_DATE
		,'' AS SCHEDULED_VISIT_DATE
		, DiagnosisDesc  AS PRIMARY_DIAGNOSIS
		,AdmitHospital
		,am.ClientKey AS Client_ID
		,Exported --Default 1 as Exported?
		,Getdate() AS ExportedDate
		, am.AhsPlanName AS Benefit_Plan --, am.PLAN_CODE AS Benefit_Plan -- this is plan, we need CsPlan		
    		/* Replaced with the scrubbed phone numbers as business will use this to text, so they must know 
			 the carrier type 
		  ,CASE WHEN (NOT am.MEMBER_HOME_PHONE is null) THEN  am.MEMBER_HOME_PHONE 
				  WHEN (NOT am.MEMBER_MAIL_PHONE is null) THEN am.MEMBER_MAIL_PHONE
				  WHEN (NOT am.MEMBER_BUS_PHONE is null) THEN am.MEMBER_BUS_PHONE
				  ELSE '' END AS PhoneNumber
				  */
		, phnnum.PHoneNumber
    		,CONVERT(VARCHAR(50), RTRIM(Ltrim(PhnNum.carrier_type))) AS Carrier_Type		
    		,am.MEMBER_FIRST_NAME AS Member_First_Name
    		,am.MEMBER_LAST_NAME AS MEMBER_LAST_NAME 
    		,am.DATE_OF_BIRTH AS MEMBER_DOB
		,CASE WHEN NtfSource = 'GHH' THEN 'zGhh' ELSE NtfSource end AS DataSource
		,ntfEventType	
		,AdiKey AS AdiLineneageKey
		, ROW_NUMBER() OVER (PARTITION BY ntf.ClientMemberKey, ntf.NtfPatientType, ntf.DiagnosisCode, CONVERT(date, ntf.AdmitDateTime) , CONVERT(date, ntf.ActualDischargeDate) 
					   --ORDER BY CONVERT(date, ntf.AdmitDateTime) , CONVERT(date, ntf.ActualDischargeDate), ntf.NtfSource) aRow
					   ORDER BY ntf.DataDate, CASE WHEN NtfSource = 'GHH' THEN 'zGhh' ELSE NtfSource end  ) aRowNumber		
FROM		adw.NtfNotification ntf
    JOIN		dbo.vw_ActiveMembers am	   
	   ON			ntf.ClientMemberKey = am.MEMBER_ID
    JOIN		lst.List_Client Client     
	   ON			ntf.ClientKey = Client.ClientKey 
     LEFT JOIN (SELECT ps.ClientMemberKey, ps.phoneNumber, ps.carrier_type
			 FROM (SELECT ps.ClientMemberKey, ps.phoneNumber, [adi].[udf_GetCleanString](ps.carrier_type) AS carrier_type, ps.LoadDate
					   , ROW_NUMBER() OVER (PARTITION BY ps.ClientMemberKey ORDER BY ps.LoadDate DESC) AS arn
				    FROM acecaredw.adi.MpulsePhoneScrubbed ps				    				    
				) AS ps 
				WHERE ps.arn = 1
			 ) phnNum ON AM.MEMBER_ID = phnNum.ClientMemberKey
WHERE	ntf.AceFollowUpDueDate >= getdate()
    AND	NTF.Exported = 0
    
    ) src
WHERE src.aRowNumber = 1
AND Treatment_Type = 'IP' 


END


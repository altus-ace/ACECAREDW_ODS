
CREATE VIEW [dbo].[vw_AH_IPNotification]
AS 
    /* version history: 
	   2/11/2021: gk changed where clause to export SHCN_MSSP census file Dishcharges, they are inferred  (dschrgInferredDate <> 1900/01/01)

	   */
SELECT 
    CONVERT(varchar(50),src.ENTITY) ENTITY, ntfNOtificationKey
    ,CONVERT(varchar(50),src.SITE						 )SITE			 
    ,CONVERT(varchar(50),src.UID_STATE					 )UID_STATE
    ,CONVERT(varchar(50),src.UID_PROVIDER				 ) UID_PROVIDER
    ,CONVERT(varchar(50),src.PracticeName				 )PracticeName
    ,CONVERT(varchar(50),src.Treatment_Type				 )Treatment_Type
    ,CONVERT(varchar(50),src.Member_ID					 )Member_ID
    ,CONVERT(varchar(50),src.Case_ID					 ) Case_ID
    ,CONVERT(varchar(50),src.CaseType 					 )CaseType 
    ,CONVERT(varchar(50),src.ADMIT_NOTIFICATION_DATE		 )ADMIT_NOTIFICATION_DATE
    ,CONVERT(varchar(50),src.ADIMSSION_DATE, 120			 )ADIMSSION_DATE
    ,CONVERT(varchar(50),src.DISCHARGE_DATE, 120			 )DISCHARGE_DATE
    ,CONVERT(varchar(50),src.DISCHARGE_DISPOSITION		 )DISCHARGE_DISPOSITION
    ,CONVERT(varchar(50),src.FOLLOW_UP_VISIT_DUE_DATE		 )FOLLOW_UP_VISIT_DUE_DATE
    ,CONVERT(varchar(50),src.SCHEDULED_VISIT_DATE		 )SCHEDULED_VISIT_DATE
    ,CONVERT(varchar(50),src.PRIMARY_DIAGNOSIS			 )PRIMARY_DIAGNOSIS
    ,CONVERT(varchar(50),src.AdmitHospital)				 AdmitHospital
    ,CONVERT(varchar(50),src.Client_ID					 ) Client_ID
    ,CONVERT(varchar(50),src.Exported 					 )Exported 
    ,CONVERT(varchar(50),src.ExportedDate				 )ExportedDate
    ,CONVERT(varchar(50),src.Benefit_Plan 				 )Benefit_Plan 
    ,CONVERT(varchar(50),src.PHoneNumber 				 )PHoneNumber 
    ,CONVERT(varchar(50),src.Carrier_Type 				 )Carrier_Type 
    ,CONVERT(varchar(50),src.Member_First_Name			 )Member_First_Name
    ,CONVERT(varchar(50),src.MEMBER_LAST_NAME 			 )MEMBER_LAST_NAME 
    ,CONVERT(varchar(50),src.MEMBER_DOB				 )MEMBER_DOB
    ,CONVERT(varchar(50),src.DataSource				 )DataSource
    ,CONVERT(varchar(50),src.ntfEventType				 )ntfEventType	
    ,src.AdiLineneageKey			
FROM (SELECT	client.CS_Export_LobName AS ENTITY, ntf.ntfNOtificationKey
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
		,ntf.loaddate AS ADMIT_NOTIFICATION_DATE  -- change from loaddate to Exported Date. RA 05/11/2020
		,ntf.AdmitDateTime AS ADIMSSION_DATE
		,CASE WHEN (ntf.ActualDischargeDate is null) THEN ntf.DschrgInferredDate
			 ELSE ntf.ActualDischargeDate END AS DISCHARGE_DATE 
    		,ntf.DischargeDisposition AS DISCHARGE_DISPOSITION
		,ntf.AceFollowUpDueDate AS FOLLOW_UP_VISIT_DUE_DATE
		,'01/01/1900' AS SCHEDULED_VISIT_DATE
		, DiagnosisDesc  AS PRIMARY_DIAGNOSIS
		,AdmitHospital
		,Client.CS_Export_LobName AS Client_ID
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
		, CASE WHEN  (ISNULL(phnnum.PHoneNumber, '') <> '') THEN phnNum.phoneNumber
			  WHEN (ISNULL(AM.HomePhone	    , '') <> '') THEN AM.HomePhone
			  WHEN (ISNULL(AM.OtherPhone	    , '') <> '') THEN AM.OtherPHone
			 ELSE '' END AS PhoneNumber
    		,CONVERT(VARCHAR(50), RTRIM(Ltrim(PhnNum.carrier_type))) AS Carrier_Type		
    		,am.MEMBER_FIRST_NAME AS Member_First_Name
    		,am.MEMBER_LAST_NAME  AS MEMBER_LAST_NAME 
    		,am.DATE_OF_BIRTH	  AS MEMBER_DOB
		,CASE WHEN NtfSource = 'GHH' THEN 'zGhh' ELSE NtfSource end AS DataSource
		,ntfEventType	
		,AdiKey AS AdiLineneageKey
		, ROW_NUMBER() OVER (PARTITION BY ntf.ClientMemberKey, ntf.NtfPatientType, ntf.CaseType, CONVERT(date, ntf.AdmitDateTime) , CONVERT(date, ntf.ActualDischargeDate) 
					   --ORDER BY CONVERT(date, ntf.AdmitDateTime) , CONVERT(date, ntf.ActualDischargeDate), ntf.NtfSource) aRow
					   ORDER BY ntf.DataDate, CASE WHEN NtfSource = 'GHH' THEN 'zGhh' ELSE NtfSource end  ) aRowNumber		
FROM		adw.NtfNotification ntf   
    JOIN	(SELECT distinct
			   AC_AM.MEMBER_ID
			 , AC_AM.PCP_NAME
			 , AC_AM.PCP_PRACTICE_NAME
			 , AC_AM.MEMBER_FIRST_NAME
			 , AC_AM.MEMBER_LAST_NAME 
			 , AC_AM.DATE_OF_BIRTH	 
			 , AC_AM.AhsPlanName
			 , AC_AM.MEMBER_HOME_PHONE HomePhone
			 , AC_AM.MEMBER_MAIL_PHONE OtherPhone, ac_am.clientKey
			 FROM dbo.vw_ActiveMembers AC_AM
		  ) AS am
		  ON ntf.ClientMemberKey = am.MEMBER_ID
    JOIN		lst.List_Client Client     
	   ON			ntf.ClientKey = Client.ClientKey 
     LEFT JOIN (SELECT ps.ClientMemberKey, ps.phoneNumber, ps.carrier_type
			   FROM (SELECT ps.ClientMemberKey, ps.phoneNumber, RTRIM(LTRIM(ps.carrier_type)) AS carrier_type, ps.LoadDate
			   /* changed to rtrim/ltrim as the getcleanstring performs terribly, and the data should be clean already, boomi load does clean */
			 --FROM (SELECT ps.ClientMemberKey, ps.phoneNumber, [adi].[udf_GetCleanString](ps.carrier_type) AS carrier_type, ps.LoadDate 
			 
					   , ROW_NUMBER() OVER (PARTITION BY ps.ClientMemberKey ORDER BY ps.LoadDate DESC) AS arn
				    FROM acecaredw.adi.MpulsePhoneScrubbed ps				    				    
				) AS ps 
				WHERE ps.arn = 1
			 ) phnNum ON AM.MEMBER_ID = phnNum.ClientMemberKey
			 /* version history: GK 3/24/2021:Changes in the NTF process, to make it manage the requirements for Exported data have resulted in
							 in this job being simplier. ONLY filter for Patient Type, Follow up due date being something responsive, and Not yet exported
							 */
    WHERE ntf.NtfPatientType = 'IP'	   
	   AND ( (ntf.AceFollowUpDueDate >= getdate() ) )
	   AND	NTF.Exported =  0	   	   
	   
--/* 2/11/2021: gk changed where clause to export SHCN_MSSP census file Dishcharges, they are inferred 
--WHERE	
--    /* if they have a follow up date or if they are adm */
--   ( (ntf.AceFollowUpDueDate >= getdate() AND (NTF.CaseType <> 'Inhospital' ))    -- followup = dischare + interval from client: Datadate
--	   OR ((NTF.ClientKey = 16) AND (ntf.ntfEventType = 'ADM') )-- something and something
--	   )
--    AND	NTF.Exported = 0 -- 2
--    AND   NTF.NtfPatientType = 'IP'    
--    AND	(NTF.CaseType <> 'TRF'  )  -- remove inhospital when ADM
--    */
    ) src
WHERE src.aRowNumber = 1

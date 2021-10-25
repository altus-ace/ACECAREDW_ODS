

CREATE VIEW [dbo].[vw_RP_8x8CRM_Callcenter_New]
AS
         /* view returns less than 50k rows and the top 100000 clause makes it run in less than 10 seconds.
             with distinct it takes > 10 minutes
             In order to fix this it will likely need to be converted to a SP
                so we can use temp tables for the component pieces that coupld very fast
                
    VERSION HISTORY:
	   09/29/2020 GK: DB requested middles names/secondary address with value of of 'Unknown' substitute  '': implemented cases for the fields.			 
				    DB requested we supress duplicate records for programs: root cause more than one provider address in vw_ActiveMembers, supressed with distinct keyword 
	   10/26/2020 Gk for KC: Changed the Pcp Name, and Phone number to use provider roster data, not ahs data.
	   11/03/2020 Gk for KC: Changed the Pcp Name to use ahs data not provider roster data.
	   11/05/2020 GK added Addition phone numbers for Tin and a case statement to sub the Tin phone number if the PCP phone number is null
	   11/11/2020 GK Reformated pcp PHN num to return correct nums in right heirarchy (fpr>activeMem>tin) and always preface with 1)
				    */
     SELECT DISTINCT src.MembersIDNumber,src.[Customers.First_name],src.[Customers.Last_name],src.[Customers.Email],            src.[Customers.Alternative],
		  src.[Customers.Voice],src.[Customers.Alternative2],src.[Customers.Voice3],src.DateOfBirth,src.PrimaryAddress,src.PrimaryCity,
	   src.PrimaryState,src.PrimaryZip,src.[Secondary Address],src.[Secondary City],src.[Scondary State],src.[Secondary Zip],src.gender,src.PCPName,
	   --src.ActiveMembersPcpPhone, src.FctPrPcpPhone,src.TinPhone,    
	   -- use 1. fct num, 2. am pcpPHone 3. tinPhone
	   CASE WHEN ((ISNULL(src.FctPrPcpPhone,'') ='') AND (ISNULL(src.ActiveMembersPcpPhone,'') <> '')) THEN src.ActiveMembersPcpPhone
			 WHEN ((ISNULL(src.FctPrPcpPhone,'') ='') AND (ISNULL(src.ActiveMembersPcpPhone,'') = '') AND (src.PCP_PRACTICE_TIN <> '134334288')) THEN src.TinPhone
			 ELSE src.FctPrPcpPhone
			 END AS PcpPhone,
	   src.MCO,src.MCOEffectiveDate,src.MCOProduct,src.LineOfBusiness,src.HEDISGap,src.HedisDateRange ,src.HEDISStatus,
	   src.AGE,src.[Language],src.Comments,src.[AppointmentDate],src.[CaregiverName]
	   --,src.PCP_PRACTICE_TIN  
	   
    FROM (	   
	   SELECT distinct 
	          RTRIM(ActiveMembers.member_id) AS MembersIDNumber,
	          Concat(RTRIM(ActiveMembers.MEMBER_FIRST_NAME), ' ', CASE WHEN (RTRIM(ActiveMembers.MEMBER_MI) = 'UNKNOWN') THEN '' ELSE ActiveMembers.MEMBER_MI END) [Customers.First_name],
	          ActiveMembers.member_last_name AS [Customers.Last_name],
	          '' AS [Customers.Email],            
	   	  CASE WHEN (ISNULL(RTRIM(LTRIM(PreferredPhone.PHONE_NUMBER)), '') = '') then ''
	   		  WHEN (SUBSTRING(ISNULL(RTRIM(LTRIM(PreferredPhone.PHONE_NUMBER)), ''), 1,1) <> '1') THEN concat('1',RTRIM(LTRIM(PreferredPhone.PHONE_NUMBER))) 
	   		  ELSE RTRIM(LTRIM(PreferredPhone.PHONE_NUMBER)) END AS [Customers.Alternative],
	   	 CASE WHEN (ISNULL(RTRIM(LTRIM(PrimaryPhone.Phone_number)), '') = '') then ''
	   		  WHEN (SUBSTRING(ISNULL(RTRIM(LTRIM(PrimaryPhone.Phone_number)), ''), 1,1) <> '1') THEN concat('1',RTRIM(LTRIM(PrimaryPhone.Phone_number))) 
	   		  ELSE RTRIM(LTRIM(PrimaryPhone.Phone_number)) END AS [Customers.Voice],
	   	   CASE WHEN (ISNULL(RTRIM(LTRIM(CellPhone.PHONE_NUMBER)), '') = '') then ''
	   		  WHEN (SUBSTRING(ISNULL(RTRIM(LTRIM(CellPhone.PHONE_NUMBER)), ''), 1,1) <> '1') THEN concat('1',RTRIM(LTRIM(CellPhone.PHONE_NUMBER))) 
	   		  ELSE RTRIM(LTRIM(CellPhone.PHONE_NUMBER)) END AS [Customers.Alternative2],
	   	  CASE WHEN (ISNULL(RTRIM(LTRIM(MobilePhone.PHONE_NUMBER)), '') = '') then ''
	   		  WHEN (SUBSTRING(ISNULL(RTRIM(LTRIM(MobilePhone.PHONE_NUMBER)), ''), 1,1) <> '1') THEN concat('1',RTRIM(LTRIM(MobilePhone.PHONE_NUMBER))) 
	   		  ELSE RTRIM(LTRIM(MobilePhone.PHONE_NUMBER)) END AS [Customers.Voice3],
	          CONVERT(VARCHAR(10), ActiveMembers.date_of_birth, 101) AS DateOfBirth,
	          pdd.PrimaryAddress AS PrimaryAddress,
	          pdd.PrimaryCity,
	          pdd.PrimaryState,
	          CASE WHEN LEN(pdd.PrimaryZip)>5 THEN RIGHT(pdd.PrimaryZip,5)
	          ELSE pdd.PrimaryZip END AS PrimaryZip,
	          Concat(MEMBER_HOME_ADDRESS, CASE WHEN ([MEMBER_HOME_ADDRESS2] = 'UNKNOWN') THEN '' ELSE MEMBER_HOME_ADDRESS2 END) AS [Secondary Address],
	          [MEMBER_HOME_CITY] AS [Secondary City],
	          LTRIM(RTRIM([MEMBER_HOME_STATE])) AS [Scondary State],
	          CASE  WHEN LEN([MEMBER_HOME_ZIP_C]) > 5 THEN RIGHT([MEMBER_HOME_ZIP_C], 5)
	                ELSE [MEMBER_HOME_ZIP_C] END AS [Secondary Zip],
	          ActiveMembers.gender,
	          PhyD.PCP_Name AS PCPName,
	          CASE WHEN ((SUBSTRING(ISNULL(RTRIM(LTRIM(activeMembers.PCP_PHONE )), ''), 1,1) <> 1) and (NOT ActiveMembers.PCP_PHONE IS NULL))THEN concat(1,activeMembers.PCP_PHONE)
	   			    ELSE activeMembers.PCP_PHONE END AS ActiveMembersPcpPhone		, 
	   	  CASE WHEN ((SUBSTRING(ISNULL(RTRIM(LTRIM(fctp.PcpPhoneNumber )), ''), 1,1) <> 1) AND (NOT fctp.PcpPhoneNumber is NULL)) THEN concat(1,fctp.PcpPhoneNumber)
	   			    ELSE fctp.PcpPhoneNumber END AS FctPrPcpPhone,
	   	  CASE WHEN ((SUBSTRING(ISNULL(RTRIM(LTRIM(TinAdditionalPhones.tinphone )), ''), 1,1) <> 1) AND (NOT TinAdditionalPhones.TinPhone IS NULL))THEN concat(1,TinAdditionalPhones.tinphone)
	   			    ELSE TinAdditionalPhones.tinphone END	AS 	 TinPhone,    
	          ActiveMembers.client AS MCO,
	          CONVERT(VARCHAR(10), ActiveMembers.MEMBER_CUR_EFF_DATE, 101) AS MCOEffectiveDate,
	          --    LBP.start_date AS Plan_start_date,
	          CASE
	              WHEN ActiveMembers.client = 'AET'
	                   OR ActiveMembers.client = 'WLC'
	                   OR ActiveMembers.client = 'DHTX'
	              THEN 'Medicare Advantage'
	              WHEN ActiveMembers.client = 'Aetcom'
	              THEN 'Commericial'
	              WHEN ActiveMembers.client = 'UHC'
	              THEN 'Medicaid'
	              ELSE ActiveMembers.client
	          END AS MCOProduct,
	          ActiveMembers.Plan_Desc AS LineOfBusiness,
	          PE.[PROGRAM_NAME] AS HEDISGap,
	          --Concat(CONVERT(VARCHAR(10), a.MEMBER_CUR_EFF_DATE, 101), '-', CONVERT(VARCHAR(10), a.MEMBER_CUR_TERM_DATE, 101)) AS Old_HedisDateRange, -- Convert into dates
	   	  -- dates changed to use the program dates when available and the Member effectivedates when not GK 09/23/2020
	   	  CONCAT(CONVERT(VARCHAR(10), ISNULL(pe.START_DATE, ActiveMembers.member_cur_eff_date), 101) ,'-', CONVERT(VARCHAR(10), ISNULL(pe.end_date, ActiveMembers.MEMBER_CUR_TERM_DATE) ,101)) AS HedisDateRange ,
	          PE.PROGRAM_STATUS_NAME AS HEDISStatus,
	          ActiveMembers.AGE,
	          ActiveMembers.LANG_CODE AS [Language],
	          act.outcomenotes AS Comments,
	          CONVERT(VARCHAR(10), App.appointment_date, 101) AS [AppointmentDate],
	          Concat(ActiveMembers.RESP_LAST_NAME, ' ', ActiveMembers.RESP_FIRST_NAME) AS [CaregiverName]
			, ActiveMembers.PCP_PRACTICE_TIN
    
	   FROM  (SELECT am.member_id, am.PCP_PRACTICE_TIN, adw.AceCleanPhoneNumber(am.PCP_PHONE) PCP_PHONE, am.RESP_LAST_NAME, am.RESP_FIRST_NAME ,
	   			am.MEMBER_HOME_ADDRESS, am.MEMBER_HOME_ADDRESS2, am.Member_home_city, am.Member_home_State, am.member_home_zip_c, am.Gender, am.DATE_OF_BIRTH, 
	   			am.MEMBER_FIRST_NAME, am.MEMBER_MI, am.member_last_name ,
	   			am.clientKey, am.LANG_CODE, am.AGE, am.MEMBER_CUR_EFF_DATE, am.MEMBER_CUR_TERM_DATE, am.PLAN_DESC, am.CLIENT
	   			FROM acecaredw.dbo.vw_ActiveMembers am) ActiveMembers -- 31534	-- 31534	
	   			/* GK: 0923 Per new requriement from Dee, Members with null Hedis care gap are not needed on the report */
	      JOIN (SELECT client_patient_id,                 start_date,                 end_date,                 program_status_name,                 program_name
	                  FROM ahs_altus_prod.dbo.vw_ace_alt_pe
	   			WHERE PROGRAM_STATUS_NAME in ('ACTIVE', 'IN PROGRESS') -- GK 09/23: changed from IN('Error', 'Expired', 'Term') per new requierement from Dee 
	                     AND end_date >= '1/1/2019'				   
	                     --AND YEAR(end_date) >= 2019 this is slow.                      
	              ) PE ON pe.client_patient_id = ActiveMembers.member_id       -- 60198			 
	        LEFT JOIN (SELECT PATIENT_ID,                 CLIENT_PATIENT_ID
	                  FROM ahs_altus_prod.dbo.PATIENT_DETAILS								
	              ) PD ON PD.client_patient_id = ActiveMembers.member_id  --106105
	        LEFT JOIN (SELECT DISTINCT  PATIENT_ID,    LTRIM(RTRIM(Concat(REPLACE(REPLACE(ADDRESS_TEXT, CHAR(13), ''), CHAR(10), ''), ', '))) AS PrimaryAddress,
	                  REPLACE(REPLACE(CITY, CHAR(13), ''), CHAR(10), '') AS PrimaryCity,
	                  REPLACE(REPLACE(STATE, CHAR(13), ''), CHAR(10), '') AS PrimaryState,
	                  REPLACE(REPLACE(ZIP, CHAR(13), ''), CHAR(10), '') AS PrimaryZip
	                  FROM ahs_altus_prod.dbo.[PATIENT_PREFERRED_ADDRESS]
	                  WHERE Deleted_on IS NULL
	              ) pdd ON PDD.PATIENT_ID = PD.PATIENT_ID        -- 5501
	        LEFT JOIN (SELECT DISTINCT phoneNumb.patient_id, replace(replace(replace(replace(phoneNumb.PHONE_NUMBER, '-', ''), '(',''), ')', ''), ' ' ,'') AS Phone_number
	                  FROM ahs_altus_prod.dbo.PATIENT_PHONE phoneNumb
	                  WHERE phoneNumb.IS_PREFERRED = 1			
	              ) AS PreferredPhone ON PD.PATIENT_ID = PreferredPhone.PATIENT_ID    -- 3007
	   	LEFT JOIN (SELECT phoneNumb.PATIENT_ID, replace(replace(replace(replace(phoneNumb.PHONE_NUMBER, '-', ''), '(',''), ')', ''), ' ' ,'') AS Phone_number
	   			FROM (SELECT Phone.PATIENT_ID, Phone.PHONE_NUMBER 
	   				   , ROW_NUMBER() OVER (PARTITION BY Phone.PATIENT_ID ORDER BY  Phone.PhoneDate DESC) arn
	   				   FROM(SELECT Phones.patient_id, Phones.Phone_number
	      					  , CASE WHEN (Phones.CREATED_ON > ISNULL(Phones.UPDATED_ON, '01/01/1900')) THEN PHones.CREATED_ON 
	          						ELSE phones.UPDATED_ON END AS PhoneDate
	   					  FROM Ahs_Altus_Prod.dbo.PATIENT_PHONE Phones) Phone
	   				   ) phoneNumb
	   			WHERE phoneNumb.arn = 1
	   			    ) AS PrimaryPhone ON PD.PATIENT_ID = PrimaryPhone.PATIENT_ID    -- 3007
	        LEFT JOIN (SELECT phoneNumb.PATIENT_ID, replace(replace(replace(replace(phoneNumb.PHONE_NUMBER, '-', ''), '(',''), ')', ''), ' ' ,'') AS Phone_number
	   			    FROM (SELECT Phone.PATIENT_ID, Phone.PHONE_NUMBER 
	   					  , ROW_NUMBER() OVER (PARTITION BY Phone.PATIENT_ID ORDER BY  Phone.PhoneDate DESC) arn
	   					  FROM(SELECT Phones.patient_id, Phones.Phone_number
	      							, CASE WHEN (Phones.CREATED_ON > ISNULL(Phones.UPDATED_ON, '01/01/1900')) THEN PHones.CREATED_ON 
	          						    ELSE phones.UPDATED_ON END AS PhoneDate
	   							FROM Ahs_Altus_Prod.dbo.PATIENT_PHONE Phones) Phone
	   					  ) phoneNumb
	   					  WHERE phoneNumb.arn = 2
	   			    ) AS CellPhone ON PD.PATIENT_ID = CellPhone.Patient_id
	        LEFT JOIN (SELECT phoneNumb.PATIENT_ID, replace(replace(replace(replace(phoneNumb.PHONE_NUMBER, '-', ''), '(',''), ')', ''), ' ' ,'') AS Phone_number
	   			    FROM (SELECT Phone.PATIENT_ID, Phone.PHONE_NUMBER 
	   					  , ROW_NUMBER() OVER (PARTITION BY Phone.PATIENT_ID ORDER BY  Phone.PhoneDate DESC) arn
	   					  FROM(SELECT Phones.patient_id, Phones.Phone_number
	      							, CASE WHEN (Phones.CREATED_ON > ISNULL(Phones.UPDATED_ON, '01/01/1900')) THEN PHones.CREATED_ON 
	          						    ELSE phones.UPDATED_ON END AS PhoneDate
	   						 FROM Ahs_Altus_Prod.dbo.PATIENT_PHONE Phones) Phone
	   						 ) phoneNumb
	   					  WHERE phoneNumb.arn = 3
	   			    ) AS MobilePhone ON PD.PATIENT_ID =MobilePhone.Patient_id
	        LEFT JOIN(SELECT DISTINCT patient_id, PHYSICIAN_ID
	   				FROM ahs_altus_prod.[dbo].[PATIENT_PHYSICIAN] WHERE CARE_TEAM_ID = 2
	   					AND IS_PCP = 1
	   					AND END_DATE >= GETDATE()
	   				) as PPhy ON PPhy.patient_id = pd.patient_id
	   	  JOIN ( SELECT DISTINCT DISPLAY_VALUE, PROVIDER_ID
	   					FROM ahs_altus_prod.dbo.PROVIDER_INDEX 
	   					WHERE is_active = 1
	   					and INDEX_NAME = 'NPI'
	   				) ProI ON ProI.PROVIDER_ID = PPhy.physician_ID --1695
	   	LEFT JOIN( SELECT DISTINCT Concat(FIRST_NAME, ' ', LAST_NAME) AS PCP_Name, Work_phone AS [PCPPhoneNumber], physician_id
	   			    FROM ahs_altus_prod.dbo.PHYSICIAN_DEMOGRAPHY
	   			) PhyD ON PhyD.physician_ID = PPhy.physician_ID	  
	   	LEFT JOIN (SELECT src.NPI, src.EffectiveDate, src.ExpirationDate, src.RowEffectiveDate, src.RowExpirationDate, src.PcpPhoneNumber, src.arn FROM 
	   			( SELECT NPI,EffectiveDate, ExpirationDate, RowEffectiveDate, RowExpirationDate
	   				--, replace(replace(replace(replace(PrimaryAddressPhoneNum, '-', ''), '(',''), ')', ''), ' ' ,'')  AS PCPPhoneNumber
	   				, adw.AceCLeanPhoneNUmber(fctP.PrimaryAddressPHoneNum) AS PcpPhoneNumber
	   				,ROW_NUMBER() OVER (PARTITION BY npi ORDER BY EffectiveDate DESC) arn
	   				FROM [ACECAREDW].[adw].[fctProviderRoster] fctp
	   				WHERE isactive = 1
	   				AND getdate() BETWEEN RowEffectiveDate AND RowExpirationDate
	   				) src WHERE src.arn = 1
	   			) fctp ON fctp.npi = ProI.DISPLAY_VALUE
	        LEFT JOIN (SELECT tinPhone.TIN, 
	   			    CASE WHEN(SUBSTRING(tinPhone.Pcp_Phone,1, 1) <> 1)
	   				   THEN concat(1, tinPhone.Pcp_Phone) END AS TinPhone
	   			    FROM (SELECT am.PCP_PRACTICE_TIN TIN, adw.AceCleanPhoneNumber(am.PCP_PHONE) Pcp_Phone
	   					  FROM dbo.vw_ActiveMembers am
	   					  GROUP BY am.PCP_PRACTICE_TIN, am.PCP_PHONE
	   					  ) tinPhone 
	   			    WHERE ISNULL(tinPhone.Pcp_Phone, '')  <> ''
	   			    ) TinAdditionalPhones 
	   			    ON ActiveMembers.PCP_PRACTICE_TIN = TinAdditionalPhones.TIN
	        LEFT JOIN(SELECT PatActivities.OutcomeNotes, PatActivities.clientmemberkey, PatActivities.arn
	   			FROM(   SELECT DISTINCT OutcomeNotes, clientmemberkey, ROW_NUMBER() OVER(PARTITION BY clientmemberkey ORDER BY activitycreateddate DESC) arn
	   					  FROM [ACECAREDW].[dbo].[tmp_Ahs_PatientActivities]
	   					  WHERE OutcomeNotes IS NOT NULL ) PatActivities
	   			WHERE PatActivities.arn = 1) act 
	   			ON act.clientmemberkey = ActiveMembers.member_id --AND act.arn = 1       --29797
	        LEFT JOIN (SELECT Appointments.PATIENT_ID, Appointments.APPOINTMENT_DATE, Appointments.arn
	                  FROM (
	                        SELECT PATIENT_ID, APPOINTMENT_DATE, ROW_NUMBER() OVER(PARTITION BY patient_id ORDER BY appointment_date DESC) arn
	                        FROM ahs_altus_prod.dbo.appointment
	                        WHERE APPOINTMENT_DATE IS NOT NULL
	                     ) Appointments
	                  WHERE Appointments.arn = 1          
    
	              ) app ON app.PATIENT_ID = pd.PATIENT_ID        --16622
	                  AND app.appointment_date IS NOT NULL
	   	WHERE ActiveMembers.clientKey <> 16				
	) src	
	;

﻿
CREATE VIEW [adw].[vw_EXP_Notifications]
AS 
SELECT IP.ENTITY, 
       IP.ntfNOtificationKey, 
       IP.SITE, 
       IP.UID_STATE, 
       IP.UID_PROVIDER, 
       IP.PracticeName, 
       IP.Treatment_Type, 
       IP.Member_ID, 
       IP.Case_ID, 
       IP.CaseType, 
       IP.ADMIT_NOTIFICATION_DATE, 
       IP.ADIMSSION_DATE, 
       IP.DISCHARGE_DATE, 
       IP.DISCHARGE_DISPOSITION, 
       IP.FOLLOW_UP_VISIT_DUE_DATE, 
       IP.SCHEDULED_VISIT_DATE, 
       IP.PRIMARY_DIAGNOSIS, 
       IP.AdmitHospital, 
       IP.Client_ID, 
       IP.Exported, 
       IP.ExportedDate, 
       IP.Benefit_Plan, 
       IP.PHoneNumber, 
       IP.Carrier_Type, 
       IP.Member_First_Name, 
       IP.MEMBER_LAST_NAME, 
       IP.MEMBER_DOB, 
       IP.DataSource, 
       IP.ntfEventType, 
       IP.AdiLineneageKey
FROM dbo.vw_AH_IPNotification IP
UNION 
SELECT ER.ENTITY, 
       ER.ntfNOtificationKey, 
       ER.SITE, 
       ER.UID_STATE, 
       ER.UID_PROVIDER, 
       ER.PracticeName, 
       ER.Treatment_Type, 
       ER.Member_ID, 
       ER.Case_ID, 
       ER.CaseType, 
       ER.ADMIT_NOTIFICATION_DATE, 
       ER.ADIMSSION_DATE, 
       ER.DISCHARGE_DATE, 
       ER.DISCHARGE_DISPOSITION, 
       ER.FOLLOW_UP_VISIT_DUE_DATE, 
       ER.SCHEDULED_VISIT_DATE, 
       ER.PRIMARY_DIAGNOSIS, 
       ER.AdmitHospital, 
       ER.Client_ID, 
       ER.Exported, 
       ER.ExportedDate, 
       ER.Benefit_Plan, 
       ER.PHoneNumber, 
       ER.Carrier_Type, 
       ER.Member_First_Name, 
       ER.MEMBER_LAST_NAME, 
       ER.MEMBER_DOB, 
       ER.DataSource, 
       ER.ntfEventType, 
       ER.AdiLineneageKey
FROM [dbo].[vw_AH_ERNotification] ER;



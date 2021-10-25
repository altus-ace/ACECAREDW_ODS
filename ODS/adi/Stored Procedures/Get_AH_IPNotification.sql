
CREATE  PROCEDURE [adi].[Get_AH_IPNotification]
  
AS 
BEGIN 

-- SELECT @RowCount = Count(*) 
-- FROM [ACECAREDW].[adw].[vw_CopyNotificationsGhh]
--SELECT CN.DataDate
--INTO  [adi.NtfNotificationsGhh].DataDate
--FROM  [adw].[vw_CopyNotificationsGhh] CN

SELECT [ntfNOtificationKey]
      ,[SITE]
      ,[UID_STATE]
      ,[UID_PROVIDER]
      ,[PracticeName]
      ,[Treatment_Type]
      ,[Member_ID]
      ,[Case_ID]
      ,[CaseType]
      ,[ADMIT_NOTIFICATION_DATE]
      ,[ADIMSSION_DATE]
      ,[DISCHARGE_DATE]
      ,[DISCHARGE_DISPOSITION]
      ,[FOLLOW_UP_VISIT_DUE_DATE]
      ,[SCHEDULED_VISIT_DATE]
      ,[PRIMARY_DIAGNOSIS]
      ,[AdmitHospital]
      ,[Client_ID]
      ,[Exported]
      ,[ExportedDate]
      ,[Benefit_Plan]
      ,[PHoneNumber]
      ,[Carrier_Type]
      ,[Member_First_Name]
      ,[MEMBER_LAST_NAME]
      ,[MEMBER_DOB]
      ,[DataSource]
      ,[ntfEventType]
      ,[AdiLineneageKey]
  FROM [ACECAREDW].[dbo].[vw_AH_IPNotification]

  DECLARE @NTF TABLE  
  (  
    NTFKey INT IDENTITY(1,1),  
    ntfNOtificationKey INT    
 )   

  INSERT INTO @NTF(ntfNOtificationKey) 
  SELECT ntfNOtificationKey FROM [ACECAREDW].[dbo].[vw_AH_IPNotification]
  
  UPDATE [ACECAREDW].[adw].[NtfNotification]  
  SET Exported = 1
  WHERE ntfNotificationKey IN (SELECT ntfNOtificationKey FROM @NTF)    
  
END


--INSERT INTO adi.NtfNotificationsGhh([DataDate],[AceID])
--SELECT [DataDate], [AceID]
--FROM [ACECAREDW].[adw].[vw_CopyNotificationsGhh]

--Msg 208, Level 16, State 1, Procedure CopyGHHNotification, Line 9
--Invalid object name 'ACE-SDV-DB02.Ace_CP01.athIB.Notifications'.

--SELECT column-names
--  INTO new-table-name
--  FROM table-name
-- WHERE EXISTS 
--      (SELECT column-name
 --        FROM table-name
 --       WHERE condition)


 -- [Ace_CP01].[athIB].[Notifications]

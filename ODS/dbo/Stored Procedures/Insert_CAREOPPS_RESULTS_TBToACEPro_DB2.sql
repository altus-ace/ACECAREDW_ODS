
CREATE procedure [dbo].[Insert_CAREOPPS_RESULTS_TBToACEPro_DB2]

AS
BEGIN

INSERT INTO [ACE-SDV-DB02.ACE_PROD].[dbo].[vw_CAREOPPS_RESULTS_TB]
           ([CAREOPPS_RESULT_CREATE_DATE]
           ,[CLIENT_ID]
           ,[MEMBER_ID]
           ,[HEDIS_ID]
           ,[CAREOPPS_DESC]
           --,[RESPONSE1]
           --,[RESPONSE2]
           --,[RESPONSE3]
           --,[RESPONSE4]
           --,[RESPONSE_DATE]
           --,[REPONSE_BY]
           ,[CAMPAIGN_ID]
           ,[CREATE_BY]
           ,[CREATE_DT]
           ,[LAST_MODIFY_BY]
           ,[LAST_MODIFY_DT]
           ,[CAMPAIGN_RUN_ID])
  SELECT      '2019-11-15'
                    ,'UHG'
					,QM_RBMH_DB01.ClientMemberKey
                   -- ,'108794992'
				   ,'19_' + QM_RBMH_DB01.QmMsrId
                   -- ,'19_UHC_CCS'
                    ,''
                    ,''
                    ,'BoomiDbUser'
                    ,GETDATE()
                    ,'BoomiDbUser'
                    ,GETDATE()
                    ,''          
FROM [ACE-SDV-DB01].[ACECAREDW].[adw].[QM_ResultByMember_History] QM_RBMH_DB01
where QM_RBMH_DB01.QmMsrId like '%UHC%'
 
END

CREATE PROCEDURE adi.InsertMPulsePhoneScrubbed 
AS
    INSERT INTO [adi].[MPulsePhoneScrubbed]
           ([ClientMemberKey]
           ,[Client_ID]
           ,[Ace_ID_Mrn]
           ,[phoneNumber]
           ,[carrier_type]
           ,[carrier_name]
           ,[NNID_CALLED]
           ,[NNID_FAILURES]
           ,[srcFileName]
           ,[LoadDate]
           ,[DataDate]
           ,[CreatedDate]
           ,[CreatedBy])
    SELECT 
      rtrim(ltrim([ClientMemberKey])) AS [ClientMemberKey]    
      , CONVERT(INT, [adi].[udf_GetCleanString](Client_ID)) As Client_ID
      , CASE WHEN TRY_CONVERT(numeric(15,0), Ace_ID_Mrn) is NULL then CONVERT(NUMERIC(15,0),0) ELSE CONVERT(NUMERIC(15,0), ACE_ID_Mrn) END AS Ace_ID_MRN
      ,rtrim(ltrim([phoneNumber])) AS [phoneNumber]
      ,rtrim(ltrim([carrier_type])) AS [carrier_type]
      ,rtrim(ltrim([carrier_name])) AS [carrier_name]
      ,rtrim(ltrim([NNID_CALLED])) AS [NNID_CALLED]
      ,rtrim(ltrim([NNID_FAILURES])) AS [NNID_FAILURES]
      ,[srcFileName]
      ,[LoadDate]
      ,[DataDate]
      ,[CreatedDate]
      ,[CreatedBy]
  FROM [ast].[MPulsePhoneScrubbed]
  WHERE ISNULL(clientMemberKey, '') <> '';
 

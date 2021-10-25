CREATE PROCEDURE [adi].[AcePdiMbrWlcMbrByPcp0024]	
  @adiMbrUhcMbrByPcp_InsertCount INT OUTPUT
AS
	/* #2 POC Load stage to ADI */

    DECLARE @OutputTbl TABLE (ID INT);
    
    
    INSERT INTO [adi].[MbrWlcMbrByPcp]
               ([Prov_id]
               ,[Prov_Name]
               , Sub_ID
    		 , SEQ_Mem_ID
               ,[EffDate]
               ,[FirstName]
               ,[LastName]
               , GENDER
    		 ,[IPA]
               ,[BirthDate]
               ,[MEDICAID_NO]
    		 ,[MEDICAL_REC_NO]		 
    		 ,TermDate
    		 ,LOB
    		 ,[BenePLAN]
    		 ,[AGENT_NUM]
    		 ,[Enrollment_Source]
               ,[ADDRESS_TYPE]
               ,[Address]
               ,[City]
               ,[State]
               ,[Zip]
               ,[County]
               ,[PhoneNumber]
               ,[MOBILE_PHONE]
               ,[ALT_PHONE]
    		 , SrcFileName
               ,[InQuarantine]
               ,[LoadDate]
               ,[DataDate]
    		 )
    OUTPUT inserted.mbrWlcMbrByPcpKey INTO @OutputTbl(ID)
    SELECT 
          CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[Prov_id]))) AS Prov_ID
          ,CONVERT(VARCHAR(150), RTRIM(LTRIM(s.[Prov_Name]))) AS Prov_Name
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.Sub_ID))) AS sub_id
    	 ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.SEQ_Mem_ID))) AS Seq_Mem_ID
          ,CONVERT(DATE, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(LTRIM(s.[EffDate])),101),101))  AS EffDate
          ,CONVERT(VARCHAR(75), RTRIM(LTRIM(s.[FirstName]))) AS FName
          ,CONVERT(VARCHAR(75), RTRIM(LTRIM(s.[LastName]))) AS LName
    	 ,CONVERT(VARCHAR(10), RTRIM(LTRIM(s.GENDER))) AS GENDER
          ,CONVERT(VARCHAR(20), RTRIM(LTRIM(s.[IPA]))) AS IPA 
          ,CONVERT(DATE, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(LTRIM(s.[BirthDate])), 101),101)) AS BirthDate
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[MEDICAID_NO]))) AS Medicaid_No
    	 ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.MEDICAL_REC_NO))) AS Medical_Rec_No	 
    	 ,s.TermDate
          ,CONVERT(VARCHAR(10), RTRIM(LTRIM(s.[LOB]))) AS LOB
          ,CONVERT(VARCHAR(15), RTRIM(LTRIM(s.[Plan]))) AS [PLAN]
          ,CONVERT(VARCHAR(10), RTRIM(LTRIM(s.[AGENT_NUM]))) AS [AGENT_NUM]
          ,CONVERT(VARCHAR(10), RTRIM(LTRIM(s.[ENR_SRCE])))	 AS[ENR_SRCE]
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[ADDRESS_TYPE]))) AS AddressType
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[Address]))) AS Address
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[City]))) AS City
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[State]))) AS State
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[Zip]))) AS Zip
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[County]))) AS County
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[PhoneNumber]))) AS PhoneNum
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[MOBILE_PHONE]))) AS MobileNum
          ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[ALT_PHONE]))) AS AltPhoneNum
    	 , s.SrcFileName
          ,0 AS InQuarantine
          ,s.[LoadDate]
          ,s.[DataDate]      
      FROM [ast].[MbrWlcMbrByPcp] s
        LEFT JOIN adi.MbrWlcMbrByPcp d ON 
    	   s.Sub_ID = d.Sub_ID
    	   AND s.LoadDate = d.LoadDate
      WHERE s.InQuarantine = 0
        and d.mbrWlcMbrByPcpKey is null;
    
      SELECT @adiMbrUhcMbrByPcp_InsertCount = COUNT(*)  
      FROM @OutputTbl;
    
RETURN;

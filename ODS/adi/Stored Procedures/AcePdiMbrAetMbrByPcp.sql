CREATE PROCEDURE [adi].[AcePdiMbrAetMbrByPcp]	
  @adiMbrMbrByPcp_InsertCount INT OUTPUT
AS
	/* #2 POC Load stage to ADI */

DECLARE @OutputTbl TABLE (ID INT);


INSERT INTO [adi].[MbrAetMbrByPcp]
           ([NPI]
      ,[MSCIndicator]
      ,[LastName]
      ,[FirstName]
      ,[Address]
      ,[PhoneNumber]
      ,[HICN]
      ,[Product]
      ,[GroupIndicator]
      ,[TermDate]
      ,[Gender]
      ,[DOB]
      ,[Age]
      ,[PartDInd]
      ,[CMInd]
      ,[TIN]
      ,[Month]
      ,[PBGNumber]
      ,[PBGName]
      ,[SubgroupNumber]
      ,[SubgroupName]
      ,[TINName]
      ,[PhysicianNumber]
      ,[PhysicianName]
      ,[PhysicianAddress]
      ,[SpecialtyCategory]
      ,[Legacy]
      ,[SRCMemberID]
      ,[AetSubscriberID]
      ,[EffectiveDate]
      ,[RAFactorType]
      ,[RiskScore]
      ,[PULSEScore]
      ,[SrcFileName]
      ,[InQuarantine]
      ,[LoadDate]
      ,[DataDate] 
      ,[CreateDate]
      ,[CreateBy]
	 ,[LastUpdatedDate] 
	 ,[LastUpdatedBy]
	)
OUTPUT inserted.mbrAetMbrByPcpKey INTO @OutputTbl(ID)
SELECT 
       CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[NPI]))) as NPI														   
      ,CONVERT(VARCHAR(3), RTRIM(LTRIM(s.MSCIndicator))) as MSCIndicator
      ,CONVERT(VARCHAR(75), RTRIM(LTRIM(s.LastName))) as [LastName]
      ,CONVERT(VARCHAR(75), RTRIM(LTRIM(s.FirstName))) as [FirstName]
      ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[Address]))) as [Address]
      ,CONVERT(VARCHAR(25), RTRIM(LTRIM(s.PhoneNumber))) as [PhoneNumber]
      ,CONVERT(VARCHAR(15), RTRIM(LTRIM(s.[HICN]))) as [HICN]
      ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[Product]))) as [Product]
      ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.GroupIndicator))) as [GroupIndicator]
      ,CONVERT(DATE, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(LTRIM(s.TermDate)),101),101)) as [TermDate]
	 ,CONVERT(VARCHAR(20), RTRIM(LTRIM(s.[Gender]))) as [Gender]      
	 ,CONVERT(DATE, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(LTRIM(s.[DOB])), 101),101)) AS DOB
      ,ISNULL(TRY_CONVERT(INT, s.Age), -1)    as [Age]
      ,CONVERT(VARCHAR(3), RTRIM(LTRIM(s.PartDInd))) as [PartDInd]
      ,CONVERT(VARCHAR(3), RTRIM(LTRIM(s.CmInd))) as [CMInd]
      ,CONVERT(VARCHAR(15), RTRIM(LTRIM(s.[TIN]))) as [TIN]
      ,CONVERT(DATE, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(LTRIM(s.Month)), 101),101)) as [Month]	  
      ,CONVERT(VARCHAR(20), RTRIM(LTRIM(s.[PbgNumber]))) as[PBGNumber]
      ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[PbgName]))) as [PBGName]
      ,CONVERT(VARCHAR(10), RTRIM(LTRIM(s.[SubgroupNumber]))) as [SubgroupNumber]
      ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[SubgroupName]))) as [SubgroupName]
      ,CONVERT(VARCHAR(100), RTRIM(LTRIM(s.[TINName]))) as [TINName]
      ,CONVERT(VARCHAR(10), RTRIM(LTRIM(s.[PhysicianNumber]))) as [PhysicianNumber]
      ,CONVERT(VARCHAR(150), RTRIM(LTRIM(s.[PhysicianName]))) as [PhysicianName]
      ,CONVERT(VARCHAR(225), RTRIM(LTRIM(s.[PhysicianAddress]))) as [PhysicianAddress]
      ,CONVERT(VARCHAR(60), RTRIM(LTRIM(s.[SpecialtyCategory]))) as [SpecialtyCategory]
      ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[Legacy]))) as [Legacy]
      ,CONVERT(VARCHAR(20), RTRIM(LTRIM(s.[SrcMemberID]))) as [SRCMemberID]
      ,CONVERT(VARCHAR(50), RTRIM(LTRIM(s.[MemberID]))) as AetSubscriberID
      ,CONVERT(DATE, CONVERT(VARCHAR(10), CONVERT(DATETIME, RTRIM(LTRIM(s.[EffectiveDate])),101),101)) as [EffectiveDate]	 
      ,CONVERT(VARCHAR(10), RTRIM(LTRIM(s.[RaFactorType]))) as [RAFactorType]
      ,TRY_CONVERT(decimal(5,2),  s.RiskScore)  as [RiskScore]
      ,TRY_CONVERT(decimal(5,2),  s.PulseScore)   as [PULSEScore]
      ,CONVERT(VARCHAR(150), RTRIM(LTRIM(s.[SrcFileName]))) as [SrcFileName]
      ,0 as [InQuarantine]
      ,s.[LoadDate]
      ,s.[DataDate] 
      ,s.[CreateDate]
      ,s.[CreateBy]
	 ,GETDATE() as [LastUpdatedDate] 
	 ,SYSTEM_USER as [LastUpdatedBy]      
FROM [ast].[MbrAetMbrByPcp] s
    LEFT JOIN adi.MbrAetMbrByPcp d ON s.MemberID = d.AetSubscriberID
	   AND s.LoadDate = d.LoadDate
  WHERE s.InQuarantine = 0
    and d.mbrAetMbrByPcpKey is null;

SELECT @adiMbrMbrByPcp_InsertCount = COUNT(*)
FROM @OutputTbl;
RETURN;

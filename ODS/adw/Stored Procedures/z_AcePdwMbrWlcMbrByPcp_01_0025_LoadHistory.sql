
CREATE PROCEDURE [adw].[z_AcePdwMbrWlcMbrByPcp_01_0025_LoadHistory]
    @DataDate DATE ,
    @loadType CHAR(1),
    @InsertCount INT OUTPUT
AS
    DECLARE @OutputTbl TABLE (ID INT);
    DECLARE @AdiTableName VARCHAR(50) = 'MbrWlcMbrByPcp';

    IF OBJECT_ID('dbo.tmpWlcMbrLoadHist') IS NOT NULL 
        DROP TABLE dbo.tmpWlcMbrLoadHist;
    CREATE TABLE dbo.tmpWlcMbrLoadHist([AdiTableName] varchar(100), [AdiKey] INT ,[LoadDate] DATE      
		,[DataDate] DATE , loadType CHAR(1), tmpWlcMbrLoadHistSKey INT NOT NULL IDENTITY(1,1) PRIMARY KEY);

    
    INSERT INTO dbo.tmpWlcMbrLoadHist
           ([AdiTableName]
		 ,[AdiKey]
           ,[LoadDate]
           ,[DataDate]
		 , loadType
           )        --  DECLARE @DataDate DATE = '2021-04-20'  DECLARE @adiTableName VARCHAR(50) = 'adi.MbrWlcMbrByPcp' DECLARE @loadType VARCHAR(2) = 'P'    
    SELECT DISTINCT
	   @AdiTableName
	   , AdiMbrs.mbrWlcMbrByPcpKey
	   , CONVERT(DATE, GETDATE()) AS loadDate
	   , AdiMbrs.DataDate
	   , @loadType
    FROM  adi.tvf_PdwSrc_Wlc_MemberByPcp( @DataDate) AdiMbrs
        LEFT JOIN adw.MbrLoadHistory lh ON AdiMbrs.mbrWlcMbrByPcpKey = lh.adiKey and lh.adiTableName = @adiTableName
	   JOIN adw.MbrWlcProviderLookup pl ON AdiMbrs.Prov_id = pl.Prov_id  
		  AND @Datadate <= pl.Term_Date
    WHERE lh.mbrLoadHistoryKey is null
	   ;

    INSERT INTO [adw].[MbrLoadHistory]( adiTableName, Adikey, LoadDate, DataDate, LoadType)
    OUTPUT inserted.mbrLoadHistoryKey INTO @OutputTbl(ID)    
    SELECT [AdiTableName]		 ,[AdiKey]           ,[LoadDate]           ,[DataDate]		 , loadType
    FROM dbo.tmpWlcMbrLoadHist

    SELECT @InsertCount  = COUNT(*) 
    FROM @OutputTbl o;
    RETURN;

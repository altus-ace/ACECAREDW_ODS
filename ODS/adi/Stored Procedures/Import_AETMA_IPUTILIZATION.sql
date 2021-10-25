﻿
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import_AETMA_IPUTILIZATION](
    @OriginalFileName varchar (100)  ,
	@SrcFileName varchar (100)  ,
	@LoadDate varchar(10)   ,
	--@CreatedDate date   ,
	@CreatedBy varchar (50)  ,
--	@LastUpdatedDate datetime   ,
	@LastUpdatedBy varchar (50)  ,
	@ProviderGroupNumber varchar(50) ,
	@ProviderGroupName varchar(50) ,
	@SubgroupName varchar(50) ,
	@TIN varchar(20) ,
	@TINName varchar(50) ,
	@PIN varchar(20) ,
	@ProviderName varchar(50) ,
	@GroupIndicator varchar(10) ,
	@LocalMarketCode varchar(20) ,
	@LocalMarket varchar(50) ,
	@Legacy varchar(20) ,
	@BaselineInd varchar(20) ,
	@MemberID varchar(20) ,
	@Member varchar(50) ,
	@YearMonth varchar(20) ,
	@StartDate varchar(10) ,
	@EndDate varchar(10) ,
	@Admits varchar(20) ,
	@Days varchar(10) ,
	@Year varchar(10) ,
	@Month varchar(20) ,
	@Diagnosis varchar(50) ,
	@MedicalCaseID varchar(20) ,
	@ServiceProviderID varchar(20) ,
	@ServiceProviderName varchar(50) ,
	@ProviderType varchar(50) ,
	@InpatientType varchar(20) ,
	@Day_14_Follow_up_OfficeVisit varchar(10) ,
	@Data_AS_OF varchar(10) 
	
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--IF(@ReportGroup != '')
	EXEC [ACDW_CLMS_AET_MA].adi.Import_AETMA_IPUTILIZATION
	@OriginalFileName   ,
	@SrcFileName   ,
	@LoadDate    ,
	--@CreatedDate date   ,
	@CreatedBy   ,
--	@LastUpdatedDate datetime   ,
	@LastUpdatedBy   ,
	@ProviderGroupNumber  ,
	@ProviderGroupName  ,
	@SubgroupName  ,
	@TIN  ,
	@TINName  ,
	@PIN  ,
	@ProviderName  ,
	@GroupIndicator  ,
	@LocalMarketCode  ,
	@LocalMarket  ,
	@Legacy  ,
	@BaselineInd  ,
	@MemberID  ,
	@Member  ,
	@YearMonth  ,
	@StartDate  ,
	@EndDate  ,
	@Admits  ,
	@Days  ,
	@Year  ,
	@Month  ,
	@Diagnosis  ,
	@MedicalCaseID  ,
	@ServiceProviderID  ,
	@ServiceProviderName  ,
	@ProviderType  ,
	@InpatientType  ,
	@Day_14_Follow_up_OfficeVisit  ,
	@Data_AS_OF  
END





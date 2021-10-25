-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPBeneficiaryExclusion]
    @SrcFileName varchar(100) ,
	--[CreateDate [datetime ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100) ,
	--@LastUpdatedDate @datetime ,
	@DataDate varchar(10) ,
	@PerformanceYearNBR varchar(50) ,
	@ReportMonthNBR varchar(50) ,
	@FileCreationDTS varchar(10) ,
	@HealthInsuranceClaimNBR varchar(50) ,
	@MedicareBeneficiaryID varchar(50) ,
	@FirstNM varchar(50) ,
	@MiddleNM varchar(10) ,
	@LastNM varchar(50) ,
	@BirthDTS varchar(10),
	@GenderCD varchar(10) ,
	@GenderDSC varchar(100) ,
	@Reason01CD varchar(10) ,
	@Reason01DSC varchar(100) ,
	@Reason02CD varchar(10) ,
	@Reason02DSC varchar(100) ,
	@Reason03CD varchar(10) ,
	@Reason03DSC varchar(100) ,
	@fileNM varchar(50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_SHCN_MSSP].adi.ImportMSSPBeneficiaryExclusion
	@SrcFileName  ,
	--[CreateDate [datetime ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy  ,
	--@LastUpdatedDate @datetime ,
	@DataDate  ,
	@PerformanceYearNBR  ,
	@ReportMonthNBR  ,
	@FileCreationDTS  ,
	@HealthInsuranceClaimNBR  ,
	@MedicareBeneficiaryID  ,
	@FirstNM  ,
	@MiddleNM  ,
	@LastNM  ,
	@BirthDTS ,
	@GenderCD  ,
	@GenderDSC  ,
	@Reason01CD  ,
	@Reason01DSC  ,
	@Reason02CD  ,
	@Reason02DSC  ,
	@Reason03CD  ,
	@Reason03DSC  ,
	@fileNM  
    
END

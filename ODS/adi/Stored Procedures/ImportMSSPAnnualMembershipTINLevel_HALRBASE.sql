-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPAnnualMembershipTINLevel_HALRBASE]
    @SrcFileName [varchar](100) NULL,
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	
	@YearNBR [varchar](50) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@FirstNM [varchar](20) NULL,
	@LastNM [varchar](50) NULL,
	@SexCD [varchar](10) NULL,
	@BirthDTS varchar(10) NULL,
	@DeathDTS varchar(10) NULL,
	@TIN varchar(50) NULL ,
	@PrimaryCareServicesCNT varchar(10) NULL ,
	@EDWLastModifiedDTS varchar(10) NULL,
	@FileNM varchar(100) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF

	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPAnnualMembershipTINLevel_HALRBASE]
	
	@SrcFileName ,
	-- [CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate ,
	
	@YearNBR ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@FirstNM ,
	@LastNM ,
	@SexCD ,
	@BirthDTS ,
	@DeathDTS ,
	@TIN ,
	@PrimaryCareServicesCNT  ,
	@EDWLastModifiedDTS ,
	@FileNM 
    
END

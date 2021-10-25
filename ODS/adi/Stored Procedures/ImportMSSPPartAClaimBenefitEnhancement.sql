-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPPartAClaimBenefitEnhancement]
    @SrcFileName varchar(100),
	--[CreateDate [datetime] NULL,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100),
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID varchar(50) ,
	@MedicareBeneficiaryID varchar(10) ,
	@HealthInsuranceClaimNBR [varchar](50),
	@ClaimTypeCD [varchar](10) ,
	@ClaimAdmissionDTS varchar(10),
	@PopulationBasedPaymentBenefitEnhancementFLG varchar(10) ,
	@PostDischargeHomeVisitBenefitEnhancementFLG [varchar](10),
	@SNFThreeDayWaiverBenefitEnhancementFLG [varchar](10) ,
	@TelehealthBenefitEnhancementFLG [varchar](10) ,
	@AllInclusivePopulationBasedPaymentBenefitEnhancementFLG [varchar](10),
	@FirstProgramDemonstrationNBR [varchar](50) ,
	@SecondProgramDemonstrationNBR [varchar](50) ,
	@ThirdProgramDemonstrationNBR [varchar](50) ,
	@FourthProgramDemonstrationNBR [varchar](50) ,
	@FifthProgramDemonstrationNBR [varchar](50) ,
	@PopulationBasedPaymentInclusionAMT varchar(10),
	@PopulationBasedPaymentReductionAMT varchar(10) ,
	@PlaceHolderTXT [varchar](500) NULL,
	@FileNM [varchar](50)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPartAClaimBenefitEnhancement]

	@SrcFileName ,
	--[CreateDate [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate ,
	@ClaimID  ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD  ,
	@ClaimAdmissionDTS ,
	@PopulationBasedPaymentBenefitEnhancementFLG ,
	@PostDischargeHomeVisitBenefitEnhancementFLG ,
	@SNFThreeDayWaiverBenefitEnhancementFLG  ,
	@TelehealthBenefitEnhancementFLG,
	@AllInclusivePopulationBasedPaymentBenefitEnhancementFLG ,
	@FirstProgramDemonstrationNBR ,
	@SecondProgramDemonstrationNBR ,
	@ThirdProgramDemonstrationNBR ,
	@FourthProgramDemonstrationNBR ,
	@FifthProgramDemonstrationNBR ,
	@PopulationBasedPaymentInclusionAMT ,
	@PopulationBasedPaymentReductionAMT ,
	@PlaceHolderTXT ,
	@FileNM 
END

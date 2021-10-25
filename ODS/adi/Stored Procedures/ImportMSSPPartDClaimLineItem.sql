-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartDClaimLineItem]
    @SrcFileName [varchar](100) NULL,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate vARCHAR(10),
	@ClaimID [varchar](50) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@NDC [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@PrescriptionFillDT VARCHAR(10),
	@PharmacyIdentifierTypeCD [varchar](10) NULL,
	@#PharmacyIdentifierTypeDSC [varchar](500) NULL,
	@PharmacyID [varchar](50) NULL,
	@DispenseStatusCD [varchar](10) NULL,
	@DispenseStatusDSC [varchar](500) NULL,
	@ProductSubstituteSelectionCD [varchar](10) NULL,
	@ProductSubstituteSelectionDSC [varchar](500) NULL,
	@DispenseUnitCNT VARCHAR(10),
	@DispenseDaysCNT VARCHAR(10),
	@PrescribingProviderIdentifierTypeCD [varchar](10) NULL,
	@PrescribingProviderIdentifierTypeDSC [varchar](500) NULL,
	@PrescribingProviderID [varchar](50) NULL,
	@BeneficiaryPaymentAMT VARCHAR(10),
	@AdjustmentTypeCD [varchar](10) NULL,
	@AdjustmentTypeDSC [varchar](500) NULL,
	@ProcessingDTS VARCHAR(10),
	@RepositoryLoadDTS VARCHAR(10),
	@PrescriptionReferenceNBR [varchar](50) NULL,
	@PrescriptionFillSEQ [varchar](10) NULL,
	@PharmacyServiceTypeCD [varchar](10) NULL,
	@FileNM [varchar](50) NULL
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPartDClaimLineItem]
     @SrcFileName,
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate ,
	@ClaimID ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@NDC ,
	@ClaimTypeCD ,
	@ClaimTypeDSC ,
	@PrescriptionFillDT ,
	@PharmacyIdentifierTypeCD ,
	@#PharmacyIdentifierTypeDSC ,
	@PharmacyID ,
	@DispenseStatusCD ,
	@DispenseStatusDSC ,
	@ProductSubstituteSelectionCD ,
	@ProductSubstituteSelectionDSC ,
	@DispenseUnitCNT ,
	@DispenseDaysCNT ,
	@PrescribingProviderIdentifierTypeCD ,
	@PrescribingProviderIdentifierTypeDSC ,
	@PrescribingProviderID ,
	@BeneficiaryPaymentAMT ,
	@AdjustmentTypeCD ,
	@AdjustmentTypeDSC ,
	@ProcessingDTS ,
	@RepositoryLoadDTS ,
	@PrescriptionReferenceNBR ,
	@PrescriptionFillSEQ ,
	@PharmacyServiceTypeCD ,
	@FileNM       
    
END

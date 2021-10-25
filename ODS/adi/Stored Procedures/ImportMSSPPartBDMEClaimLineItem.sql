-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartBDMEClaimLineItem]
    @SrcFileName [varchar](100) NULL,
--	[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID [varchar](50) NULL,
	@LineNBR [varchar](50) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@ClaimStartDTS varchar(10),
	@ClaimEndDTS varchar(10),
	@ServiceTypeCD [varchar](10) NULL,
	@ServiceTypeDSC [varchar](500) NULL,
	@PlaceOfServiceCD [varchar](10) NULL,
	@PlaceOfServiceNM [varchar](50) NULL,
	@StartDTS varchar(10),
	@EndDTS varchar(10),
	@HCPCS [varchar](50) NULL,
	@PaymentAMT varchar(10),
	@PrimaryPayerCD [varchar](10) NULL,
	@PrimaryPayerDSC [varchar](500) NULL,
	@PaidProviderNPI [varchar](50) NULL,
	@OrderingProviderNPI [varchar](50) NULL,
	@CarrierPaymentDispositionCD [varchar](10) NULL,
	@CarrierPaymentDispositionDSC [varchar](500) NULL,
	@LineProcessingIndicatorCD [varchar](10) NULL,
	@LineProcessingIndicatorDSC [varchar](500) NULL,
	@AdjustmentTypeCD [varchar](10) NULL,
	@AdjustmentTypeDSC [varchar](50) NULL,
	@ProcessingDTS varchar(10),
	@RepositoryLoadDTS varchar(10),
	@ControlNBR [varchar](50) NULL,
	@UmbrellaHealthInsuranceClaimNBR [varchar](50) NULL,
	@AllowedAMT varchar(10),
	@ClaimDispositionCD [varchar](10) NULL,
	@ClaimDispositionDSC [varchar](500) NULL,
	@FileNM [varchar](50) NULL
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPartBDMEClaimLineItem]
    
	@SrcFileName ,
--	[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate ,
	@ClaimID ,
	@LineNBR ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	@ClaimTypeDSC ,
	@ClaimStartDTS ,
	@ClaimEndDTS ,
	@ServiceTypeCD ,
	@ServiceTypeDSC ,
	@PlaceOfServiceCD ,
	@PlaceOfServiceNM ,
	@StartDTS ,
	@EndDTS ,
	@HCPCS ,
	@PaymentAMT ,
	@PrimaryPayerCD ,
	@PrimaryPayerDSC ,
	@PaidProviderNPI ,
	@OrderingProviderNPI ,
	@CarrierPaymentDispositionCD ,
	@CarrierPaymentDispositionDSC ,
	@LineProcessingIndicatorCD ,
	@LineProcessingIndicatorDSC ,
	@AdjustmentTypeCD ,
	@AdjustmentTypeDSC ,
	@ProcessingDTS ,
	@RepositoryLoadDTS ,
	@ControlNBR ,
	@UmbrellaHealthInsuranceClaimNBR ,
	@AllowedAMT ,
	@ClaimDispositionCD ,
	@ClaimDispositionDSC ,
	@FileNM      
    
END

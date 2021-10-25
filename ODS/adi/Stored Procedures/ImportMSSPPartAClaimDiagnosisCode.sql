-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartAClaimDiagnosisCode]
    @SrcFileName [varchar](100) NULL,
	--@CreateDate [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID varchar(50) NULL,
	@ICDDiagnosisSEQ [varchar](10) NULL,
	@ICDDiagnosisCategoryCD [varchar](10) NULL,
	@ICDDiagnosisCategoryDSC [varchar](500) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@ICDDiagnosisCD [varchar](10) NULL,
	@UmbrellaHealthInsuranceClaimNBR [varchar](50) NULL,
	@CMSCertificationNBR [varchar](50) NULL,
	@ClaimStartDTS varchar(10),
	@ClaimEndDTS varchar(10),
	@PresentOnAdmitCD [varchar](10) NULL,
	@PresentOnAdmitDSC [varchar](500) NULL,
	@ICDRevisionCD [varchar](10) NULL,
	@FileNM [varchar](50)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPartAClaimDiagnosisCode]
    @SrcFileName ,
	--@CreateDate [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate ,
	@ClaimID ,
	@ICDDiagnosisSEQ ,
	@ICDDiagnosisCategoryCD ,
	@ICDDiagnosisCategoryDSC ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	@ClaimTypeDSC ,
	@ICDDiagnosisCD ,
	@UmbrellaHealthInsuranceClaimNBR ,
	@CMSCertificationNBR ,
	@ClaimStartDTS ,
	@ClaimEndDTS ,
	@PresentOnAdmitCD ,
	@PresentOnAdmitDSC ,
	@ICDRevisionCD ,
	@FileNM 
            

END

-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportMSSPPartAClaimProcedureCode]
    @SrcFileName [varchar](100) NULL,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) NULL,
	@LastUpdatedBy [varchar](100) NULL,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@ClaimID [varchar](50) NULL,
	@ICDProcedureSEQ [varchar](10) NULL,
	@MedicareBeneficiaryID [varchar](50) NULL,
	@HealthInsuranceClaimNBR [varchar](50) NULL,
	@ClaimTypeCD [varchar](10) NULL,
	@ClaimTypeDSC [varchar](500) NULL,
	@ICDProcedureCD [varchar](10) NULL,
	@ICDProcedureDTS varchar(10),
	@UmbrellaHealthInsuranceClaimNBR [varchar](50) NULL,
	@CMSCertificationNBR [varchar](50) NULL,
	@ClaimStartDTS varchar(10),
	@ClaimEndDTS varchar(10),
	@CDRevisionCD [varchar](10) NULL,
	@FileNM [varchar](50) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPartAClaimProcedureCode]
	@SrcFileName ,
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate ,
	@ClaimID ,
	@ICDProcedureSEQ ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@ClaimTypeCD ,
	@ClaimTypeDSC ,
	@ICDProcedureCD ,
	@ICDProcedureDTS ,
	@UmbrellaHealthInsuranceClaimNBR ,
	@CMSCertificationNBR ,
	@ClaimStartDTS ,
	@ClaimEndDTS ,
	@CDRevisionCD ,
	@FileNM 
    
END

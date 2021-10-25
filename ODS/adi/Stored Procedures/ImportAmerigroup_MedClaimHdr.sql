

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert Cigna MA AWV to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_MedClaimHdr]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
	@MasterConsumerID  bigint  ,
	@ClaimNbr  varchar(24) ,
	@ClaimAdjustmentNum  decimal (4, 0) ,
	@ClaimDispositionCode  varchar(5) ,
	@BillingProviderLicenseNum  varchar(15) ,
	@BillingProviderTaxID  varchar(15) ,
	@MedicareID  varchar(15) ,
	@PaidDate  varchar(10) ,
	@DRG  varchar(15) ,
	@BilledServiceUnitCount  decimal(18, 3) ,
	@PaidServiceUnitCount  decimal(18, 3) ,
	@NumDays  decimal(4, 0) ,
	@BillType  varchar(4) ,
	@InpatientTransplantFlag  varchar(5) ,
	@AdmitType  varchar(3) ,
	@AdmitSource  varchar(3) ,
	@AdmitHour  decimal(2, 0) ,
	@DischargeStatus  varchar(5) ,
	@BillingProviderNPI  varchar(25) ,
	@AttendingProviderNPI  varchar(25) ,
	@AdmittingProviderNPI  varchar(25) ,
	@ServiceRenderingProviderNPI  varchar(25) ,
	@OtherProviderNPI  varchar(25) ,
	@ReferringProviderLicenseNum  varchar(25) ,
	@ProfessionalIndicator  varchar(5) ,
	@InstitutionalIndicator  varchar(5) ,
	@FNL_MS_DRG  varchar(5) ,
	@ICD_CM_procedure1  varchar(15) ,
	@ICD_CM_procedure2  varchar(15) ,
	@ICD_CM_procedure3  varchar(15) ,
	@ICD_CM_procedure4  varchar(15) ,
	@ICD_CM_procedure5  varchar(15) ,
	@FromDate  varchar(10) ,
	@ToDate  varchar(10) ,
	@AdmitDate  varchar(10) ,
	@Billing_provider_id  varchar(15) ,
	@Billing_providercode  varchar(10) ,
	@ServiceproviderId  varchar(15) ,
	@Serviceprovidercode  varchar(25) ,
	@Member_Key  varchar(32) ,
	@InternationalClassificationDiseasesCode  varchar(10) ,
	@REDACT_FLAG  varchar(15) ,
	@DischargeDate  varchar(10) ,
	@DRG_Type_Code  varchar(15) ,
	@PG_ID  varchar(32) ,
	@PG_NAME  varchar(100) ,
	@CLM_ADJSTMNT_KEY  varchar(32) ,
	@Actual_Paid_Date  varchar(10) ,
	@Claim_Processed_Date  varchar(10) 
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_MedClaimHdr]
	 @OriginalFileName   ,
	@SrcFileName   ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate  , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
	@MasterConsumerID   ,
	@ClaimNbr   ,
	@ClaimAdjustmentNum   ,
	@ClaimDispositionCode   ,
	@BillingProviderLicenseNum   ,
	@BillingProviderTaxID   ,
	@MedicareID   ,
	@PaidDate   ,
	@DRG   ,
	@BilledServiceUnitCount  ,
	@PaidServiceUnitCount   ,
	@NumDays   ,
	@BillType   ,
	@InpatientTransplantFlag   ,
	@AdmitType  ,
	@AdmitSource   ,
	@AdmitHour   ,
	@DischargeStatus  ,
	@BillingProviderNPI  ,
	@AttendingProviderNPI  ,
	@AdmittingProviderNPI  ,
	@ServiceRenderingProviderNPI  ,
	@OtherProviderNPI  ,
	@ReferringProviderLicenseNum  ,
	@ProfessionalIndicator  ,
	@InstitutionalIndicator  ,
	@FNL_MS_DRG  ,
	@ICD_CM_procedure1  ,
	@ICD_CM_procedure2  ,
	@ICD_CM_procedure3  ,
	@ICD_CM_procedure4  ,
	@ICD_CM_procedure5  ,
	@FromDate   ,
	@ToDate   ,
	@AdmitDate   ,
	@Billing_provider_id  ,
	@Billing_providercode   ,
	@ServiceproviderId  ,
	@Serviceprovidercode   ,
	@Member_Key   ,
	@InternationalClassificationDiseasesCode   ,
	@REDACT_FLAG  ,
	@DischargeDate   ,
	@DRG_Type_Code  ,
	@PG_ID   ,
	@PG_NAME   ,
	@CLM_ADJSTMNT_KEY   ,
	@Actual_Paid_Date   ,
	@Claim_Processed_Date  
   

END





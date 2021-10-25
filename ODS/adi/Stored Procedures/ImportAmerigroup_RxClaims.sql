

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_RxClaims]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
	
	@Master_Consumer_ID  bigint  ,
	@FilledDate  varchar(10)  ,
	@NDCNumber  varchar(11) ,
	@DEANumber  varchar(25) ,
	@PharmacyNumber  varchar(16) ,
	@PharmacyName  varchar(60) ,
	@TherapeuticClass  varchar(8) ,
	@GenericIndicator  varchar(7) ,
	@DaysSupplied  decimal (5, 0) ,
	@FormularyIndicator  varchar(5) ,
	@RetailMailIndicator  varchar(10) ,
	@BilledCharges  decimal (18, 2) ,
	@Year  varchar(4) ,
	@Quarter  varchar(6) ,
	@Month  varchar(6) ,
	@ProviderLicenseNumber  varchar(25) ,
	@ScriptWrittenDate  varchar(10)  ,
	@PrescriberName  varchar(80) ,
	@QuantityDispensed  decimal (18, 3) ,
	@RXNumber  varchar(20) ,
	@IngredientCost  decimal (18, 2) ,
	@Copay  decimal (18, 2) ,
	@LabelName  varchar(100) ,
	@PrescriberNPI  varchar(25) ,
	@ClaimNbr  varchar(24) ,
	@ClaimAdjustmentNumber  decimal (4, 0) ,
	@ClaimDispositionCode  varchar(5) ,
	@MemberKey  varchar(32) ,
	@Patient_Responsibility_Amount  decimal (18, 2) ,
	@Paid_Amount  decimal (18, 2) ,
	@Allowed_Amount  decimal (18, 2) ,
	@REDACT_FLAG  varchar(1) ,
	@PG_ID  varchar(32) ,
	@PG_NAME  varchar(100) ,
	@CLM_ADJSTMNT_KEY  varchar(32) ,
	@GL_POST_DT varchar(10)  ,
	@Line_Number  varchar(6) ,
	@DRG_NM  varchar(60) ,
	@StatusCode  varchar(5) ,
	@RefillNumber  decimal (4, 0) ,
	@Refill  decimal (4, 0) ,
	@Claim_Processed_Date  varchar(10)  ,
	@Denial_Reason_Code  varchar(15) ,
	@Denial_Reason_Description  varchar(150) ,
	@Compound_Drug  varchar(4) ,
	@Dispensing_Fee  decimal (18, 2) ,
	@BillingProviderNPI  varchar(25) 
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_RxClaims]
	 @OriginalFileName   ,
	@SrcFileName   ,
	@LoadDate ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate , 
	@CreatedBy   ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
	
	@Master_Consumer_ID  ,
	@FilledDate   ,
	@NDCNumber  ,
	@DEANumber  ,
	@PharmacyNumber   ,
	@PharmacyName  ,
	@TherapeuticClass   ,
	@GenericIndicator  ,
	@DaysSupplied   ,
	@FormularyIndicator   ,
	@RetailMailIndicator   ,
	@BilledCharges   ,
	@Year   ,
	@Quarter   ,
	@Month   ,
	@ProviderLicenseNumber  ,
	@ScriptWrittenDate    ,
	@PrescriberName   ,
	@QuantityDispensed   ,
	@RXNumber   ,
	@IngredientCost  ,
	@Copay   ,
	@LabelName   ,
	@PrescriberNPI  ,
	@ClaimNbr   ,
	@ClaimAdjustmentNumber ,
	@ClaimDispositionCode   ,
	@MemberKey   ,
	@Patient_Responsibility_Amount   ,
	@Paid_Amount  ,
	@Allowed_Amount   ,
	@REDACT_FLAG   ,
	@PG_ID   ,
	@PG_NAME   ,
	@CLM_ADJSTMNT_KEY   ,
	@GL_POST_DT  ,
	@Line_Number   ,
	@DRG_NM  ,
	@StatusCode   ,
	@RefillNumber  ,
	@Refill   ,
	@Claim_Processed_Date    ,
	@Denial_Reason_Code   ,
	@Denial_Reason_Description  ,
	@Compound_Drug   ,
	@Dispensing_Fee  ,
	@BillingProviderNPI  

END








-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert Cigna MA AWV to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_MedClaimDetl]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
	@MasterConsumerID bigint  ,
	@ClaimNbr  varchar(24) ,
	@ClaimAdjustmentNum  decimal(4, 0) ,
	@ClaimDispositionCode  varchar(5) ,
	@LineNumber  varchar(6) ,
	@FromDate  varchar(10)  ,
	@EndDate  varchar(10)  ,
	@StatusCode  varchar(5) ,
	@ReasonCode  varchar(100) ,
	@Year  varchar(4) ,
	@Quarter  varchar(6) ,
	@Month  varchar(6) ,
	@HealthServiceCode  varchar(8) ,
	@RevenueCode  varchar(8) ,
	@HealthServiceCodeModifier  varchar(5) ,
	@NumberServiceUnits  decimal(18, 3) ,
	@LineBilled  decimal(18, 2) ,
	@LineCovered  decimal(18, 2) ,
	@PlaceService  varchar(5) ,
	@ContractFlag1  varchar(3) ,
	@DIAG_1_CD  varchar(10) ,
	@DIAG_2_CD  varchar(10) ,
	@DIAG_3_CD  varchar(10) ,
	@DIAG_4_CD  varchar(10) ,
	@DIAG_5_CD  varchar(10) ,
	@InpatientFlag  varchar(3) ,
	@PotentiallyAvoidableERflag  varchar(3) ,
	@Imagingflag  varchar(3) ,
	@AdmitthruERFlag  varchar(3) ,
	@MemberKey varchar(32) ,
	@ICDVersionCode  varchar(10) ,
	@Claim_SOR_CD  varchar(10) ,
	@Billedserviceunitcount  decimal(18, 3) ,
	@Paidserviceunitcount  decimal(18, 3) ,
	@PatientResponsibilityAmount  decimal(18, 2) ,
	@LineAllowed  decimal(18, 2) ,
	@LinePaid  decimal(18, 2) ,
	@REDACT_FLAG  varchar(1) ,
	@HLTH_SRVC_TYPE_CD  varchar(5) ,
	@PG_ID varchar(32) ,
	@PG_NAME  varchar(100) ,
	@CLM_ADJSTMNT_KEY  varchar (32) ,
	@IN_OUTNetworkclaims  varchar(3) ,
	@Denial_Reason_Code  varchar(32),
	@Denial_Reason_Description  varchar(1000) 
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_MedClaimDetl]
	@OriginalFileName   ,
	@SrcFileName   ,
	@LoadDate ,
	--@CreatedDate  
	@DataDate ,  
	@FileDate , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy   ,
	@MasterConsumerID   ,
	@ClaimNbr   ,
	@ClaimAdjustmentNum  ,
	@ClaimDispositionCode   ,
	@LineNumber  ,
	@FromDate   ,
	@EndDate   ,
	@StatusCode   ,
	@ReasonCode  ,
	@Year  ,
	@Quarter   ,
	@Month   ,
	@HealthServiceCode   ,
	@RevenueCode   ,
	@HealthServiceCodeModifier   ,
	@NumberServiceUnits   ,
	@LineBilled   ,
	@LineCovered   ,
	@PlaceService   ,
	@ContractFlag1   ,
	@DIAG_1_CD  ,
	@DIAG_2_CD  ,
	@DIAG_3_CD  ,
	@DIAG_4_CD  ,
	@DIAG_5_CD  ,
	@InpatientFlag   ,
	@PotentiallyAvoidableERflag  ,
	@Imagingflag   ,
	@AdmitthruERFlag   ,
	@MemberKey   ,
	@ICDVersionCode  ,
	@Claim_SOR_CD  ,
	@Billedserviceunitcount   ,
	@Paidserviceunitcount   ,
	@PatientResponsibilityAmount   ,
	@LineAllowed   ,
	@LinePaid   ,
	@REDACT_FLAG  ,
	@HLTH_SRVC_TYPE_CD   ,
	@PG_ID   ,
	@PG_NAME  ,
	@CLM_ADJSTMNT_KEY  ,
	@IN_OUTNetworkclaims  ,
	@Denial_Reason_Code   ,
	@Denial_Reason_Description  
	


END





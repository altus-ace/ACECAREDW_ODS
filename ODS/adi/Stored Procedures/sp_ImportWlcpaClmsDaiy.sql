
-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert Wellcare IPACLM Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[sp_ImportWlcpaClmsDaiy]
    @LastName varchar(65) NULL,
	@FirstName varchar(65) NULL,
	@DOB varchar(12) NULL,
	@SubscriberID varchar(50),
	@ProviderID varchar(25) NULL,
	@ProviderLastName varchar(65) NULL,
	@ProviderFirstName varchar(65) NULL,
	@ProviderAddress varchar(100) NULL,
	@CityStateZip varchar(100) NULL,
	@PcName [varchar](100) NULL,
	@DetailSVCDate VARCHAR(12) NULL,
	@SVCDate varchar(12) NULL,
	@AuthNumber varchar(30) NULL,
	@Procedure varchar(15) NULL,
	@Description varchar(250) NULL,
	@Modifier varchar(15) NULL,
	@Quantity varchar(10) NULL,
	@Diagnosis_1 varchar(15) NULL,
	@Diagnosis_2 varchar(15) NULL,
	@Diagnosis_3 varchar(15) NULL,
	@Diagnosis_4 varchar(15) NULL,
	@Diagnosis_5 varchar(15) NULL,
	@Diagnosis_6 varchar(15) NULL,
	@ProfNet varchar(10) NULL,
	@Billed varchar(10) NULL,
	@Allowed varchar(10) NULL,
	@Copay varchar NULL,
	@DRG varchar(15) NULL,
	@Claim varchar(25) NULL,
	@Line varchar(10) NULL,
	@LCode varchar(15) NULL,
	@POS varchar(15) NULL,
	@Date varchar(10) NULL,
	@ProfInst varchar(15) NULL,
	@Carrier varchar(10)  NULL,
	@Reason varchar(50) NULL,
	@AltPCode varchar(15) NULL,
	@IPA varchar(15) NULL,
	@TotalBilledAmt varchar(10) NULL,
	@DetailHold varchar(15) NULL,
	@HeaderHold varchar(15) NULL,
--	@LoadDate varchar(10) ,
	@DataDate varchar(10),
	@srcFileName varchar(100),
	--[CreatedDate] [datetime] NULL,
	@CreatedBy varchar(50) NULL
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ADD ACE ETL AUDIT
--	DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
--	SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
 --   EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 7,'ECAP Import Call Center Work List', @ActionStartDateTime, @SrcFileName, '[ACDW_CLMS_WLC_ECAP].[adi].[copAceWorkList]', '';
	--EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
	 
--	IF @@ROWCOUNT = 0

   

EXEC [ACDW_CLMS_WLC].[adi].[sp_ImportWlcpaClmsDaiy]   
    @LastName,
	@FirstName ,
	@DOB ,
	@SubscriberID ,
	@ProviderID ,
	@ProviderLastName ,
	@ProviderFirstName ,
	@ProviderAddress ,
	@CityStateZip ,
	@PcName ,
	@DetailSVCDate ,
	@SVCDate ,
	@AuthNumber ,
	@Procedure ,
	@Description ,
	@Modifier ,
	@Quantity ,
	@Diagnosis_1 ,
	@Diagnosis_2 ,
	@Diagnosis_3 ,
	@Diagnosis_4 ,
	@Diagnosis_5 ,
	@Diagnosis_6 ,
	@ProfNet ,
	@Billed ,
	@Allowed ,
	@Copay ,
	@DRG ,
	@Claim ,
	@Line ,
	@LCode ,
	@POS ,
	@Date ,
	@ProfInst ,
	@Carrier ,
	@Reason ,
	@AltPCode ,
	@IPA ,
	@TotalBilledAmt ,
	@DetailHold ,
	@HeaderHold ,
--	@LoadDate varchar(10) ,
	@DataDate ,
	@srcFileName ,
	--[CreatedDate] [datetime] NULL,
	@CreatedBy 

  --BEGIN
 --  SET @ActionStopDateTime = GETDATE()
 --  EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   	
 -- END TRY



  --BEGIN CATCH 

  -- SET @ActionStopDateTime = GETDATE()
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,3   	

  --END CATCH 
    
END



-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPUpdatedPhoneNumber]
    @SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] ,
	@CreateBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](100),
	@DataDate varchar(10) ,
	@MedicareBeneficiaryID [varchar](50),
	@FirstName [varchar](50) ,
	@LastName [varchar](50) ,
	@BirthDTS varchar(50),
	@PhoneNBR VARCHAR(12) 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	DECLARE @PInsuranceClaimNumberStartDTS varchar(10), @PInsuranceClaimNumberEndDTS varchar(10)
	--SET @PInsuranceClaimNumberStartDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberStartDTS, 1, 10)
	--SET @PInsuranceClaimNumberEndDTS = SUBSTRING(@PreviousHealthInsuranceClaimNumberEndDTS, 1,10)
	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPUpdatedPhoneNumber]
	 @SrcFileName  ,
	--[CreateDate] [datetime] ,
	@CreateBy  ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@DataDate ,
	@MedicareBeneficiaryID ,
	@FirstName  ,
	@LastName  ,
	@BirthDTS ,
	@PhoneNBR  

END



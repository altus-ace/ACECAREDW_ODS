-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPBeneficiaryCrossReference]
   @SrcFileName varchar(100),
	--[CreateDate] [datetime] NULL,
	@CreateBy varchar(100),
	@OriginalFileName varchar(100),
	@LastUpdatedBy varchar(100),
	@DataDate varchar(12),
	@IdentifierTypeCD varchar(10),
	@CurrentHealthInsuranceClaimNBR varchar(50) ,
	@PreviousHealthInsuranceClaimNBR varchar(50),
	@PreviousHealthInsuranceClaimNumberStartDTS varchar(12),
	@PreviousHealthInsuranceClaimNumberEndDTS varchar(12),
	@RailroadBoardNBR varchar(50),
	@FileNM varchar(50)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPBeneficiaryCrossReference]
	@SrcFileName ,
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	@DataDate ,
	@IdentifierTypeCD ,
	@CurrentHealthInsuranceClaimNBR  ,
	@PreviousHealthInsuranceClaimNBR ,
	@PreviousHealthInsuranceClaimNumberStartDTS ,
	@PreviousHealthInsuranceClaimNumberEndDTS ,
	@RailroadBoardNBR ,
	@FileNM 

END

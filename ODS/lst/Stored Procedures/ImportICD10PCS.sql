-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportICD10PCS](
   --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy varchar(50) ,
	--[LastUpdated] [datetime] NOT NU,
	@LastUpdatedBy varchar(50),
	@SrcFileName varchar(50) ,
    @ICD10PCS_Code varchar(20),
	@ICD10PCS_Desc varchar(1000),
	@ICD10PCS_CodeCategory varchar(20),
	@ACTIVE char(1),
	@EffectiveDate varchar(12),
	@ExpirationDate varchar(12) 	
)	

	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	

	EXEC [AceMasterData].[lst].[ImportICD10PCS]
       --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	--[LastUpdated] [datetime] NOT NU,
	@LastUpdatedBy ,
	@SrcFileName ,
    @ICD10PCS_Code ,
	@ICD10PCS_Desc ,
	@ICD10PCS_CodeCategory ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate  	
END



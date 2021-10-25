-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportlstCareOpToPlan](
    	
	@CreatedBy varchar(50),
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy varchar(50),
	@SrcFileName varchar(50) ,
	@ClientKey varchar(10),
	@CsPlan varchar(50),
	@MeasureID varchar(20) ,
	@MeasureDesc varchar(400) ,
	@SubMeasure varchar(100) ,
	@ACTIVE char(1) ,
	@EffectiveDate varchar(12),
	@ExpirationDate varchar(12)

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	EXEC [AceMasterData].[lst].[ImportlstCareOpToPlan]
	@CreatedBy ,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName ,
	@ClientKey ,
	@CsPlan ,
	@MeasureID,
	@MeasureDesc ,
	@SubMeasure ,
	@ACTIVE,
	@EffectiveDate ,
	@ExpirationDate 
	END

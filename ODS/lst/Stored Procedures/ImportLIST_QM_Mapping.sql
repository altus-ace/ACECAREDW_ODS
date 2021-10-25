-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportLIST_QM_Mapping]
(
  	@CreatedBy varchar(50),
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy varchar(50),
	@SrcFileName varchar(50) ,
	@QM varchar(20) ,
	@QM_DESC varchar(500),
	@AHR_QM_DESC varchar(500),
	@ACTIVE char(1) ,
	@EffectiveDate varchar(12),
	@ExpirationDate varchar(12),
	@ClientKey int
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    

	EXEC [AceMasterData].[lst].[ImportLIST_QM_Mapping]
	@CreatedBy,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName  ,
	@QM  ,
	@QM_DESC ,
	@AHR_QM_DESC ,
	@ACTIVE  ,
	@EffectiveDate ,
	@ExpirationDate ,
	@ClientKey 
	
END



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportListAceMapping](
    @ClientKey [int] ,
	@MappingTypeKey [int] ,
	@IsActive [tinyint] ,
	@Source [varchar](150) ,
	@Destination [varchar](150) ,
	--[CreatedDate [datetime2](7) ,
	@reatedBy [varchar](50) ,
	--[LastUpdatedDate] [datetime2](7) ,
	@LastUpdatedBy [varchar](50) ,
	@srcFileName [varchar](150) ,
	@EffectiveDate varchar(10) ,
	@ExpirationDate varchar(10) 

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC  [AceMasterData].[lst].[ImportListAceMapping]  
      @ClientKey  ,
	@MappingTypeKey,
	@IsActive  ,
	@Source  ,
	@Destination  ,
	--[CreatedDate [datetime2](7) ,
	@reatedBy  ,
	--[LastUpdatedDate] [datetime2](7) ,
	@LastUpdatedBy  ,
	@srcFileName  ,
	@EffectiveDate  ,
	@ExpirationDate 	 

   END



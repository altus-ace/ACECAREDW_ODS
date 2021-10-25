-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportLIST_ICDcwHCC](
    --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	-- [LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@SrcFileName [varchar](50),
	@ICDCode [varchar](20),
	@Description [varchar](150),
	@HCC [varchar](10),
	@VER [varchar](10) ,
	@ACTIVE [char](1),
	@EffectiveDate [date] ,
	@ExpirationDate [date] 
	
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
   EXEC [AceMasterData].[lst].[ImportLIST_ICDcwHCC]
       --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	-- [LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName ,
	@ICDCode ,
	@Description ,
	@HCC ,
	@VER ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate 
	
 END



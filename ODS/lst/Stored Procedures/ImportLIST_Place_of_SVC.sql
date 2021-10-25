-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportLIST_Place_of_SVC](
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	-- [LastUpdated] [datetime] ,
	@LastUpdatedBy [varchar](50) ,
	@SrcFileName [varchar](50) ,
	--[DataDate] [date] NOT NULL,
	@Place_of_Service_Code [varchar](10) ,
	@Place_of_Service_Name [varchar](100),
	@Place_of_Service_Description [varchar](1000),
	@Version [varchar](50) ,
	@ACTIVE [char](1) ,
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10)


	
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  
    EXEC [AceMasterData].[lst].[ImportLIST_Place_of_SVC]
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy  ,
	-- [LastUpdated] [datetime] ,
	@LastUpdatedBy  ,
	@SrcFileName ,
	--[DataDate] [date] NOT NULL,
	@Place_of_Service_Code  ,
	@Place_of_Service_Name ,
	@Place_of_Service_Description ,
	@Version  ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate    
	
END



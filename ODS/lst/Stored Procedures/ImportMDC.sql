-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportMDC](
    --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50),
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@SrcFileName [varchar](50),
	@Mdc_Code [varchar](20),
	@Mdc_Desc [varchar](1000) ,
	@MS_DRG [varchar](20) ,
	@Type [varchar](20) ,
	@Active [char](1),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	  
	EXEC [AceMasterData].[lst].[ImportMDC]
	@CreatedBy ,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName ,
	@Mdc_Code ,
	@Mdc_Desc ,
	@MS_DRG ,
	@Type  ,
	@Active ,
	@EffectiveDate ,
	@ExpirationDate 

END


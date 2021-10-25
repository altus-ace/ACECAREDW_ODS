-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportScoringSystem](
   	@SrcFileName [varchar](50),
	@ClientKey [int] ,
	@LOB [varchar](20) ,
	@LOB_State [varchar](10),
	@EffectiveDate varCHAR(10) ,
	@ExpirationDate VARCHAR(10),
	@Active [tinyint] ,
	@ScoringType [varchar](10),
	@P4qIndicator [char](1) ,
	@MeasureID varchar(20) ,
	@MeasureDesc varchar(80),
	@Score_A varchar(15),
	@Score_B varchar(15),
	@Score_C varchar(15),
	@Score_D varchar(15),
	@Score_E varchar(15),
	@Weight_1 varchar(15),
	@Weight_2 varchar(15),
	@Weight_3 varchar(15),
	@Weight_4 varchar(15),
	@Weight_5 varchar(15),
	@AceQmWeight varchar(15),
	@AceCmWeight varchar(15),
	@Pq4BaseValue varchar(10),
	--@CreatedDate [datetime2](7) NOT NULL,
	@CreatedBy varchar(50),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy varchar(50) 

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
    EXEC [AceMasterData].[lst].[ImportScoringSystem]
	@SrcFileName ,
	@ClientKey ,
	@LOB  ,
	@LOB_State ,
	@EffectiveDate  ,
	@ExpirationDate ,
	@Active  ,
	@ScoringType ,
	@P4qIndicator ,
	@MeasureID  ,
	@MeasureDesc ,
	@Score_A ,
	@Score_B ,
	@Score_C ,
	@Score_D ,
	@Score_E ,
	@Weight_1 ,
	@Weight_2  ,
	@Weight_3  ,
	@Weight_4  ,
	@Weight_5  ,
	@AceQmWeight ,
	@AceCmWeight  ,
	@Pq4BaseValue ,
	--@CreatedDate [datetime2](7) NOT NULL,
	@CreatedBy,
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy  
END


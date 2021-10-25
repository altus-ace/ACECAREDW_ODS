-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportICD10PCS-CCSCategory]( 
    --[CreatedDate] [datetime] NULL,
	@CreatedBy [varchar](20) ,
	--@LastUpdatedDate [datetime] NULL,
	@LastUpdatedBy [varchar](20) ,
	--@LoadDate [date] NULL,
	@ICD10PCSCode [varchar](50) ,
	@CCSCategory [char](5) ,
	@ICD10PCSCodeDescription [varchar](150) ,
	@CCSCategoryDescription [varchar](150) ,
	@MultiCCSLvl1 [char](5) ,
	@MultiCCSLvl1Label [varchar](150) ,
	@MultiCCSLvl2 varchar(5) ,
	@MultiCCSLvl2Label [varchar](150) ,
	@ACTIVE [char](1),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    exec [AceMasterData].[lst].[ImportICD10PCS-CCSCategory]
	 --[CreatedDate] [datetime] NULL,
	@CreatedBy ,
	--@LastUpdatedDate [datetime] NULL,
	@LastUpdatedBy ,
	--@LoadDate [date] NULL,
	@ICD10PCSCode ,
	@CCSCategory ,
	@ICD10PCSCodeDescription  ,
	@CCSCategoryDescription  ,
	@MultiCCSLvl1  ,
	@MultiCCSLvl1Label  ,
	@MultiCCSLvl2 ,
	@MultiCCSLvl2Label ,
	@ACTIVE ,
	@EffectiveDate,
	@ExpirationDate 
	 
END



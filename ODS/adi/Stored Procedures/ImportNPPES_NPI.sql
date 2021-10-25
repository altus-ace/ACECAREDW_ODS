-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportNPPES_NPI](
    @srcFileName [varchar](100),
	@DataDate varchar(10),
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	--@LastUpdatedDate [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@NPI varchar(20) ,
	@EntityType [varchar](20) ,
	@EIN [varchar](50) ,
	@LBN [varchar](100) ,
	@LBN_Name [varchar](200),
	@LastName [varchar](100) ,
	@FirstName [varchar](100) ,
	@PracticeAddress1 [varchar](100) ,
	@PracticeAddress2 [varchar](50) ,
	@PracticeCity [varchar](100) ,
	@PracticeState [varchar](50) ,
	@PracticeZip [varchar](10) ,
	@PracticePhone [varchar](20) ,
	@PracticeFax [varchar](20) ,
	@PracticeLastUpdate [varchar](20) ,
	@Taxonomy1 [varchar](50) ,
	@Taxonomy2 [varchar](50) ,
	@Taxonomy3 [varchar](50) 

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [AceMasterData].[adi].[ImportNPPES_NPI]
	@srcFileName ,
	@DataDate ,
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	--@LastUpdatedDate [datetime] NOT NULL,
	@LastUpdatedBy ,
	@NPI  ,
	@EntityType  ,
	@EIN  ,
	@LBN  ,
	@LBN_Name ,
	@LastName  ,
	@FirstName  ,
	@PracticeAddress1  ,
	@PracticeAddress2  ,
	@PracticeCity  ,
	@PracticeState ,
	@PracticeZip  ,
	@PracticePhone  ,
	@PracticeFax ,
	@PracticeLastUpdate ,
	@Taxonomy1  ,
	@Taxonomy2  ,
	@Taxonomy3 
   END



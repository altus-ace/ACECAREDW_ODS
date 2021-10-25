-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportLIST_Disch_Disposition](
    --@CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	--[LastUpdated] [datetime] ,
	@LastUpdatedBy [varchar](50) ,
	@SrcFileName [varchar](50) ,
	@DataDate varchar(10),
	@Disch_Disp_Code [varchar](10) ,
   --	[Disch_Disp_CodeValue] [varchar](100),
	@Disch_Disp_Description [varchar](1000),
	@Disch_Disp_CodePadded varchar(10),
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
	EXEC [AceMasterData].[lst].[ImportLIST_Disch_Disposition]
	   --@CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	--[LastUpdated] [datetime] ,
	@LastUpdatedBy  ,
	@SrcFileName  ,
	@DataDate ,
	@Disch_Disp_Code ,
   --	[Disch_Disp_CodeValue] [varchar](100),
	@Disch_Disp_Description ,
	@Disch_Disp_CodePadded ,
	@Version  ,
	@ACTIVE  ,
	@EffectiveDate ,
	@ExpirationDate 
   
END



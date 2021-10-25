-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportICD10CM](

--	[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50),
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy varchar(50),
	@SrcFileName varchar(50),
	@ACTIVE char(1),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@VALUE_CODE varchar(50),
	@VALUE_CODE_NAME varchar(2000)
)	

	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
    EXEC [AceMasterData].[lst].[ImportICD10CM]
--	[CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate ,
	@VALUE_CODE ,
	@VALUE_CODE_NAME 	

 
END



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportLstHEDIS_2020_ValueSet]
(
     @SrcFileName varchar(100),
	@ValueSetName [varchar](200) ,
	@ValueSetOID [varchar](200),
	@ValueSetVersion [varchar](200),
	@Code [varchar](200),
	@Definition [varchar](200),
	@CodeSystem [varchar](200) ,
	@CodeSystemOID [varchar](200),
	@CodeSystemVersion [varchar](200) 
	
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  
  EXEC  [AceMasterData].[lst].[ImportLstHEDIS_2020_ValueSet]
		@SrcFileName ,
	@ValueSetName ,
	@ValueSetOID ,
	@ValueSetVersion ,
	@Code ,
	@Definition ,
	@CodeSystem  ,
	@CodeSystemOID ,
	@CodeSystemVersion  

	
	
END



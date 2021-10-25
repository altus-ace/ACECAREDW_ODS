-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportLstCCSR](
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50),
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@SrcFileName [varchar](50) ,
    @ACTIVE [char](1),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@ICD10CMCODE varchar(50) ,
	@ICD10CMCODEDESCRIPTION varchar(1000) ,
	@DefaultCCSRCATEGORY varchar(20),
	@DefaultCCSRCATEGORYDESCRIPTION varchar(1000) ,
	@CCSRCATEGORY1 varchar(50),
	@CCSRCATEGORY1DESCRIPTION varchar(1000),
	@CCSRCATEGORY2 varchar(50),
	@CCSRCATEGORY2DESCRIPTION [varchar](1000),
	@CCSRCATEGORY3 varchar(50),
	@CCSRCATEGORY3DESCRIPTION [varchar](1000),
	@CCSRCATEGORY4 varchar(50) ,
	@CCSRCATEGORY4DESCRIPTION varchar(1000),
	@CCSRCATEGORY5 varchar(50),
	@CCSRCATEGORY5DESCRIPTION varchar(1000) 

	
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
EXEC   [AceMasterData].[lst].[ImportLstCCSR]
    @CreatedBy,
	--[LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@SrcFileName  ,
    @ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate ,
	@ICD10CMCODE  ,
	@ICD10CMCODEDESCRIPTION ,
	@DefaultCCSRCATEGORY ,
	@DefaultCCSRCATEGORYDESCRIPTION  ,
	@CCSRCATEGORY1 ,
	@CCSRCATEGORY1DESCRIPTION ,
	@CCSRCATEGORY2 ,
	@CCSRCATEGORY2DESCRIPTION ,
	@CCSRCATEGORY3 ,
	@CCSRCATEGORY3DESCRIPTION ,
	@CCSRCATEGORY4  ,
	@CCSRCATEGORY4DESCRIPTION ,
	@CCSRCATEGORY5 ,
	@CCSRCATEGORY5DESCRIPTION  

END



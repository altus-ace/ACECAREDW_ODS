-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportDRG](
    --[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	--[LastUpdated] [datetime] NOT NULL,
	--@LastUpdatedBy [varchar](50) ,
	--@SrcFileName [varchar](50) ,
  --  [CreatedDate] [datetime] NOT NULL,
	--LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@SrcFileName [varchar](50),
	@DRG_CODE [varchar](20) ,
	@DRG_DESC [varchar](5000) ,
	@DRG_MDC_MajorDiagnosticCategory [varchar](150) ,
	@MDC_DESC [varchar](300),
	@MedMorSurgP [varchar](20) ,
	@DRG_VER [int] ,
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
    
    -- Insert statements for procedure here
--IF(LEN(@VALUE_SET_NAME) > 0)
EXEC [AceMasterData].[lst].[ImportDRG]
   @CreatedBy ,
	--[LastUpdated] [datetime] NOT NULL,
	--@LastUpdatedBy [varchar](50) ,
	--@SrcFileName [varchar](50) ,
  --  [CreatedDate] [datetime] NOT NULL,
	--LastUpdated] [datetime] NOT NULL,
	@LastUpdatedBy  ,
	@SrcFileName ,
	@DRG_CODE  ,
	@DRG_DESC  ,
	@DRG_MDC_MajorDiagnosticCategory ,
	@MDC_DESC ,
	@MedMorSurgP ,
	@DRG_VER  ,
	@ACTIVE ,
	@EffectiveDate ,
	@ExpirationDate 
END


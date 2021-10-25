-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBS_FileSummary]
    @SrcFileName [varchar](100),
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@FieldType varchar(100),
    @RecordCount varchar(10),
    @FileName varchar(100),
    @ClaimCount varchar(10)	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	EXEC [ACDW_CLMS_SHCN_BCBS].[adi].[ImportBCBS_FileSummary]
	@SrcFileName ,
	-- [CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate ,
	@FieldType ,
    @RecordCount ,
    @FileName ,
    @ClaimCount 	
    
END

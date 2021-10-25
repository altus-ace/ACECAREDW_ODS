-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportNtfWlcTxCensus](
   	@OriginalFileName varchar(100),
	@SourceFileName varchar(100),
	@LoadDate varchar(10),
	--@CreatedDate [datetime] NOT NULL,
	@CreatedBy varchar(50),
	@ATH varchar(20),
	@LAST_NAME varchar(65),
	@FIRST_NAME varchar(65),
	@DOB varchar(10),
	@SUBSCRIBER_ID varchar(50),
	@CMCD varchar(50),
	@LOB char(5),
	@FACILITY varchar(100),
	@ATTENDING varchar(150),
	@AD_DATE varchar(10),
	@DIS_DATE varchar(10),
	@DIAGNOSIS varchar(200),
	@AUTH_DAYS varchar(2),
	@AUTH_NO varchar(20),
	@PCP varchar(200),
	@DENIAL_DAYS varchar(2),
	@OV char(5),
	@IPA varchar(20),
	@SERVICE_DETAILS_NOTES varchar(200),  
	@DIAG_CODE varchar(50),
	@DIAG_TEXT varchar(500)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
 --   DECLARE @RecordExist INT
	--SET @RecordExist = (Select COUNT(*)
	--FROM adi.NtfWlcTxCensus 
	--WHERE SourceFileName = @SourceFileName)
	 
	--IF @RecordExist =0

 BEGIN     
 IF (@ATH != '---')
    -- Insert statements for procedure here
 INSERT INTO adi.NtfWlcTxCensus
   (
   	[OriginalFileName],
	[SourceFileName] ,
	[LoadDate] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[ATH],
	[LAST_NAME] ,
	[FIRST_NAME] ,
	[DOB] ,
	[SUBSCRIBER_ID] ,
	[CMCD] ,
	[LOB],
	[FACILITY] ,
	[ATTENDING] ,
	[AD_DATE] ,
	[DIS_DATE] ,
	[DIAGNOSIS] ,
	[AUTH_DAYS] ,
	[AUTH_NO] ,
	[PCP] ,
	[DENIAL_DAYS],
	[OV] ,
	[IPA] ,
	[SERVICE_DETAILS_NOTES],
	[DIAG_CODE],
	[DIAG_TEXT]
   )
     VALUES
   ( 
    @OriginalFileName ,
	@SourceFileName,
	GETDATE(),
	GETDATE(),
	--@CreatedDate [datetime] NOT NULL,
	@CreatedBy,
	@ATH ,
	@LAST_NAME,
	@FIRST_NAME,
	CASE 
	   WHEN @DOB = ''
	   THEN NULL
	   ELSE CONVERT(DATE, @DOB)  
	   END,
	@SUBSCRIBER_ID,
	@CMCD ,
	@LOB ,
    REPLACE(@FACILITY, 	 '"', ''),
	REPLACE(@ATTENDING , '"', ''),
	CASE 
		WHEN @AD_DATE = ''
		THEN NULL
		ELSE CONVERT(DATE, @AD_DATE) 
		END,
	CASE 
	  WHEN  @DIS_DATE = ''
	  THEN NULL 
	  ELSE CONVERT(DATE, @DIS_DATE)
	END ,
	REPLACE(@DIAGNOSIS, '"',''),
	CONVERT(int, @AUTH_DAYS),
	@AUTH_NO,
	REPLACE(@PCP,'"','' ),
	CONVERT(int, @DENIAL_DAYS),
	@OV ,
	@IPA ,
	REPLACE(@SERVICE_DETAILS_NOTES, '"',''),   
	@DIAG_CODE ,
	@DIAG_TEXT
   );
END
END
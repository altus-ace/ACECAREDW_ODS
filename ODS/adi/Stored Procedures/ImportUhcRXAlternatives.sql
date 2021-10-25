-- =============================================
-- Author:		Bing Yu
-- Create date: 11/21/2019
-- Description:	Insert UHC RX Alternative file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportUhcRXAlternatives]
    @DataDate varchar(10),
	@SrcFileName varchar(100),
	--[CreatedDate datetime2(7),
	@CreatedBy varchar(50),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy varchar(50),
	@BrandName VARCHAR(50) ,
	@AlternativesProducts VARCHAR(500) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
	 
--	IF @@ROWCOUNT = 0
	IF @BrandName != '' OR @AlternativesProducts != '' 
	BEGIN
    -- Insert statements 
	INSERT INTO adi.RXAlternatives
	(
	[loadDate] ,
	[DataDate] ,
	[SrcFileName] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy], 
	[BrandName] ,
	[AlternativesProducts] 
   
    )
		
 VALUES   (
    
	GETDATE(),
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@DataDate)
	END,
	@SrcFileName ,
	GETDATE(),
	--[CreatedDate datetime2(7),
	@CreatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy,
	@BrandName ,
	@AlternativesProducts 
  ) 
    END
END
-- =============================================
-- Author:		Bing Yu
-- Create date: 08/16/2019
-- Description:	Insert Acute Confinements file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportAcuteConfinements]
    @ProviderName varchar(200),
	@Admissions varchar(20) ,
	@Days varchar(10),
	@TotalPaid varchar(50),
	@Admits varchar(10), 
	--decimal(5, 2),
	@OrignalSrcFileName varchar(100),
	@SrcFileName varchar(100),
--	@CreatedDate datetime2(7) ,
	@CreatedBy varchar(50) ,
--	@LastUpdatedDate datetime2(7),
	@LastUpdatedBy varchar(50) 
  
  
          
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
	BEGIN
    -- Insert statements 
    INSERT INTO adi.[AcuteConfinements]
    (
	[ProviderName],
	[Admissions] ,
	[Days],
	[TotalPaid] ,
	[Admits] ,
	[OrignalSrcFileName] ,
	[SrcFileName] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] 
	)
		
 VALUES   (
    @ProviderName,
	@Admissions ,
	CASE WHEN @Days = ''
	THEN NULL
	ELSE CONVERT(float,  REPLACE(@Days,',',''))
	END,
	CASE WHEN @TotalPaid = ''
	THEN NULL
	ELSE CONVERT(money, @TotalPaid)
	END,
	CASE WHEN @Admits  = ''
	THEN NULL
	ELSE REPLACE(@Admits,'%','')
	END,
	--decimal(5, 2),
	@OrignalSrcFileName ,
	@SrcFileName ,
	GETDATE(),
	--@CreatedDate  ,
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate,
	@LastUpdatedBy   

)
    END
END



--SELECT CONVERT(int, '2,275') 


--SELECT REPLACE('2,275',',','')  

--ALTER table [adi].[AcuteConfinements]
--ALTer column [Days] float 
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportcopAetComCareopps](
    @IndividualId varchar(50),
	@PatientId varchar(50),
	@PatientLastName varchar(50),
	@PatientFirstName varchar(50),
	@PatientMiddleName varchar(50),
	@DOB varchar(10),
	@Numerator varchar(10),
	@NumeratorServiceDate varchar(10),
	@MemberType varchar(30),
	@Measure_Number varchar(20),
	-- @loadDate [date] NOT NULL,
	@DataDate varchar(10),
	@OrignalSrcFileName varchar(100),
	@SrcFileName varchar(100),
	-- @CreatedDate] [datetime2](7) NOT NULL,
	@CreatedBy varchar(50),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy varchar(50)  


)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
--	DECLARE @RecordExist INT
--	SET @RecordExist = (SELECT COUNT(*)
--	FROM adi.copAetComCareopps
--	WHERE SrcFileName = @SrcFileName)
	
--	IF @RecordExist = 0   
	BEGIN
    -- Insert statements for procedure here
IF (@PatientId != '')
BEGIN
 INSERT INTO adi.copAetComCareopps
   (
    [IndividualId] ,
	[PatientId] ,
	[PatientLastName],
	[PatientFirstName] ,
	[PatientMiddleName],
	[DOB] ,
	[Numerator] ,
	[NumeratorServiceDate],
	[MemberType] ,
	[Measure_Number] ,
	[loadDate] ,
	[DataDate] ,
	[OrignalSrcFileName] ,
	[SrcFileName],
	[CreatedDate],
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] 
	
     )
     VALUES
   (  
    @IndividualId,
	@PatientId,
	@PatientLastName ,
	@PatientFirstName,
	@PatientMiddleName,
	CASE WHEN (@DOB = '')
	THEN NULL
	ELSE CONVERT(date,   @DOB)
	END,
	@Numerator ,
	CASE WHEN (@NumeratorServiceDate = '')
	THEN NULL
	ELSE CONVERT(date, @NumeratorServiceDate)
	END,
	@MemberType ,
	@Measure_Number ,
	GETDATE(),
	-- @loadDate [date] NOT NULL,
	CASE WHEN (@DataDate = '')
	THEN NULL
	ELSE CONVERT(date, @DataDate)
	END,
	@OrignalSrcFileName ,
	@SrcFileName ,
	GETDATE(),
	-- @CreatedDate] [datetime2](7) NOT NULL,
	@CreatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy    	
	 )
	 END
	END
END




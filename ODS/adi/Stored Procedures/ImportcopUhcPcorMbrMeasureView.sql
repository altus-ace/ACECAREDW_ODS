-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportcopUhcPcorMbrMeasureView](
    --[loadDate] [date] NOT NULL,
	@DataDate VARCHAR(10), 
	--[date] NOT NULL,
	@OriginalFileName varchar(100),
	@SrcFileName varchar(100),
	--[CreatedDate] [datetime2](7) NOT NULL,
	@CreatedBy varchar(50),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy varchar(50),
	@IncentiveProgram varchar(20),
	@Category [varchar](20),
	@HealthPlan varchar(10) ,
	@LOB varchar(100) ,
	@MeasureCode varchar(10) ,
	@MeasureDesc varchar(120) ,
	@SubMeasure varchar(100) ,
	@Bucket varchar(10) ,
	@Compliant varchar(10),
	@MemberID varchar(50),
	@FirstName varchar(35),
	@LastName varchar(35) ,
	@DOB varchar(10),
	--[date] NULL,
	@Phone varchar(35) ,
	@MemberAddress varchar(75),
	@City varchar(35),
	@State varchar(25),
	@Zip varchar(14) ,
	@BaseEventEpisodeDate varchar(10), 
	--[date] NULL,
	@DateOfLastService varchar(10),
	-- [date] NULL,
	@Physician varchar(50),
	@PhysicianAddress varchar(100) 

)
	-- Add the parameters for the stored procedure here




      
	-- SET @Measure = @MeasureCode+' :  '+@MeasureDesc+ (CASE WHEN @SubMeasure = '(Default)' 
	 --                                                  THEN +' .' 
	---												   ELSE  ' - '+@SubMeasure+' .' 
---													   END
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Measure varchar(500)
	
    SET @Measure = 
	    CASE
		WHEN @SubMeasure = '(Default)' THEN @MeasureCode+' :  '+ @MeasureDesc + ' .'     
		ELSE @MeasureCode +' :  '+@MeasureDesc + ' - '+ @SubMeasure+' .' 
		END
	--SET @Measure = @MeasureDesc +'-' + @SubMeasure  
	--UPDATE adi.MbrAetCom
--	SET MEMBER_ID  =  @MEMBER_ID 

--    WHERE  MEMBER_ID = @MEMBER_ID

	 
--	IF @@ROWCOUNT = 0

    -- Insert statements for procedure here
IF (@Zip <> '' )
BEGIN
 INSERT INTO [adi].[copUhcPcorMbrMeasureView]
   (
    [loadDate],
	[DataDate] ,
	[OriginalFileName] ,
	[SrcFileName] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] ,
	[IncentiveProgram] ,
	[Category] ,
	[HealthPlan] ,
	[LOB] ,
	[MeasureCode] ,
	[MeasureDesc] ,
	[SubMeasure] ,
	[Bucket] ,
	[Compliant] ,
	[MemberID] ,
	[FirstName] ,
	[LastName] ,
	[DOB] ,
	[Phone] ,
	[MemberAddress] ,
	[City] ,
	[State] ,
	[Zip] ,
	[BaseEventEpisodeDate] ,
	[DateOfLastService] ,
	[Physician] ,
	[PhysicianAddress] 
	
--	,[MedicationAdherence90DayConversion]
     )
     VALUES
   (   
   GETDATE(), 
   CONVERT(DATE, @DataDate),
   	--[date] NOT NULL,
	@OriginalFileName ,
	@SrcFileName ,
	GETDATE(),
	--[CreatedDate] [datetime2](7) NOT NULL,
	@CreatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy ,
	@IncentiveProgram ,
	@Category ,
	@HealthPlan ,
	@LOB  ,
	@MeasureCode  ,
	@MeasureDesc ,
	@SubMeasure  ,
	@Bucket ,
	@Compliant ,
	@MemberID ,
	@FirstName ,
	@LastName  ,
	CASE WHEN @DOB = ''
	THEN NULL
	ELSE CONVERT(date, @DOB)
	END ,
	--[date] NULL,
	@Phone  ,
	@MemberAddress ,
	@City ,
	@State ,
	@Zip  ,
    CASE WHEN @BaseEventEpisodeDate = ''
	THEN NULL
	ELSE CONVERT(date, @BaseEventEpisodeDate)
	END , 
	--[date] NULL,
	CASE WHEN @DateOfLastService = ''
	THEN NULL
	ELSE CONVERT(date, @DateOfLastService)
	END ,
	-- [date] NULL,
	@Physician ,
	@PhysicianAddress 
 
	 )

 --   
 
     -- BEGIN 
	--IF EXISTS (SELECT QM FROM LIST_QM_Mapping WHERE  LIST_QM_Mapping.QM_DESC = @Measure)
	--BEGIN 
	--UPDATE LIST_QM_Mapping
	--SET LastUpdatedBy = 'BoomiDbUser', LastUpdatedDate = GETDATE()
	--WHERE MeasureDesc = @Measure
	--END
	--ELSE
	--BEGIN
	-- IF EXISTS (SELECT tmpQMID FROM tmp_QM_Mapping WHERE QM_DESC = @Measure)
	--  BEGIN
	--  UPDATE tmp_QM_Mapping 
	--  SET QM_DESC = @Measure
	--  WHERE  QM_DESC = @Measure   
	--  END
	-- ELSE
	-- BEGIN 
	-- EXEC dbo.ImporttmpQM_Mapping @Measure
 --   END
	--END 

 --   END

 -- test
   
	 --IF NOT EXISTS (SELECT QM FROM lst.LIST_QM_Mapping WHERE  LIST_QM_Mapping.QM_DESC = @Measure)
	 --  BEGIN
  --     IF NOT EXISTS (SELECT tmpQMID FROM dbo.tmp_QM_Mapping WHERE QM_DESC = @Measure)
	 --    BEGIN 
	 --     EXEC dbo.ImporttmpQM_Mapping @Measure
  --       END
	 --  END 
    

--- Test


--BEGIN
  
-- INSERT INTO dbo.tmp_QM_Mapping(QM_DESC, CreatedBy, CreatedDateTime)
-- SELECT distinct MeasureDesc + ' - ' + SubMeasure, 'BoomiDbUser', GETDATE()  
-- from [ACECAREDW].[adi].[copUhcPcorMbrMeasureView]
-- Where (DataDate = @DataDate)
--END
  END
END

--ALTER TABLE [adi].[copUhcPcorMbrMeasureView]
--ALTER COLUMN [SrcFileName] VARCHAR(100)



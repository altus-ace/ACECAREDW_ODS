-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportNtfUhcIpCensus](
    @LOB varchar(10) ,
	@PatientName varchar(100),
	@RosterSubgroup varchar(50) ,
	@PatientIdentifier varchar(50) ,
	@IndvID varchar(20),
	@Alt_ID varchar(20),
	@PatientBirthDate VARCHAR(10),
	@PatientGender varchar(3) ,
	@PrimaryLanguage varchar(50) ,
	@Address varchar(255),
	@City varchar(65),
	@State varchar(25),
	@Zip varchar(15),
	@ContactPhoneNumber varchar(25) ,
	@AlternativePhoneNumber varchar(25) ,
	@HospitalState varchar(10) ,
	@ProviderIdentifiedMPIN varchar(14),
	@HospitalName varchar(100),
	@AttendingPhysicianIdMPIN varchar(15),
	@AttendingPhysicianName varchar(100),
	@PrimaryCarePhysicianName varchar(100) ,
	@AdmissionDate varchar(10),
	@DischargeDate varchar(10),
	@AdmissionDateReported varchar(10),
	@DateDcReported varchar(10),
	@PrimaryDiagnosisCode varchar(10),
	@PrimaryDiagnosisDesc varchar(255),
	@AHRQ_Diagnosis_Category varchar(50),
	@ACSC_HPC varchar(50),
	@HAI_POA Varchar(50),
	@TypeOfFacility varchar(10),
	@DispositionDesc varchar(255),
	@CaseStatus varchar(10) ,
	@ReAdmissionDays varchar(5),
	@LengthOfStay int,
	@RpmScore varchar(10),
	@RstScore varchar(5),
	@IdDate varchar(10),
	@PrimaryCarePhysicianNPI varchar(10),
	@PatientCardID varchar(50),
	@LoadDate varchar(12),
	@DataDate varchar(12),
	@SrcFileName varchar(100),
	@CreatedBy varchar(50),
--	@LastUpdatedDate datetime,
	@LastUpdatedBy varchar(50)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	DECLARE @RecordExist INT
	SET @RecordExist = (Select COUNT(*)
	FROM adi.NtfUhcIpCensus 
	WHERE SrcFileName = @SrcFileName)
	 
--	IF @RecordExist =0
	BEGIN     


    -- Insert statements for procedure here
 INSERT INTO adi.NtfUhcIpCensus
   (
    [LOB],
	[PatientName],
	[RosterSubgroup],
	[PatientIdentifier] ,
	[IndvID] ,
	[Alt_ID],
	[PatientBirthDate] ,
	[PatientGender] ,
	[PrimaryLanguage],
	[Address] ,
	[City],
	[State],
	[Zip],
	[ContactPhoneNumber],
	[AlternativePhoneNumber] ,
	[HospitalState] ,
	[ProviderIdentifiedMPIN] ,
	[HospitalName],
	[AttendingPhysicianIdMPIN],
	[AttendingPhysicianName],
	[PrimaryCarePhysicianName] ,
	[AdmissionDate] ,
	[DischargeDate] ,
	[AdmissionDateReported],
	[DateDcReported] ,
	[PrimaryDiagnosisCode] ,
	[PrimaryDiagnosisDesc] ,
	[AHRQ_Diagnosis_Category],
	[ACSC_HPC],
	[HAI_POA],
	[TypeOfFacility],
	[DispositionDesc] ,
	[CaseStatus],
	[ReAdmissionDays],
	[LengthOfStay] ,
	[RpmScore] ,
	[RstScore] ,
	[IdDate] ,
	[PrimaryCarePhysicianNPI] ,
	[PatientCardID] ,
	[LoadDate],
	[DataDate] ,
	[SrcFileName],
	[CreatedDate] ,
	[CreatedBy],
	[LastUpdatedDate] ,
	[LastUpdatedBy]    
            )
     VALUES
   (   
    @LOB ,
	@PatientName ,
	@RosterSubgroup  ,
	@PatientIdentifier  ,
	@IndvID ,
	@Alt_ID ,
	CASE WHEN (@PatientBirthDate = '')
	THEN NULL
	ELSE CONVERT(date,@PatientBirthDate)
	END,
	@PatientGender  ,
	@PrimaryLanguage ,
	@Address ,
	@City ,
	@State ,
	@Zip,
	@ContactPhoneNumber ,
	@AlternativePhoneNumber ,
	@HospitalState ,
	@ProviderIdentifiedMPIN ,
	@HospitalName ,
	@AttendingPhysicianIdMPIN,
	@AttendingPhysicianName ,
	@PrimaryCarePhysicianName ,
	CASE WHEN (@AdmissionDate = '')
	THEN null
	ELSE CONVERT(date, @AdmissionDate) 
	END,
	CASE WHEN (@DischargeDate = '')
	THEN NULL
	ELSE CONVERT(date, @DischargeDate) 
	END,
	CASE WHEN (@AdmissionDateReported = '')
	THEN NULL
	ELSE CONVERT(date, @AdmissionDateReported) 
	END,
	CASE WHEN (@DateDcReported = '')
	THEN NULL
	ELSE CONVERT(date, @DateDcReported) 
	END,
	@PrimaryDiagnosisCode,
	@PrimaryDiagnosisDesc ,
	@AHRQ_Diagnosis_Category,
	@ACSC_HPC,
	@HAI_POA,
	@TypeOfFacility ,
	@DispositionDesc ,
	@CaseStatus ,
	@ReAdmissionDays ,
	CASE WHEN @LengthOfStay is null
	then null
	Else CONVERT(int,  @LengthOfStay)
	END,
	-- @RpmScore,
	CASE WHEN (@RpmScore = '')
	THEN NULL
	ELSE 
	CONVERT(numeric(4,3), @RpmScore)
	--CAST(@RpmScore as numeric(4,3))
	END ,
	@RstScore ,
	CASE wHEN (@IdDate = '')
	THEN NULL
	ELSE CONVERT(date, @IdDate) 
	END,
	@PrimaryCarePhysicianNPI,
	@PatientCardID ,
	GETDATE(),
	CONVERT(date, RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.csv%', @SrcFileName)-1)), 8)),
	--@LoadDate ,
	--CASE WHEN (@DataDate = '')
	--THEN NULL 
	--ELSE CONVERT(date, @DataDate)
	--END,
	@SrcFileName ,
	GETDATE(),
	--@CreatedDate, 
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate ,
	@LastUpdatedBy
   
   )
END
END
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportNtfUhcErCensus](
   	@PcpID varchar(15),
	@PcpFirstName varchar(65),
	@PcpLastName varchar(65),
	@PatientFirstName varchar(65),
	@PatientLastName varchar(65),
	@PatientId varchar(50),
	@RosterSubGroup varchar(100),
	@PatientCardID varchar(50) ,
	@MemberHealthPlanNumber varchar(50) ,
	@PatientBirthDate varchar(10) ,
	@PatientGender varchar(10) ,
	@PrimaryLanguage varchar(20) ,
	@Address varchar(50) ,
	@City varchar(35) ,
	@State varchar(25) ,
	@Zip varchar(12) ,
	@ContactPhoneNumber varchar(35) ,
	@AlternativePhoneNumber varchar(35) ,
	@LOB varchar(20) ,
	@ServiceDate varchar(10) ,
	@AdmitTime varchar(10) ,
	@DischargeTime varchar(10) ,
	@ServiceDateReported varchar(10),
	@DayOfWeek varchar(10) ,
	@ReOccuranceWithin30Days varchar(20) ,
	@AvoidableERVisit varchar(50) ,
	@LastIpVisitDate varchar(50) ,
	@PrimaryDiagnosisCode varchar(20) ,
	@PrimaryDiagnosisDescription varchar(100) ,
	@AHRQ_Diagnosis_Category varchar(50),
	@ACSC_HPC varchar(10),
	@HAI_POA Varchar(10),
	@AttendingPhysicianFirstName varchar(50) ,
	@AttendingPhysicianLastName varchar(50) ,
	@FacilityName varchar(100) ,
	@FacilityState varchar(25) ,
	@PcpNpi varchar(15) ,
	--@LoadDate  ,
	@DataDate varchar(10) ,
	@SrcFileName varchar(100),
	--[CreatedDate] datetime],
	@CreatedBy varchar(50),
	--@LastUpdatedDate datetime,
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
	FROM adi.NtfUhcErCensus 
	WHERE SrcFileName = @SrcFileName)
	 
--	IF @RecordExist =0
	BEGIN     
    -- Insert statements for procedure here
IF(LEN(@PcpID) > 0)
 BEGIN
 INSERT INTO adi.NtfUhcErCensus
   (
   	[PcpID],
	[PcpFirstName],
	[PcpLastName],
	[PatientFirstName] ,
	[PatientLastName] ,
	[PatientId] ,
	[RosterSubGroup] ,
	[PatientCardID] ,
	[MemberHealthPlanNumber],
	[PatientBirthDate] ,
	[PatientGender] ,
	[PrimaryLanguage],
	[Address] ,
	[City] ,
	[State] ,
	[Zip],
	[ContactPhoneNumber],
	[AlternativePhoneNumber],
	[LOB] ,
	[ServiceDate],
	[AdmitTime] ,
	[DischargeTime],
	[ServiceDateReported],
	[DayOfWeek] ,
	[ReOccuranceWithin30Days],
	[AvoidableERVisit],
	[LastIpVisitDate] ,
	[PrimaryDiagnosisCode],
	[PrimaryDiagnosisDescription] ,
	[AHRQ_Diagnosis_Category],
	[ACSC_HPC],
	[HAI_POA],
	[AttendingPhysicianFirstName] ,
	[AttendingPhysicianLastName] ,
	[FacilityName] ,
	[FacilityState],
	[PcpNpi] ,
	[LoadDate] ,
	[DataDate] ,
	[SrcFileName],
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy]    
     )
     VALUES
   (   
    @PcpID ,
	@PcpFirstName ,
	@PcpLastName ,
	@PatientFirstName ,
	@PatientLastName ,
	@PatientId,
	@RosterSubGroup,
	@PatientCardID ,
	@MemberHealthPlanNumber,
	CASE WHEN (@PatientBirthDate ='')
	THEN NULL
	ELSE @PatientBirthDate 
	END,
	@PatientGender ,
	@PrimaryLanguage ,
	@Address ,
	@City ,
	@State ,
	@Zip ,
	@ContactPhoneNumber ,
	@AlternativePhoneNumber  ,
	@LOB,
	CASE WHEN (@ServiceDate ='')
	THEN NULL
	ELSE CONVERT(date, @ServiceDate)
	END ,
	@AdmitTime  ,
	@DischargeTime ,
	CASE WHEN (@ServiceDateReported = '')
	THEN NULL
	ELSE CONVERT(date,@ServiceDateReported)
	END,
	@DayOfWeek  ,
	@ReOccuranceWithin30Days ,
	@AvoidableERVisit  ,
	@LastIpVisitDate ,
	@PrimaryDiagnosisCode ,
	@PrimaryDiagnosisDescription  ,
	@AHRQ_Diagnosis_Category ,
	@ACSC_HPC ,
	@HAI_POA ,
	@AttendingPhysicianFirstName ,
	@AttendingPhysicianLastName,
	@FacilityName  ,
	@FacilityState  ,
	@PcpNpi ,
	GETDATE(),
	--@LoadDate  ,
    CONVERT(date, RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.csv%', @SrcFileName)-1)), 8)),
--	Convert(date,@DataDate) ,
	@SrcFileName,
	GETDATE(),
	--[CreatedDate] datetime],
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate datetime,
	@LastUpdatedBy 
   )
   END
END

END
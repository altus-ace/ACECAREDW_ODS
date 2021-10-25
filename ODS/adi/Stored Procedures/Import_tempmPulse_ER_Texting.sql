-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[Import_tempmPulse_ER_Texting](
    @PcpID varchar(20) ,
	@PcpFirstName varchar(50) ,
	@PcpLastName varchar(50) ,
	@PatientFirstName varchar(50) ,
	@PatientLastName varchar(50) ,
	@PatientId varchar(50) ,
	@PLAN_DESC varchar(100) ,
	@PatientCardID varchar(50) ,
	@Text varchar(10) ,
	@MemberHealthPlanNumber varchar(50) ,
	@PatientBirthDate varchar(10) ,
	@PatientGender varchar(10) ,
	@PrimaryLanguage varchar(10) ,
	@Address varchar(50) ,
	@City varchar(50) ,
	@State varchar(20) ,
	@Zip varchar(10) ,
	@ContactPhoneNumber varchar(15) ,
	@AlternativePhoneNumber varchar(15) ,
	@LOB varchar(20) ,
	@ServiceDate varchar(10) ,
	@AdmitTime varchar(20) ,
	@DischargeTime varchar(20) ,
	@ServiceDateReported varchar(10) ,
	@DayOfWeek varchar(50) ,
	@ReOccuranceWithin30Days varchar(50) ,
	@AvoidableERVisit varchar(50) ,
	@LastIpVisitDate varchar(10) ,
	@PrimaryDiagnosisCode varchar(10) ,
	@PrimaryDiagnosisDescription varchar(50) ,
	@AttendingPhysicianFirstName varchar(50) ,
	@AttendingPhysicianLastName varchar(50) ,
	@FacilityName varchar(50) ,
	@FacilityState varchar(50) ,
	@PcpNpi varchar(50) ,
	@TextSent varchar(10) ,
	--@LoadDate varchar(10) ,
	@DataDate varchar(10)  ,
	@OrignalSrcFileName varchar(100)  ,
	@SrcFileName varchar(100)  ,
	--@CreatedDate datetime2(7)  ,
	@CreatedBy varchar(50)  ,
	--@LastUpdatedDate datetime2(7)  ,
	@LastUpdatedBy varchar(50) 
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
 BEGIN
 INSERT INTO [adi].[tempmPulse_ER_Texting]
   (
      [PcpID]
      ,[PcpFirstName]
      ,[PcpLastName]
      ,[PatientFirstName]
      ,[PatientLastName]
      ,[PatientId]
      ,[PLAN_DESC]
      ,[PatientCardID]
      ,[Text]
      ,[MemberHealthPlanNumber]
      ,[PatientBirthDate]
      ,[PatientGender]
      ,[PrimaryLanguage]
      ,[Address]
      ,[City]
      ,[State]
      ,[Zip]
      ,[ContactPhoneNumber]
      ,[AlternativePhoneNumber]
      ,[LOB]
      ,[ServiceDate]
      ,[AdmitTime]
      ,[DischargeTime]
      ,[ServiceDateReported]
      ,[DayOfWeek]
      ,[ReOccuranceWithin30Days]
      ,[AvoidableERVisit]
      ,[LastIpVisitDate]
      ,[PrimaryDiagnosisCode]
      ,[PrimaryDiagnosisDescription]
      ,[AttendingPhysicianFirstName]
      ,[AttendingPhysicianLastName]
      ,[FacilityName]
      ,[FacilityState]
      ,[PcpNpi]
      ,[TextSent]
      ,[LoadDate]
      ,[DataDate]
      ,[OrignalSrcFileName]
      ,[SrcFileName]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
     )
     VALUES
   (   
   @PcpID  ,
	@PcpFirstName  ,
	@PcpLastName  ,
	@PatientFirstName  ,
	@PatientLastName  ,
	@PatientId  ,
	@PLAN_DESC  ,
	@PatientCardID  ,
	@Text  ,
	@MemberHealthPlanNumber  ,
	CASE WHEN @PatientBirthDate =''
	THEN NULL
	ELSE CONVERT(DATE,@PatientBirthDate)
	END,
	@PatientGender ,
	@PrimaryLanguage  ,
	@Address  ,
	@City  ,
	@State  ,
	@Zip  ,
	@ContactPhoneNumber  ,
	@AlternativePhoneNumber  ,
	@LOB  ,
	CASE WHEN @ServiceDate =''
	THEN NULL
	ELSE CONVERT(DATE,@ServiceDate)
	END,
	@AdmitTime  ,
	@DischargeTime  ,
	CASE WHEN @ServiceDateReported  =''
	THEN NULL
	ELSE CONVERT(DATE,@ServiceDateReported )
	END,
	@DayOfWeek  ,
	@ReOccuranceWithin30Days  ,
	@AvoidableERVisit  ,
	@LastIpVisitDate,
	@PrimaryDiagnosisCode  ,
	@PrimaryDiagnosisDescription  ,
	@AttendingPhysicianFirstName  ,
	@AttendingPhysicianLastName  ,
	@FacilityName  ,
	@FacilityState  ,
	@PcpNpi  ,
	@TextSent  ,
	GETDATE(),
	--@LoadDate  ,
	CASE WHEN @DataDate   =''
	THEN NULL
	ELSE CONVERT(DATE,@DataDate)
	END,
	@OrignalSrcFileName   ,
	@SrcFileName   ,
	GETDATE(),
	--@CreatedDate datetime2(7)  ,
	@CreatedBy   ,
	GETDATE(),
	--@LastUpdatedDate datetime2(7)  ,
	@LastUpdatedBy  
   )
   END
   BEGIN --- update Text cloumn 
   EXEC [abo].[UpdatemPulseER_Texting] @PatientCardID
   END
   
END
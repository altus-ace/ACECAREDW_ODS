-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportMPulseDailyERCensus](
    --@LoadDate date NOT ,
	@DataDate varchar(10),
	@SrcFileName varchar(100),
	--@CreatedDate date NOT ,
	@CreatedBy varchar(50),
	--@LastUpdatedDate date,
	@LastUpdatedBy varchar(50),
	@PcpID varchar(20) ,
	@PcpFirstName varchar(50) ,
	@PcpLastName varchar(50) ,
	@PatientFirstName varchar(50) ,
	@PatientLastName varchar(50) ,
	@PatientId varchar(20) ,
	@PLAN_DESC varchar(100) ,
	@PatientCardID varchar(20) ,
	@MemberHealthPlanNumber varchar(20) ,
	@PatientBirthDate varchar(10),
	@PatientGender varchar(50) ,
	@PrimaryLanguage varchar(50) ,
	@Address varchar(20) ,
	@City varchar(50) ,
	@State varchar(10) ,
	@Zip varchar(10) ,
	@ContactPhoneNumber varchar(20) ,
	@AlternativePhoneNumber varchar(20) ,
	@LOB varchar(20) ,
	@ServiceDate varchar(10),
	@AdmitTime varchar(10),
	@DischargeTime varchar(10),
	@ServiceDateReported varchar(10),
	@DayOfWeek varchar(10),
	@ReOccuranceWithin30Days varchar(100) ,
	@AvoidableERVisit varchar(100) ,
	@LastIpVisitDate varchar(10) ,
	@PrimaryDiagnosisCode varchar(50) ,
	@PrimaryDiagnosisDescription varchar(50) ,
	@AttendingPhysicianFirstName varchar(20) ,
	@AttendingPhysicianLastName varchar(20) ,
	@FacilityName varchar(20) ,
	@FacilityState varchar(20) ,
	@PcpNpi varchar(20) ,
	@TextSent varchar(20)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	--DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
	--SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', '[ACECARDW].[adi].[copUhcPcor]', '' ;



 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
 INSERT INTO [adi].[MPulseDailyERCensus]
   (
       [LoadDate]
      ,[DataDate]
      ,[SrcFileName]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[PcpID]
      ,[PcpFirstName]
      ,[PcpLastName]
      ,[PatientFirstName]
      ,[PatientLastName]
      ,[PatientId]
      ,[PLAN_DESC]
      ,[PatientCardID]
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
      
	
    )
     VALUES
   (
    GETDATE(),  --@LoadDate date NOT ,
	@DataDate ,
	@SrcFileName ,
	GETDATE(),
	--@CreatedDate date NOT ,
	@CreatedBy ,
	GETDATE(),
	--@LastUpdatedDate date,
	@LastUpdatedBy ,
	@PcpID  ,
	@PcpFirstName  ,
	@PcpLastName  ,
	@PatientFirstName  ,
	@PatientLastName  ,
	@PatientId  ,
	@PLAN_DESC  ,
	@PatientCardID  ,
	@MemberHealthPlanNumber  ,
	@PatientBirthDate ,
	@PatientGender  ,
	@PrimaryLanguage  ,
	@Address  ,
	@City  ,
	@State  ,
	@Zip  ,
	@ContactPhoneNumber  ,
	@AlternativePhoneNumber  ,
	@LOB  ,
	@ServiceDate ,
	@AdmitTime ,
	@DischargeTime ,
	@ServiceDateReported ,
	@DayOfWeek ,
	@ReOccuranceWithin30Days  ,
	@AvoidableERVisit  ,
	@LastIpVisitDate  ,
	@PrimaryDiagnosisCode  ,
	@PrimaryDiagnosisDescription  ,
	@AttendingPhysicianFirstName  ,
	@AttendingPhysicianLastName  ,
	@FacilityName  ,
	@FacilityState  ,
	@PcpNpi  ,
	@TextSent 
   )
   END;

  -- SET @ActionStopDateTime = GETDATE(); 
  -- EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2   

  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END





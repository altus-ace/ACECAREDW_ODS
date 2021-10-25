-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORU to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportIB_API_Appointment]  
    --@LoadDate date NOT ,
	@DataDate varchar(10) ,
	@SrcFileName varchar(100)  ,
	--@CreatedDate datetime  ,
	@CreatedBy varchar(50) ,
	--@LastUpdatedDate datetime NOT ,
	@LastUpdatedBy varchar(50)  ,
	@Date VARCHAR(10) ,
	@AppointmentId varchar(50) ,
	@StartTime VARCHAR(10) ,
	@DepartmentId varchar(10) ,
	@AppointmentStatus varchar(5) ,
	@ScheduleBy varchar(50) ,
	@PatientId varchar(10) ,
	@Urgent VARCHAR(10) ,
	@Duration varchar(10) ,
	@TemplateAppointmentTypeId varchar(10) ,
	@HL7ProviderId varchar(10) ,
	@LastModifiedBy varchar(10) ,
	@AppointmentCopay_collectedforother VARCHAR(10) ,
	@AppointmentCopay_collectedforappointment VARCHAR(10) ,
	@AppointmentCopay_insurancecopay VARCHAR(10) ,
	@Copay VARCHAR(10) ,
	@AppointmentTypeId varchar(10) ,
	@LastModified varchar(50),
	@AppointmentType varchar(50) ,
	@ProviderId varchar(10) ,
	@ChargeEntryNotRequired VARCHAR(10) ,
	@ScheduledDateTime varchar(50),
	@CoordinatorEnterprise VARCHAR(10) ,
	@TemplateAppointmentId varchar(10) ,
	@PatientAppointmentTypeName varchar(10) 
          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [DEV_ACECAREDW].[adi].[ImportIB_API_Appointment]
	   --@LoadDate date NOT ,
	@DataDate  ,
	@SrcFileName  ,
	--@CreatedDate datetime  ,
	@CreatedBy  ,
	--@LastUpdatedDate datetime NOT ,
	@LastUpdatedBy   ,
	@Date  ,
	@AppointmentId  ,
	@StartTime  ,
	@DepartmentId  ,
	@AppointmentStatus  ,
	@ScheduleBy  ,
	@PatientId  ,
	@Urgent  ,
	@Duration  ,
	@TemplateAppointmentTypeId  ,
	@HL7ProviderId  ,
	@LastModifiedBy  ,
	@AppointmentCopay_collectedforother  ,
	@AppointmentCopay_collectedforappointment  ,
	@AppointmentCopay_insurancecopay  ,
	@Copay  ,
	@AppointmentTypeId  ,
	@LastModified ,
	@AppointmentType  ,
	@ProviderId  ,
	@ChargeEntryNotRequired  ,
	@ScheduledDateTime ,
	@CoordinatorEnterprise  ,
	@TemplateAppointmentId  ,
	@PatientAppointmentTypeName  
          
END


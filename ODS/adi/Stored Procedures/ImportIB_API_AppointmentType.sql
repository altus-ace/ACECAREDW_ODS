-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORU to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportIB_API_AppointmentType]  
	@Shortname varchar(20) ,
	@Name varchar(50) ,
	@Duration varchar(5) ,
	@PatientDisplayName varchar(50) ,
	@AppointmentTypeId varchar(5) ,
	@Generic varchar(5) ,
	@Patient varchar(5) ,
	@CreateEncounterOnCheckIn varchar(5) ,
	@TemplateTypeOnly varchar(5) ,
	--@LoadDate date  ,
	@DataDate varchar(10)  ,
	@SrcFileName varchar(100)  ,
	--@CreatedDate datetime  ,
	@CreatedBy varchar(50)  ,
--	@LastUpdatedDate datetime  ,
	@LastUpdatedBy varchar(50)  
          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [DEV_ACECAREDW].[adi].[ImportIB_API_AppointmentType]
	@Shortname  ,
	@Name  ,
	@Duration  ,
	@PatientDisplayName  ,
	@AppointmentTypeId  ,
	@Generic  ,
	@Patient  ,
	@CreateEncounterOnCheckIn  ,
	@TemplateTypeOnly  ,
	--@LoadDate  ,
	@DataDate   ,
	@SrcFileName  ,
	--@CreatedDate datetime  ,
	@CreatedBy   ,
--	@LastUpdatedDate datetime  ,
	@LastUpdatedBy   

END


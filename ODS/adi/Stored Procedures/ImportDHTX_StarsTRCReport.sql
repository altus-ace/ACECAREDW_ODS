-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert  file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_StarsTRCReport]
    @ReportDate varchar(10) ,
	@PatientName [varchar](50) ,
	@PatientID [varchar](50) ,
	@PatientDob varchar(10),
	@PatientPhone [varchar](12) ,
	@PatientMobilePhone [varchar](12) ,
	@PcpName [varchar](50) ,
	@PcpNPI [varchar](12) ,
	@PcpPracticeName [varchar](50) ,
	@PCPAddress [varchar](50) ,
	@PCPPhone [varchar](12) ,
	@PcpTIN [varchar](12) ,
	@PcpTINName [varchar](50) ,
	@AdmissionDate VARCHAR(10) ,
	@DischargeDate varchar(10) ,
	@FacilityName [varchar](50) ,
	@DateAdmissionNotification varchar(10) ,
	@DateDischargeNotification varchar(10) ,
	@MrpPatientEngagementDeadline [varchar](50) ,
	@DaysToMRPPatientEngagementDeadline varchar(10) ,
	@PatientEngagementPostDischarge [varchar](50) ,
	@PatientEngagementPostDischargeDate varchar(10) ,
	@MrpActionNeeded [varchar](50) ,
	@MrpClaimSubmitted [varchar](50) ,
	@MrpClaimServiceDate varchar(10) ,
	@MRPMedicalRecordReceived [varchar](50) ,
	@MRPMedicalRecordServiceDate varchar(10) ,
	@MRPCompletedByHealthPlan [varchar](50) ,
	@HealthPlanMRPCompletionDate varchar(10) ,
	@SrcFileName [varchar](100),
	@FileDate varchar(10),
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_DHTX].[adi].[ImportDHTX_StarsTRCReport]
	@ReportDate  ,
	@PatientName  ,
	@PatientID  ,
	@PatientDob ,
	@PatientPhone  ,
	@PatientMobilePhone  ,
	@PcpName  ,
	@PcpNPI  ,
	@PcpPracticeName  ,
	@PCPAddress  ,
	@PCPPhone  ,
	@PcpTIN  ,
	@PcpTINName  ,
	@AdmissionDate  ,
	@DischargeDate  ,
	@FacilityName  ,
	@DateAdmissionNotification  ,
	@DateDischargeNotification  ,
	@MrpPatientEngagementDeadline  ,
	@DaysToMRPPatientEngagementDeadline  ,
	@PatientEngagementPostDischarge  ,
	@PatientEngagementPostDischargeDate  ,
	@MrpActionNeeded  ,
	@MrpClaimSubmitted  ,
	@MrpClaimServiceDate  ,
	@MRPMedicalRecordReceived  ,
	@MRPMedicalRecordServiceDate  ,
	@MRPCompletedByHealthPlan  ,
	@HealthPlanMRPCompletionDate  ,
	@SrcFileName ,
	@FileDate ,
	--[CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy  ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate 


END


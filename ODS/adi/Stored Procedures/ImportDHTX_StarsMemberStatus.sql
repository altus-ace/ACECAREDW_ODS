

-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert Hospital Census file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_StarsMemberStatus]
    @ReportDate varchar(10)  ,
	@PatientName [varchar](50)  ,
	@PatientID [varchar](50)  ,
	@PatientDob varchar(10) ,
	@PatientPhone [varchar](12)  ,
	@PatientMobilePhone [varchar](12)  ,
	@PcpName [varchar](50)  ,
	@PcpNPI [varchar](20)  ,
	@PcpPracticeName [varchar](50)  ,
	@PCPAddress [varchar](100)  ,
	@PCPPhone [varchar](12)  ,
	@PcpTIN [varchar](12)  ,
	@PcpTINName [varchar](100)  ,
	@DateLastPcpVisit varchar(10)  ,
	@LastPCPVisitName [varchar](50)  ,
	@LastPcpVisitNPI [varchar](20)  ,
    @DiabetesStatus [varchar](50)  ,
    @DiabetesRetinalScreen [varchar](50)  ,
    @DateLastEyeExam [varchar](50)  ,
    @DiabetesKidneyMonitoring [varchar](50)  ,
    @DiabetesHba1cControl [varchar](50)  ,
    @DiabetesHba1cControlReason [varchar](50)  ,
    @DateLastA1c [varchar](50)  ,
    @LastA1CValue [varchar](50)  ,
    @LastA1CSource [varchar](50)  ,
    @ControllingBloodPressure [varchar](50)  , 
    @HypertensionDiagnosisDate varchar(10)  ,
    @ControllingBPReason [varchar](50)  ,
    @DateLastBPReading varchar(10)  ,
    @LastBPReadingValue [varchar](50)  ,
    @LastBPSource [varchar](50)  ,
    @ColorectalCancerScreening  [varchar](50)  ,
    @BreastCancerScreening [varchar](50)  ,
    @COAMedicationReview [varchar](50)  ,
    @COAFunctionalStatusAssessment [varchar](50)  ,
    @COAPainAssessment [varchar](50)  ,
    @DiabetesStatinUse [varchar](50)  ,
    @CardiovascularStatinUse [varchar](50)  ,
    @OsteoporosisManagementForWomenWithFracture [varchar](50)  ,
    @OMWFractureDate varchar(10)  ,
	@SrcFileName [varchar](100)  ,
	@FileDate varchar(10)  ,
	--[CreateDate] [datetime]  ,
	@CreateBy [varchar](100)  ,
	@OriginalFileName [varchar](100)  ,
	@LastUpdatedBy [varchar](100)  ,
	--[LastUpdatedDate] [datetime]  ,
	@DataDate varchar(10)
   
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_DHTX].[adi].[ImportDHTX_StarsMemberStatus]
	@ReportDate   ,
	@PatientName   ,
	@PatientID   ,
	@PatientDob  ,
	@PatientPhone ,
	@PatientMobilePhone  ,
	@PcpName   ,
	@PcpNPI  ,
	@PcpPracticeName   ,
	@PCPAddress   ,
	@PCPPhone   ,
	@PcpTIN   ,
	@PcpTINName   ,
	@DateLastPcpVisit   ,
	@LastPCPVisitName   ,
	@LastPcpVisitNPI ,
    @DiabetesStatus   ,
    @DiabetesRetinalScreen   ,
    @DateLastEyeExam   ,
    @DiabetesKidneyMonitoring   ,
    @DiabetesHba1cControl   ,
    @DiabetesHba1cControlReason   ,
    @DateLastA1c   ,
    @LastA1CValue   ,
    @LastA1CSource   ,
    @ControllingBloodPressure   , 
    @HypertensionDiagnosisDate   ,
    @ControllingBPReason   ,
    @DateLastBPReading   ,
    @LastBPReadingValue   ,
    @LastBPSource   ,
    @ColorectalCancerScreening    ,
    @BreastCancerScreening   ,
    @COAMedicationReview   ,
    @COAFunctionalStatusAssessment   ,
    @COAPainAssessment   ,
    @DiabetesStatinUse   ,
    @CardiovascularStatinUse   ,
    @OsteoporosisManagementForWomenWithFracture   ,
    @OMWFractureDate   ,
	@SrcFileName   ,
	@FileDate   ,
	--[CreateDate] [datetime]  ,
	@CreateBy   ,
	@OriginalFileName   ,
	@LastUpdatedBy   ,
	--[LastUpdatedDate] [datetime]  ,
	@DataDate 

	
END




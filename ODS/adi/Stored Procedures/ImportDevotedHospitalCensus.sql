
-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert Hospital Census file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDevotedHospitalCensus]
 	@SrcFileName varchar (100)  ,
	@FileDate varchar(10)  ,
--	@CreateDate datetime   ,
	@CreateBy varchar (100)  ,
	@OriginalFileName varchar (100)  ,
	@LastUpdatedBy varchar (100)  ,
--	@LastUpdatedDate datetime   ,
	@DataDate varchar(10)  ,
	@ReportDate varchar(10),
	@DevotedID varchar (50)  ,
	@AuthorizationNumber varchar (50)  ,
	@MBI varchar (50)  ,
	@MemberFirstName varchar (50)  ,
	@MemberMiddleInitial varchar (20)  ,
	@MemberLastName varchar (50)  ,
	@MemberDOB VARCHAR(10)   ,
	@PcpName varchar (50)  ,
	@PcpNPI varchar (15)  ,
	@PcpPracticeName varchar (20)  ,
	@PCPAddress varchar (100)  ,
	@PCPPhone varchar (20)  ,
	@PcpTIN varchar (20)  ,
	@PcpTINName varchar (50)  ,
	@AdmissionLevelofCare varchar (20)  ,
	@AdmissionDate varchar(10)   ,
	@AdmissionDiagnosis varchar (1000)  ,
	@AdmissionDiagnosisDescription varchar (5000)  ,
	@FacilityName varchar (100)  ,
	@FacilityNPI varchar (20)  ,
	@DischargeDate varchar(10) ,
	@DischargeDiagnosis varchar (100)  ,
	@DischargeDisposition varchar (50)  ,
	@AuthorizationRequestReceivedDate varchar(10)  ,
	@RequestingProviderFacilityNPI varchar (20)  ,
	@RequestingProviderFacilityName varchar (20)  ,
	@CensusSource varchar (20)  ,
	@OtherAuthorizations varchar (20)  ,
	@ClaimNumbers varchar (500)  
   
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_DHTX].[adi].[ImportDevotedHospitalCensus]
	@SrcFileName   ,
	@FileDate  ,
	--@CreateDate datetime   ,
	@CreateBy   ,
	@OriginalFileName   ,
	@LastUpdatedBy   ,
--	@LastUpdatedDate datetime   ,
	@DataDate   ,
	@ReportDate,
	@DevotedID   ,
	@AuthorizationNumber   ,
	@MBI   ,
	@MemberFirstName   ,
	@MemberMiddleInitial   ,
	@MemberLastName   ,
	@MemberDOB ,
	@PcpName   ,
	@PcpNPI  ,
	@PcpPracticeName   ,
	@PCPAddress   ,
	@PCPPhone   ,
	@PcpTIN   ,
	@PcpTINName   ,
	@AdmissionLevelofCare   ,
	@AdmissionDate ,
	@AdmissionDiagnosis   ,
	@AdmissionDiagnosisDescription   ,
	@FacilityName   ,
	@FacilityNPI   ,
	@DischargeDate ,
	@DischargeDiagnosis   ,
	@DischargeDisposition   ,
	@AuthorizationRequestReceivedDate  ,
	@RequestingProviderFacilityNPI   ,
	@RequestingProviderFacilityName   ,
	@CensusSource   ,
	@OtherAuthorizations   ,
	@ClaimNumbers   
   
	
END



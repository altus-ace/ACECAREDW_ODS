-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORU to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportHL7_ORU_R01_PV1]  
    @PV10_SegmentIden [varchar](3) ,
	@PID1_SequenceNum [char](1),
	--[LoadDate] [date] NOT NULL,
	@DataDate varchar(10),
	@SrcFileName [varchar](100) ,
	--[CreatedDate] [datetime] ,
	@CreatedBy [varchar](50) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@PV12_PatientClass [varchar](4),
	@PV13_AssignedPatientLoc [varchar](13) ,
	@PV14_AdmissionType [varchar](3) ,
	@PV15_PreAdmitNum [varchar](250) ,
	@PV16_PriorPatientLoc [varchar](80) ,
	@PV17_AttendingProvider [varchar](400) ,
	@MSH10_MessageControlID [varchar](200),
	@PV11_SeqNum [varchar](1) ,
	@PV18_1_ID [varchar](50),
	@PV18_1_IdTypeCode [varchar](50) NULL,
	@PV18_1_LastName [varchar](50) NULL,
	@PV18_1_FirstName [varchar](50) NULL,
	@PV139_ServiceFacility [varchar](50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [DEV_ACECAREDW].[adi].[ImportHL7_ORU_PV1]
	@PV10_SegmentIden ,
	@PID1_SequenceNum ,
	--[LoadDate] [date] NOT NULL,
	@DataDate ,
	@SrcFileName  ,
	--[CreatedDate] [datetime] ,
	@CreatedBy  ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy  ,
	@PV12_PatientClass ,
	@PV13_AssignedPatientLoc ,
	@PV14_AdmissionType ,
	@PV15_PreAdmitNum  ,
	@PV16_PriorPatientLoc  ,
	@PV17_AttendingProvider  ,
	@MSH10_MessageControlID ,
	@PV11_SeqNum  ,
	@PV18_1_ID ,
	@PV18_1_IdTypeCode ,
	@PV18_1_LastName ,
	@PV18_1_FirstName ,
	@PV139_ServiceFacility 
END


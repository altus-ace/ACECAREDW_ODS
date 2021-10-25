-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORU to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportHL7_ORU_R01_PID]  
    @PID0_SegmentTypeID [varchar](3)  ,
	@PID1_SequenceNum [varchar](4)  ,
	--@LoadDate   ,
	@DataDate varchar(10) ,
	@SrcFileName [varchar](100) ,
	--[CreatedDate [datetime] ,
	@CreatedBy [varchar](50) ,
	--[LastUpdatedDate [datetime]  ,
	@LastUpdatedBy [varchar](50),
	@PID2_ExternalPatientID [varchar](20)  ,
	@PID3_PatientIdentifierList [varchar](200)  ,
	@PID4_AlternatePatientID [varchar](200)  ,
	@PID6_MothersMaidenName [varchar](48)  ,
	@PID7_PatientDatebirth [varchar](8)  ,
	@PID8_PatientGender [char](1)  ,
	@PID9_PatientAlias [char](48)  ,
	@PID10_PatientRace [char](669)  ,
	@PID11_PatientAddress [varchar](669)  ,
	@PID12_PatientCountyCode [char](4)  ,
	@PID13_PatientHomePhone [char](13)  ,
	@MSH10_MessageControlID [varchar](200)  ,
	@PID11_ADD_ST [varchar](100)  ,
	@PID11_ADD_CITY [varchar](100)  ,
	@PID11_ADD_STATE [varchar](100)  ,
	@PID11_ADD_ZIP [varchar](100)  ,
	@MSH9_MsgCode [varchar](50)  ,
	@MSH9_TriggerEvent [varchar](50)  ,
	@PID14_BusinessPhoneNumber [varchar](15)  ,
	@PID15_PrimaryLangugaue [varchar](50)  ,
	@PID16_MaritalStatus [varchar](100)  ,
	@PID17_Religion [varchar](100)  ,
	@PID18_PatientAccountNumber [varchar](100)  ,
	@PID19_SSN [varchar](16)  ,
	@PID11_ADD_ST2 [varchar](100)  ,
	@PID51_PatientLastName [varchar](100)  ,
	@PID52_PatientFirstName [varchar](100)   

          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [DEV_ACECAREDW].[adi].[ImportHL7_ORU_PID]
	 @PID0_SegmentTypeID ,
	@PID1_SequenceNum  ,
	--@LoadDate   ,
	@DataDate  ,
	@SrcFileName ,
	--[CreatedDate [datetime] ,
	@CreatedBy ,
	--[LastUpdatedDate [datetime]  ,
	@LastUpdatedBy ,
	@PID2_ExternalPatientID ,
	@PID3_PatientIdentifierList ,
	@PID4_AlternatePatientID ,
	@PID6_MothersMaidenName  ,
	@PID7_PatientDatebirth ,
	@PID8_PatientGender  ,
	@PID9_PatientAlias  ,
	@PID10_PatientRace  ,
	@PID11_PatientAddress ,
	@PID12_PatientCountyCode ,
	@PID13_PatientHomePhone  ,
	@MSH10_MessageControlID ,
	@PID11_ADD_ST ,
	@PID11_ADD_CITY ,
	@PID11_ADD_STATE ,
	@PID11_ADD_ZIP  ,
	@MSH9_MsgCode ,
	@MSH9_TriggerEvent  ,
	@PID14_BusinessPhoneNumber  ,
	@PID15_PrimaryLangugaue ,
	@PID16_MaritalStatus  ,
	@PID17_Religion   ,
	@PID18_PatientAccountNumber ,
	@PID19_SSN ,
	@PID11_ADD_ST2  ,
	@PID51_PatientLastName  ,
	@PID52_PatientFirstName   
	
END


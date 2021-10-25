-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORU to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportHL7_ORU_OBX]  
    @OBX0_SegmentType varchar(3)  ,
	@OBX1_SequenceNum varchar(4)  ,
	--@LoadDate date] NOT  ,
	@DataDate varchar(10)  ,
	@SrcFileName varchar(100) ,
	--@CreatedDate datetime] NOT  ,
	@CreatedBy varchar(50)   ,
	--@LastUpdatedDate datetime] NOT  ,
	@LastUpdatedBy varchar(50) ,
	@OBX2_ValueType varchar(2)  ,
	@OBX3_ObservationIdentifier varchar(590)  ,
	@OBX4_ObservationSubId varchar(20)  ,
	@OBX5_ObservationValue varchar(max)  ,
	@OBX6_ResultUnitsMeasurement varchar(60)  ,
	@OBX7_ResultUnitReferenceRange varchar(10)  ,
	@OBX8_AbnormalFlags varchar(5)  ,
	@OBX9_Probability varchar(5)  ,
	@OBX10_NatureAbnormalTest varchar(2)  ,
	@OBX11_ObservationResultStatus char(1)  ,
	@OBX12_EffectiveDateLastNormalObservation varchar(26)  ,
	@OBX13_UserDefinedAccessChecks varchar(20)  ,
	@OBX14_ObservationDateTime varchar(50)  ,
	@OBX15_ProducersId varchar(60)  ,
	@OBX16_ResponsibleObserver varchar(80)  ,
	@OBX17_ObservationMethod varchar(80)  ,
	@MSH10_MessageControlID varchar(200)  ,
	@OBX3_1_Identifier varchar(20)  ,
	@OBX3_2_Text varchar(199)  ,
	@OBX3_3_CodingSystemName varchar(20)  ,
	@OBX3_4_AlternateIdentifier varchar(20)  ,
	@OBX3_5_AlternateText varchar(199)  ,
	@OBX3_6_AlternateCodingSystemName varchar(20)  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [DEV_ACECAREDW].[adi].[ImportHL7_ORU_OBX]
	@OBX0_SegmentType ,
	@OBX1_SequenceNum  ,
	--@LoadDate date] NOT  ,
	@DataDate   ,
	@SrcFileName ,
	--@CreatedDate datetime] NOT  ,
	@CreatedBy   ,
	--@LastUpdatedDate datetime] NOT  ,
	@LastUpdatedBy ,
	@OBX2_ValueType  ,
	@OBX3_ObservationIdentifier   ,
	@OBX4_ObservationSubId ,
	@OBX5_ObservationValue   ,
	@OBX6_ResultUnitsMeasurement  ,
	@OBX7_ResultUnitReferenceRange  ,
	@OBX8_AbnormalFlags   ,
	@OBX9_Probability  ,
	@OBX10_NatureAbnormalTest  ,
	@OBX11_ObservationResultStatus  ,
	@OBX12_EffectiveDateLastNormalObservation  ,
	@OBX13_UserDefinedAccessChecks   ,
	@OBX14_ObservationDateTime   ,
	@OBX15_ProducersId ,
	@OBX16_ResponsibleObserver ,
	@OBX17_ObservationMethod ,
	@MSH10_MessageControlID   ,
	@OBX3_1_Identifier  ,
	@OBX3_2_Text   ,
	@OBX3_3_CodingSystemName  ,
	@OBX3_4_AlternateIdentifier  ,
	@OBX3_5_AlternateText   ,
	@OBX3_6_AlternateCodingSystemName 
	
END


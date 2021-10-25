-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportHL7_ORU_R01_MSH]
    @MSH0_SegIndef [varchar](3) ,
	@MSH1_FieldDelim [char](1) ,
	@LoadDate varchar(10) ,
	@DataDate varchar(10) ,
	@SrcFileName [varchar](100)  ,
	--@CreatedDate [datetime]  ,
	@CreatedBy [varchar](50)  ,
	--[LastUpdatedDate [datetime] NOT ,
	@LastUpdatedBy [varchar](50) ,
	@MSH2_EncodingCharacter [varchar](4) ,
	@MSH3_SendingApp [varchar](180) ,
	@MSH4_SendingFacility [varchar](180) ,
	@MSH5_ReceivingApp [varchar](180) ,
	@MSH6_ReceivingFacility [varchar](200) ,
	@MSH7_MagDateTime [varchar](26) ,
	@MSH8_Security [varchar](40) ,
	@MSH9_MessageType [varchar](10) ,
	@MSH10_MessageControlID [varchar](200) ,
	@MSH11_ProcessingID [varchar](3) ,
	@MSH12_HL7Version [varchar](60) ,
	@MSH13_SequenceNumber [varchar](15) ,
	@MSH14_ContinuationPointer [varchar](180) ,
	@MSH15_AcceptAckType [varchar](2) ,
	@MSH16_ApplicationaAckType [varchar](2) ,
	@MSH17_CountryCode [varchar](2) ,
	@MSH18_CharacterSet [varchar](6) ,
	@MSH19_PrincipleLanMsg [varchar](60)  ,
	@MSH9_TriggerEvent VARCHAR(5),
	@MSH9_MsgCode VARCHAR(5)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [DEV_ACECAREDW].[adi].[ImportHL7_ORU_MSH]
	@MSH0_SegIndef ,
	@MSH1_FieldDelim  ,
	@LoadDate  ,
	@DataDate  ,
	@SrcFileName   ,
	--@CreatedDate [datetime]  ,
	@CreatedBy   ,
	--[LastUpdatedDate [datetime] NOT ,
	@LastUpdatedBy  ,
	@MSH2_EncodingCharacter  ,
	@MSH3_SendingApp  ,
	@MSH4_SendingFacility  ,
	@MSH5_ReceivingApp  ,
	@MSH6_ReceivingFacility  ,
	@MSH7_MagDateTime  ,
	@MSH8_Security  ,
	@MSH9_MessageType  ,
	@MSH10_MessageControlID  ,
	@MSH11_ProcessingID  ,
	@MSH12_HL7Version  ,
	@MSH13_SequenceNumber  ,
	@MSH14_ContinuationPointer  ,
	@MSH15_AcceptAckType  ,
	@MSH16_ApplicationaAckType  ,
	@MSH17_CountryCode  ,
	@MSH18_CharacterSet  ,
	@MSH19_PrincipleLanMsg  ,
    @MSH9_TriggerEvent,
	@MSH9_MsgCode 

END
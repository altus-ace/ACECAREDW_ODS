-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORC to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportHL7_ORU_R01_ORC]  
    @ORC0_SegmentType [varchar](3) ,
	@ORC1_OrderCrl_ID [varchar](2),
	--[LoadDate] [date] NOT NULL,
	@DataDate varchar(10),
	@SrcFileName [varchar](100) ,
	--[CreatedDate] [datetime] ,
	@CreatedBy [varchar](50) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@ORC2_PlacerOrderNumber [varchar](427) ,
	@ORC3_FillerOrderNumber [varchar](427),
	@ORC4_PlacerGroupNumber [varchar](22) ,
	@ORC5_OrderStatus [varchar](3) ,
	@ORC6_ResponseFlag [varchar](3) ,
	@MSH10_MessageControlID [varchar](200) ,
	@ORC9_Tran_DateTime varchar(50),
	@ORC12_OrderingProvider_ID [varchar](50),
	@ORC12_OrderingProvider_LastName [varchar](50),
	@ORC12_OrderingProvider_FirstName [varchar](50) ,
	@ORC12_OrderingProvider_ID_Type [varchar](50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	EXEC [DEV_ACECAREDW].[adi].[ImportHL7_ORU_ORC]
	@ORC0_SegmentType ,
	@ORC1_OrderCrl_ID ,
	--[LoadDate] [date] NOT NULL,
	@DataDate ,
	@SrcFileName ,
	--[CreatedDate] [datetime] ,
	@CreatedBy ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy  ,
	@ORC2_PlacerOrderNumber ,
	@ORC3_FillerOrderNumber ,
	@ORC4_PlacerGroupNumber ,
	@ORC5_OrderStatus  ,
	@ORC6_ResponseFlag ,
	@MSH10_MessageControlID ,
	@ORC9_Tran_DateTime,
	@ORC12_OrderingProvider_ID ,
	@ORC12_OrderingProvider_LastName ,
	@ORC12_OrderingProvider_FirstName ,
	@ORC12_OrderingProvider_ID_Type 
	
END


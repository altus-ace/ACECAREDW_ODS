-- =============================================
-- Author:		Bing Yu
-- Create date: 12/29/2020
-- Description:	Insert HL7 ORU to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportHL7_ORU_R01_NTE]  
   	@NTE0_SegmentType [varchar](3) ,
	@NTE1_SequenceNum [varchar](6) ,
--	@LoadDate varchar(10)  ,
	@DataDate varchar(10),
	@SrcFileName [varchar](100)  ,
--	@CreatedDate [datetime]  ,
	@CreatedBy [varchar](50)  ,
--	@LastUpdatedDate [datetime]  ,
	@LastUpdatedBy [varchar](50)  ,
	@NTE2_Commentsource [varchar](50) ,
	@NTE3_Comment [varchar](50) ,
	@MSH10_MessageControlID varchar(50)
          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [DEV_ACECAREDW].[adi].[ImportHL7_ORU_NTE]
	@NTE0_SegmentType  ,
	@NTE1_SequenceNum  ,
--	@LoadDate varchar(10)  ,
	@DataDate ,
	@SrcFileName   ,
--	@CreatedDate [datetime]  ,
	@CreatedBy   ,
--	@LastUpdatedDate [datetime]  ,
	@LastUpdatedBy   ,
	@NTE2_Commentsource  ,
	@NTE3_Comment  ,
	@MSH10_MessageControlID
          
	
END


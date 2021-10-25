

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroupProvdrGroup_MemberSummary]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
	@MeasurementYear varchar(20) ,
	@DateAsOf varchar(12) ,
	@PCPTin varchar(20) ,
	@PCPTinName varchar(50) ,
	@PCPId varchar(20) ,
	@PCPName varchar(50) ,
	@MemberId varchar(20) ,
	@MedicaidId varchar(50) ,
	@MemberName varchar(50) ,
	@PlanCode varchar(20) ,
	@MemberGroupCode varchar(20) ,
	@MemberDOB varchar(12) ,
	@MemberGender varchar(10) ,
	@MemberAddress1 varchar(100) ,
	@MemberCity varchar(50) ,
	@MemberState varchar(20) ,
	@MemberZip varchar(20) ,
	@MemberCounty varchar(20) ,
	@ClassificationDate varchar(12) ,
	@Date1 varchar(12) ,
	@Measure varchar(50) ,
	@Sub_Measure varchar(50) ,
	@W30VisitCount varchar(10) ,
	@HbA1cTest varchar(10) ,
	@HbA1cResult varchar(10) ,
	@LastHbA1cValue varchar(10), 
	@FocusMeasure varchar(20) ,
	@Status varchar(50) 

            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroupProvdrGroup_MemberSummary]
	@OriginalFileName    ,
	@SrcFileName    ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate  , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
	@MeasurementYear  ,
	@DateAsOf  ,
	@PCPTin  ,
	@PCPTinName  ,
	@PCPId  ,
	@PCPName  ,
	@MemberId  ,
	@MedicaidId  ,
	@MemberName  ,
	@PlanCode  ,
	@MemberGroupCode  ,
	@MemberDOB  ,
	@MemberGender  ,
	@MemberAddress1  ,
	@MemberCity  ,
	@MemberState  ,
	@MemberZip  ,
	@MemberCounty  ,
	@ClassificationDate  ,
	@Date1  ,
	@Measure  ,
	@Sub_Measure  ,
	@W30VisitCount  ,
	@HbA1cTest  ,
	@HbA1cResult  ,
	@LastHbA1cValue , 
	@FocusMeasure  ,
	@Status  

END





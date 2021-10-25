
-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert Hospital Census file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_StarsMeasureStatus]
 @ReportDate varchar(10) ,
    @PatientName VARCHAR(50)  ,
    @PatientID VARCHAR(50)  ,
    @PatientDob varchar(10) ,
    @PatientPhone VARCHAR(12)  ,
    @PatientMobilePhone VARCHAR(12)  ,
    @PcpName VARCHAR(50)  ,
    @PcpNPI VARCHAR(20)  ,
    @PcpPracticeName VARCHAR(50)  ,
    @PCPAddress VARCHAR(100)  ,
    @PCPPhone VARCHAR(12)  ,
    @PcpTIN VARCHAR(12)  ,
    @PcpTINName VARCHAR(100)  ,
    @MeasureName varchar(50) ,
    @MeasureType varchar(50) ,
    @MeasureWeight varchar(50) ,
    @MeasureUnitType varchar(50) ,
    @MeasureCompliance varchar(50) ,
    @MemberWeight varchar(50) ,
	@SrcFileName varchar(100)  ,
	@FileDate varchar(10)  ,
--	[CreateDate datetime]  ,
	@CreateBy varchar(100)  ,
	@OriginalFileName varchar(100)  ,
	@LastUpdatedBy varchar(100)  ,
	--@LastUpdatedDate datetime]  ,
	@DataDate varchar(10)
   
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [ACDW_CLMS_DHTX].[adi].[ImportDHTX_StarsMeasureStatus]
	@ReportDate  ,
    @PatientName   ,
    @PatientID   ,
    @PatientDob  ,
    @PatientPhone   ,
    @PatientMobilePhone   ,
    @PcpName   ,
    @PcpNPI   ,
    @PcpPracticeName   ,
    @PCPAddress   ,
    @PCPPhone  ,
    @PcpTIN  ,
    @PcpTINName   ,
    @MeasureName  ,
    @MeasureType  ,
    @MeasureWeight  ,
    @MeasureUnitType  ,
    @MeasureCompliance  ,
    @MemberWeight  ,
	@SrcFileName   ,
	@FileDate   ,
--	[CreateDate datetime]  ,
	@CreateBy   ,
	@OriginalFileName   ,
	@LastUpdatedBy   ,
	--@LastUpdatedDate datetime]  ,
	@DataDate 
   

END





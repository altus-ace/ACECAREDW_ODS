-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_StarsActionableGapReport]
    @ReportDate VARCHAR(10),
    @PatientName VARCHAR(50) ,
    @PatientID VARCHAR(20) ,
    @PatientDob VARCHAR(10),
    @PatientPhone VARCHAR(12) ,
    @PatientMobilePhone VARCHAR(12),
    @PcpName VARCHAR(50),
    @PcpNPI VARCHAR(12) ,
    @PcpPracticeName VARCHAR(50),
    @PCPAddress VARCHAR(100) ,
    @PCPPhone VARCHAR(12),
    @PcpTIN VARCHAR(12),
    @PcpTINName VARCHAR(50),
    @GapMeasureName VARCHAR(50) ,
    @GapMeasureType VARCHAR(50),
    @GapAction VARCHAR(50),
    @GapMeasureDetails VARCHAR(100),
    @NumberOfMemberGaps VARCHAR(10) ,
	@SrcFileName [varchar](100),
	@FileDate varchar(10),
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [ACDW_CLMS_DHTX].[adi].[ImportDHTX_StarsActionableGapReport]

    @ReportDate ,
    @PatientName  ,
    @PatientID  ,
    @PatientDob ,
    @PatientPhone  ,
    @PatientMobilePhone ,
    @PcpName ,
    @PcpNPI  ,
    @PcpPracticeName ,
    @PCPAddress  ,
    @PCPPhone ,
    @PcpTIN ,
    @PcpTINName ,
    @GapMeasureName  ,
    @GapMeasureType ,
    @GapAction ,
    @GapMeasureDetails ,
    @NumberOfMemberGaps  ,
	@SrcFileName ,
	@FileDate ,
	--[CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy  ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate 


END


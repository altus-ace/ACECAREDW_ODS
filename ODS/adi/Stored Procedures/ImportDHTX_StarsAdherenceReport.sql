-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_StarsAdherenceReport]
    @ReportDate varchar (10) ,
	@PatientName varchar (100) ,
	@PatientID varchar (100) ,
	@PatientDob varchar(10) ,
	@PatientPhone varchar (12) ,
	@PatientMobilePhone [varchar](12) ,
	@PcpName [varchar](100) ,
	@PcpNPI [varchar](12) ,
	@PcpPracticeName [varchar](100) ,
	@PCPAddress [varchar](100) ,
	@PCPPhone [varchar](15) ,
	@PcpTIN [varchar](12) ,
	@PcpTINName [varchar](100) ,
	@Category [varchar](100) ,
	@SrcFileName [varchar](100) ,
	@FileDate [date] ,
	--[CreateDate] [datetime] ,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100) ,
	@LastUpdatedBy [varchar](100) ,
--	[LastUpdatedDate] [datetime] ,
	@DataDate varchar(10)
	
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_DHTX].[adi].[ImportStarsAdherenceReport]
	 @ReportDate  ,
	@PatientName  ,
	@PatientID ,
	@PatientDob  ,
	@PatientPhone  ,
	@PatientMobilePhone  ,
	@PcpName  ,
	@PcpNPI  ,
	@PcpPracticeName  ,
	@PCPAddress  ,
	@PCPPhone  ,
	@PcpTIN  ,
	@PcpTINName  ,
	@Category  ,
	@SrcFileName  ,
	@FileDate ,
	--[CreateDate] [datetime] ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy  ,
--	[LastUpdatedDate] [datetime] ,
	@DataDate 
	

END


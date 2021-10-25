
-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportPCPVisit]
    @ReportDate VARCHAR(10),
	@MemberID [varchar](50) ,
	@MemberFirstName [varchar](50),
	@MemberLastName [varchar](50),
	@MemberDOB VARCHAR(10),
	@PcpFirstName [varchar](50),
	@PcpLastName [varchar](50),
	@PcpNpi [varchar](20),
	@PcpTIN [varchar](20),
	@PcpAddress [varchar](100) ,
	@PcpPracticeName [varchar](50),
	@ComprehensiveVisitInYear varchar(10) ,
	@LastComprehensiveVisitDate varchar(10),
	@PcpVisitInLast3Months varchar(10),
	@PcpVisitInYear varchar(10),
	@LastPcpVisitDate VARCHAR(10),
	@LastPcpVisitFirstName [varchar](50),
	@LastPcpVisitLastName [varchar](50),
	@LastPcpVisitNPI [varchar](20) ,
	@LastPcpVisitDiagnoses [varchar](50),
    @MemberAddress [varchar](100) ,
	@MemberPhone [varchar](12) ,
	@PcpPhone [varchar](12) ,
	@PcpTinName [varchar](100) ,
	@MemberMobilePhone [varchar](12),
 	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	@DataDate varchar(10),
	--@CreateDate  ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100)
--	@LastUpdatedDate varchar(100)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    EXEC [ACDW_CLMS_DHTX].[adi].[ImportPCPVisit]
	@ReportDate ,
	@MemberID ,
	@MemberFirstName ,
	@MemberLastName ,
	@MemberDOB ,
	@PcpFirstName ,
	@PcpLastName ,
	@PcpNpi ,
	@PcpTIN ,
	@PcpAddress  ,
	@PcpPracticeName ,
	@ComprehensiveVisitInYear ,
	@LastComprehensiveVisitDate ,
	@PcpVisitInLast3Months ,
	@PcpVisitInYear ,
	@LastPcpVisitDate ,
	@LastPcpVisitFirstName ,
	@LastPcpVisitLastName ,
	@LastPcpVisitNPI ,
	@LastPcpVisitDiagnoses ,
	 @MemberAddress ,
	@MemberPhone  ,
	@PcpPhone  ,
	@PcpTinName ,
	@MemberMobilePhone ,
 	@SrcFileName  ,
	@FileDate ,
	@DataDate ,
	--@CreateDate  ,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy 
--	@LastUpdatedDate varchar(100)
END



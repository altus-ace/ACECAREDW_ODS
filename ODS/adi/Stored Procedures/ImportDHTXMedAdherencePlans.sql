-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTXMedAdherencePlans]
 
	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	@DataDate varchar(10),
	--@CreateDate  ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100),
	--@LastUpdatedDate varchar(100),
    @ReportDate varchar(10),
	@PatientName [varchar](50),
	@PatientID [varchar](100),
	@PatientDob varCHAR(10),
	@PatientPhone [varchar](12),
	@PatientMobilePhone [varchar](12),
	@PcpName [varchar](50),
	@PcpNpi [varchar](10),
	@Practice [varchar](50),
	@PcpTIN [varchar](10) ,
	@MedicationAdherenceCategory [varchar](50),
	@MemberStatus [varchar](100) ,
	@Needs90DaySupply [char](1) ,
	@NextFillDueDate VARCHAR(10),
	@LastFilledMedication [varchar](50),
	@LastFillDate VARCHAR(10),
	@LastFillDaysSupply varchar(5),
	@RefillsLeft varchar(5),
	@DaysUntilGNA varchar(5),
	@DaysMissedInYear varchar(5) ,
	@PDC VARCHAR(10),
	@FirstFillDate VARCHAR(10),
	@NumberOfFills varchar(5),
	@PrescriberName [varchar](50),
	@PrescriberPhoneNumber [varchar](10) ,
	@PharmacyName [varchar](50) ,
	@PharmacyPhoneNumber [varchar](10),
	@PharmacyAddress [varchar](100),
	@DevotedPharmacyTeamNote [varchar](500)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_DHTX].[adi].[ImportMedAdherencePlans]
    @SrcFileName ,
	@FileDate  ,
	@DataDate ,
	--@CreateDate  ,
	@CreateBy ,
	@OriginalFileName  ,
	@LastUpdatedBy ,
--	@LastUpdatedDate ,
    @ReportDate ,
	@PatientName ,
	@PatientID ,
	@PatientDob ,
	@PatientPhone ,
	@PatientMobilePhone ,
	@PcpName ,
	@PcpNpi ,
	@Practice ,
	@PcpTIN  ,
	@MedicationAdherenceCategory ,
	@MemberStatus ,
	@Needs90DaySupply  ,
	@NextFillDueDate ,
	@LastFilledMedication ,
	@LastFillDate ,
	@LastFillDaysSupply ,
	@RefillsLeft  ,
	@DaysUntilGNA ,
	@DaysMissedInYear ,
	@PDC ,
	@FirstFillDate ,
	@NumberOfFills ,
	@PrescriberName ,
	@PrescriberPhoneNumber ,
	@PharmacyName  ,
	@PharmacyPhoneNumber ,
	@PharmacyAddress ,
	@DevotedPharmacyTeamNote 
END


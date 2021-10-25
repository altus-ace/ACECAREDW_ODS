
-- =============================================
-- Author:		Bing Yu
-- Create date: 11/21/2019
-- Description:	Insert UHC EfficiencyEvalbyPcp file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportUHC_EfficiencyEvalbyPcp]
    @SrcFileName varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LoadDate varchar(10)  ,
	@DataDate varchar(10)  ,
	--[CreatedDate dateti,
	@CreatedBy varchar(50),
	--[LastUpdatedDate datetime   ,
	@LastUpdatedBy varchar(50)  ,
	@PCPName VARCHAR(50) ,
    @MemberMonths VARCHAR(10) ,
    @ProspectiveRisk varchar(10) ,
    @Iptnt varchar(10) ,
    @Optnt varchar(10) ,
    @Physn varchar(10),
    @Pharm varchar(10),
    @Total varchar(10),
    @ERVisitsDivBy1000 varchar(10) ,
    @AcuteAdmitsDivBy1000 varchar(10) ,
    @AcuteDaysDivBy1000 varchar(10),
    @ALOS varchar(10),
    @PctSpecVstsNonpar varchar(10) ,
    @RXGenericCompliance varchar(10) ,
    @PctPhysVisitsSpecialists varchar(10) ,
    @PctAcuteAdmitsToACOFacility varchar(10) ,
    @PctSpecVisitsToACOSpecialist varchar(10) ,
    @ToDate varchar(10) ,
    @FromDate varchar(10) 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_UHC].[adi].[ImportUHC_EfficiencyEvalbyPcp]
	@SrcFileName   ,
	@OriginalFileName   ,
	@LoadDate    ,
	@DataDate    ,
	--[CreatedDate dateti,
	@CreatedBy ,
	--[LastUpdatedDate datetime   ,
	@LastUpdatedBy   ,
	@PCPName ,
    @MemberMonths   ,
    @ProspectiveRisk   ,
    @Iptnt   ,
    @Optnt   ,
    @Physn  ,
    @Pharm  ,
    @Total  ,
    @ERVisitsDivBy1000   ,
    @AcuteAdmitsDivBy1000   ,
    @AcuteDaysDivBy1000  ,
    @ALOS  ,
    @PctSpecVstsNonpar   ,
    @RXGenericCompliance   ,
    @PctPhysVisitsSpecialists   ,
    @PctAcuteAdmitsToACOFacility   ,
    @PctSpecVisitsToACOSpecialist   ,
    @ToDate   ,
    @FromDate 

END	


-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBSMemberCrosswalk]
    
	@SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100) ,
	@LastUpdatedBy [varchar](100),
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@PatientID varchar(50),
	@SubscriberID [varchar](30) ,
	@MemberFirstName [varchar](35) ,
	@MemberMiddle [varchar](35),
	@MemberLastName [varchar](35),
	@MemberDateBirth varchar(10),
	@MemberGender [char](1),
	@MemberGenderDescription [varchar](8),
	@MemberLast4SSNdigits [char](4),
	@ExtractID [char](14),
	@MemberOriginalEffectiveDate varchar(10),
	@Indicator834 [char](1),
	@RiskScore varchar(10),
	@OpportunityScore varchar(10),
	@HealthStatus [varchar](20),
	@AssignmentIndicator [char](3) ,
	@ProgramIndicator [char](10),
	@PriorPatientID [varchar](18) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [ACDW_CLMS_SHCN_BCBS].[adi].[ImportBCBSMemberCrosswalk]

	@SrcFileName ,
	--[CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName,
	@LastUpdatedBy ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate ,
	@PatientID ,
	@SubscriberID  ,
	@MemberFirstName  ,
	@MemberMiddle ,
	@MemberLastName,
	@MemberDateBirth ,
	@MemberGender ,
	@MemberGenderDescription ,
	@MemberLast4SSNdigits,
	@ExtractID ,
	@MemberOriginalEffectiveDate ,
	@Indicator834 ,
	@RiskScore ,
	@OpportunityScore ,
	@HealthStatus,
	@AssignmentIndicator  ,
	@ProgramIndicator ,
	@PriorPatientID
    
END


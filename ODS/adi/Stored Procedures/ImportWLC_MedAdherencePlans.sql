
-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert Wellcare IPACLM Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportWLC_MedAdherencePlans]
    
	@SrcFileName [varchar](100),
	@FileDate varchar(10),
--	[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100),
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100),
	--[LastUpdatedDate] [datetime] ,
	@DataDate varchar(10),
	@LOBName [varchar](50),
	@ProviderID [varchar](50),
	@ProviderName [varchar](100) ,
	@MemberName [varchar](100),
	@Subscriber [varchar](50) ,
	@DateofBirth varchar(10),
	@Phone1 [varchar](12) ,
	@Phone2 [varchar](12) ,
	@Phone3 [varchar](12),
	@STARFlag [char](1),
	@P4QFlag [char](1) ,
	@Measure [varchar](50),
	@ComplianceStatus [varchar](50),
	@ComplianceDetail [varchar](100),
	@LastKnownServiceDate varchar(10),
	@ServiceStartDate varchar(10),
	@ServiceEndDate varchar(10),
	@EligibilityThruDate varchar(10),
	@ComplianceThruDate varchar(10)

            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_WLC].[adi].[ImportWLC_MedAdherencePlans]

	@SrcFileName ,
	@FileDate ,
--	[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy,
	--[LastUpdatedDate] [datetime] ,
	@DataDate ,
	@LOBName ,
	@ProviderID ,
	@ProviderName  ,
	@MemberName ,
	@Subscriber  ,
	@DateofBirth ,
	@Phone1  ,
	@Phone2  ,
	@Phone3 ,
	@STARFlag ,
	@P4QFlag  ,
	@Measure ,
	@ComplianceStatus ,
	@ComplianceDetail ,
	@LastKnownServiceDate ,
	@ServiceStartDate ,
	@ServiceEndDate ,
	@EligibilityThruDate ,
	@ComplianceThruDate 


END
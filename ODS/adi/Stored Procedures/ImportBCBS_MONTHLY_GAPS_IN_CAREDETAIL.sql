﻿-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBS_MONTHLY_GAPS_IN_CAREDETAIL]
    @SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] ,
	@CreateBy [varchar](100) NULL,
	@OriginalFileName [varchar](100) ,
	@LastUpdatedBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10) NULL,
	@MeasureName [varchar](100),
	@IncludedInNumerator [varchar](10) ,
	@Exclusion [varchar](100),
	@DateTest varchar(10),
	@Lab_Test [varchar](100) ,
	@Test_Result [varchar](100),
	@SubscriberID [varchar](50) ,
	@PatientID [varchar](50) ,
	@MemberLastName [varchar](50) ,
	@MemberFirstName [varchar](50) ,
	@MemberDOB varchar(10),
	@MemberGender [varchar](10),
	@CurrentAttributed_PCP_NPI [varchar](20) ,
	@CurrentPCPLastName [varchar](50) ,
	@CurrentPCPFirstName [varchar](50) ,
	@ProgramIndicator [varchar](10)

            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_SHCN_BCBS].[adi].[ImportBCBS_MONTHLY_GAPS_IN_CAREDETAIL]
	 @SrcFileName ,
	--[CreateDate] [datetime] ,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy  ,
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate ,
	@MeasureName ,
	@IncludedInNumerator ,
	@Exclusion ,
	@DateTest ,
	@Lab_Test  ,
	@Test_Result ,
	@SubscriberID  ,
	@PatientID  ,
	@MemberLastName  ,
	@MemberFirstName  ,
	@MemberDOB ,
	@MemberGender ,
	@CurrentAttributed_PCP_NPI  ,
	@CurrentPCPLastName  ,
	@CurrentPCPFirstName  ,
	@ProgramIndicator 
    
END

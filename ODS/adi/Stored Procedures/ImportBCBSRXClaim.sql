-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBSRXClaim]
    @SrcFileName [varchar](100),
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@ExtractID [varchar](14),
	@ClaimStatusCode [varchar](2),
	@ProviderNPI [varchar](10),
	@ServiceDATE varchar(10),
	@PatientID varchar(50),
	@MemberBirthDate varchar(10),
	@MemberGender [char](1),
	@MemberFirstName [varchar](35),
	@MemberLastName [varchar](35) ,
	@MemberHomeAddress1 [varchar](55),
	@MemberCityName [varchar](28) ,
	@MemberStateCode [varchar](2) ,
	@MemberZipCode [varchar](5),
	@MemberPrimaryPhone [varchar](10),
	@SubscriberID [varchar](12) ,
	@ClaimID [varchar](30),
	@NDCCode [varchar](14),
	@RxID [varchar](15),
	@FillDate varchar(10),
	@NumberofServiceS [varchar](5) ,
	@NumberofScriptsDispensed [varchar](2),
	@DaysSupply [varchar](4),
	@PaidDate varchar(10),
	@BrandGenericIndicator [char](1),
	@AdjustmentSequenceNumber [varchar](4) ,
	@ClaimLineNumber [char](4),
	@TherapeuticClassCode [char](2),
	@ProviderLastName [varchar](35),
	@ProviderPhoneNumber [varchar](10),
	@ProviderTIN [varchar](9) ,
	@PracticeName [varchar](30) ,
	@ProviderFirstName [varchar](30) ,
	@ProviderStreetAddress1 [varchar](30) ,
	@ProviderCity [varchar](15) NULL,
	@ProviderState [char](2) NULL,
	@ProviderZipCode [char](5) ,
	@DrugFormulation [char](2) ,
	@AWPAmount [varchar](9) 
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_SHCN_BCBS].[adi].[ImportBCBSRXClaim]
	 
       @SrcFileName ,
	-- [CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName,
	@LastUpdatedBy  ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate ,
	@ExtractID ,
	@ClaimStatusCode ,
	@ProviderNPI ,
	@ServiceDATE ,
	@PatientID ,
	@MemberBirthDate ,
	@MemberGender ,
	@MemberFirstName ,
	@MemberLastName  ,
	@MemberHomeAddress1 ,
	@MemberCityName  ,
	@MemberStateCode  ,
	@MemberZipCode ,
	@MemberPrimaryPhone ,
	@SubscriberID  ,
	@ClaimID ,
	@NDCCode ,
	@RxID ,
	@FillDate ,
	@NumberofServiceS  ,
	@NumberofScriptsDispensed ,
	@DaysSupply ,
	@PaidDate ,
	@BrandGenericIndicator ,
	@AdjustmentSequenceNumber  ,
	@ClaimLineNumber ,
	@TherapeuticClassCode ,
	@ProviderLastName ,
	@ProviderPhoneNumber,
	@ProviderTIN ,
	@PracticeName  ,
	@ProviderFirstName  ,
	@ProviderStreetAddress1 ,
	@ProviderCity ,
	@ProviderState ,
	@ProviderZipCode  ,
	@DrugFormulation  ,
	@AWPAmount
    
    
END

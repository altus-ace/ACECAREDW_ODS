-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[ImportNPPES_NPI](
    @srcFileName [varchar](100),
	@DataDate varchar(10),
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50) ,
	--@LastUpdatedDate [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@NPI varchar(20) ,
	@EntityType [varchar](20) ,
	@EIN [varchar](50) ,
	@LBN [varchar](100) ,
	@LBN_Name [varchar](200),
	@LastName [varchar](100) ,
	@FirstName [varchar](100) ,
	@PracticeAddress1 [varchar](100) ,
	@PracticeAddress2 [varchar](50) ,
	@PracticeCity [varchar](100) ,
	@PracticeState [varchar](50) ,
	@PracticeZip [varchar](10) ,
	@PracticePhone [varchar](20) ,
	@PracticeFax [varchar](20) ,
	@PracticeLastUpdate [varchar](20) ,
	@Taxonomy1 [varchar](50) ,
	@Taxonomy2 [varchar](50) ,
	@Taxonomy3 [varchar](50), 

	@Active [char](1),
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@OtherProviderIdentifier_1 [varchar](50) ,
	@OtherProviderIdentifierTypeCode_1 [varchar](50) ,
	@OtherProviderIdentifierState_1 [varchar](50) ,
	@OtherProviderIdentifierIssuer_1 [varchar](50) ,
	@OtherProviderIdentifier_2 [varchar](50) ,
	@OtherProviderIdentifierTypeCode_2 [varchar](50) ,
	@OtherProviderIdentifierState_2 [varchar](50) ,
	@OtherProviderIdentifierIssuer_2 [varchar](50) ,
	@OtherProviderIdentifier_3 [varchar](50) ,
	@OtherProviderIdentifierTypeCode_3 [varchar](50) ,
	@OtherProviderIdentifierState_3 [varchar](50) ,
	@OtherProviderIdentifierIssuer_3 [varchar](50) ,
	@OtherProviderIdentifier_4 [varchar](50) ,
	@OtherProviderIdentifierTypeCode_4 [varchar](50) ,
	@OtherProviderIdentifierState_4 [varchar](50) ,
	@OtherProviderIdentifierIssuer_4 [varchar](50) ,
	@OtherProviderIdentifier_5 [varchar](50) ,
	@OtherProviderIdentifierTypeCode_5 [varchar](50) ,
	@OtherProviderIdentifierState_5 [varchar](50) ,
	@OtherProviderIdentifierIssuer_5 [varchar](50) ,
	@IsSoleProprietor [char](1),
	@IsOrganizationSubpart [char](1),
	@ParentOrganizationLBN [varchar](50),
	@ParentOrganizationTIN [varchar](20),
	@CertificationDate varchar(10)

)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  
    EXEC [AceMasterData].[lst].[ImportNPPES_NPI]    
	  @srcFileName ,
	@DataDate ,
	--[CreatedDate] [datetime] NOT NULL,
	@CreatedBy  ,
	--@LastUpdatedDate [datetime] NOT NULL,
	@LastUpdatedBy  ,
	@NPI  ,
	@EntityType ,
	@EIN ,
	@LBN  ,
	@LBN_Name ,
	@LastName ,
	@FirstName  ,
	@PracticeAddress1  ,
	@PracticeAddress2 ,
	@PracticeCity  ,
	@PracticeState ,
	@PracticeZip ,
	@PracticePhone  ,
	@PracticeFax  ,
	@PracticeLastUpdate  ,
	@Taxonomy1 ,
	@Taxonomy2 ,
	@Taxonomy3 , 

	@Active ,
	@EffectiveDate ,
	@ExpirationDate ,
	@OtherProviderIdentifier_1 ,
	@OtherProviderIdentifierTypeCode_1 ,
	@OtherProviderIdentifierState_1  ,
	@OtherProviderIdentifierIssuer_1 ,
	@OtherProviderIdentifier_2 ,
	@OtherProviderIdentifierTypeCode_2 ,
	@OtherProviderIdentifierState_2 ,
	@OtherProviderIdentifierIssuer_2 ,
	@OtherProviderIdentifier_3  ,
	@OtherProviderIdentifierTypeCode_3 ,
	@OtherProviderIdentifierState_3  ,
	@OtherProviderIdentifierIssuer_3 ,
	@OtherProviderIdentifier_4  ,
	@OtherProviderIdentifierTypeCode_4 ,
	@OtherProviderIdentifierState_4  ,
	@OtherProviderIdentifierIssuer_4 ,
	@OtherProviderIdentifier_5 ,
	@OtherProviderIdentifierTypeCode_5 ,
	@OtherProviderIdentifierState_5 ,
	@OtherProviderIdentifierIssuer_5  ,
	@IsSoleProprietor ,
	@IsOrganizationSubpart ,
	@ParentOrganizationLBN ,
	@ParentOrganizationTIN ,
	@CertificationDate 
	  
	
END



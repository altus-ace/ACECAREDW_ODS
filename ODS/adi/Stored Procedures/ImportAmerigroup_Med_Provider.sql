



-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_Med_Provider]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
    @PROV_LCNS_ID  varchar(25) ,
	@MedicareID_Could_Contain_SSN  varchar(20) ,
	@Provider_Tax_ID  varchar(16) ,
	@LicensureCode  varchar(50) ,
	@ProviderLastName  varchar(70) ,
	@ProviderFirstName  varchar(40) ,
	@ProviderSpecialty  varchar(50) ,
	@AddressLine1  varchar(100) ,
	@AddressLine2  varchar(100) ,
	@ProviderCity  varchar(50) ,
	@ProviderState  varchar(3) ,
	@ProviderZipCode  varchar(6) ,
	@ProviderPhone  varchar(50) ,
	@DEANum  varchar(25) ,
	@NPI  varchar(25) ,
	@TaxonomyCode  varchar(10) ,
	@ContractFlag1  varchar(3) ,
	@ProviderBusinessName_GroupName  varchar(70) ,
	@REDACTFLAG  varchar(1) ,
	@PG_ID  varchar(32) ,
	@PG_NAME  varchar(150) 
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_Med_Provider]
	  @OriginalFileName    ,
	@SrcFileName   ,
	@LoadDate ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate , 
	@CreatedBy   ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
    @PROV_LCNS_ID   ,
	@MedicareID_Could_Contain_SSN  ,
	@Provider_Tax_ID   ,
	@LicensureCode  ,
	@ProviderLastName   ,
	@ProviderFirstName   ,
	@ProviderSpecialty   ,
	@AddressLine1   ,
	@AddressLine2  ,
	@ProviderCity  ,
	@ProviderState   ,
	@ProviderZipCode   ,
	@ProviderPhone  ,
	@DEANum   ,
	@NPI   ,
	@TaxonomyCode   ,
	@ContractFlag1  ,
	@ProviderBusinessName_GroupName   ,
	@REDACTFLAG   ,
	@PG_ID  ,
	@PG_NAME  
END





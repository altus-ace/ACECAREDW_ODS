

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	
-- ============================================
CREATE PROCEDURE adi.ImportAmerigroup_RxProvider 
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,

	@DEA_Number  varchar(25) ,
	@BillingProviderLicenseNumber  varchar(25) ,
	@PrescriberNPI  varchar(25) ,
	@ProviderFirstName  varchar(50) ,
	@ProviderLastName  varchar(70) ,
	@ProviderSpecialty  varchar(50) ,
	@TaxonomyCode  varchar(50) ,
	@REDACTFLAG  varchar(50) ,
	@PG_ID  varchar(50) ,
	@PG_NAME  varchar(50) ,
	@TO_Address_Line_1  varchar(150) ,
	@TO_ADDRESS_LINE_2  varchar(150) ,
	@City_Name  varchar(50) ,
	@State_Code  varchar(20) ,
	@Zip_Code  varchar(20) 
	
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_RxProvider]
	   @OriginalFileName    ,
	@SrcFileName    ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate ,  
	@FileDate  , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,

	@DEA_Number   ,
	@BillingProviderLicenseNumber   ,
	@PrescriberNPI  ,
	@ProviderFirstName   ,
	@ProviderLastName   ,
	@ProviderSpecialty   ,
	@TaxonomyCode   ,
	@REDACTFLAG  ,
	@PG_ID   ,
	@PG_NAME  ,
	@TO_Address_Line_1   ,
	@TO_ADDRESS_LINE_2  ,
	@City_Name   ,
	@State_Code  ,
	@Zip_Code  
	
  

END





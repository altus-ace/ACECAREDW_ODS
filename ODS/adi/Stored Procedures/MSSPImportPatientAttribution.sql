-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[MSSPImportPatientAttribution]
    @SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] ,
	@CreateBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](100) ,
	@DataDate varchar(10) ,
	@MBI_ID [varchar](50),
	@PatientFirstName [varchar](50) ,
	@PatientLastName [varchar](50) ,
	@DOB VARCHAR(10),
	@Sex [varchar](10) ,
	@AttributedNPI [varchar](50) ,
	@ProviderName [varchar](50) ,
	@HCCRiskScore varchar(10) ,
	@NEW_2021_Patient [varchar](10) ,
	@Patient_AWV_Last_12Month varchar(10) ,
	@UnplannedIPVisit_12Month varchar(10),
	@PatientIdentified_High_Risk [varchar](10) ,
	@PatientDiagnosedDiabetes [varchar](10) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPatientAttribution]
    
	@SrcFileName  ,
	--[CreateDate] [datetime] ,
	@CreateBy  ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy  ,
	@DataDate ,
	@MBI_ID ,
	@PatientFirstName  ,
	@PatientLastName  ,
	@DOB ,
	@Sex  ,
	@AttributedNPI  ,
	@ProviderName  ,
	@HCCRiskScore  ,
	@NEW_2021_Patient  ,
	@Patient_AWV_Last_12Month  ,
	@UnplannedIPVisit_12Month  ,
	@PatientIdentified_High_Risk  ,
	@PatientDiagnosedDiabetes    
   

 END

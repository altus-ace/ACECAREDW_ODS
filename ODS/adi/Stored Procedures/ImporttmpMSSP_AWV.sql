-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImporttmpMSSP_AWV]
    @ProgramName VARCHAR(50) ,
	@MeasureName  VARCHAR(50),
	@ProviderName  VARCHAR(50),
	@ProviderUsername  VARCHAR(50) ,
	@NPI  VARCHAR(11) NULL,
	@PatientID  VARCHAR(50) NULL,
    @LastName  VARCHAR(50) NULL,
	@FirstName  VARCHAR(50) NULL,
	@DOBDATE varchar(10),
	@Age varchar(10),
	@Sex CHAR(1) NULL,
	@Phone varchar(20) NULL,
	@RAFScore varchar(20),
	@GAPScore varchar(20),
	@Race VARCHAR(50) NULL,
	@Ethnicity VARCHAR(50) NULL,
	@Language VARCHAR(50) NULL,
	@Department_Last_Encounter varchar(100) NULL,
	@LastEncounter varchar(100) NULL,
	@NextAppointment varchar(10),
	@ResultStatus varchar(50) NULL ,
	@Result varchar(50) NULL,
	@SatisfiedDate varchar(10),
	@SupportingDocumentation VARCHAR(100) NULL,
	@PrimaryInsurance varchar(50) NULL,
	@PrimaryInsurancePackageType varchar(50) NULL,
	@PrimaryInsurancePolicyNumber varchar(50) NULL,
	@SecondaryInsurance VARCHAR(100) NULL,
	@SecondaryInsurancePackageType VARCHAR(50) NULL,
	@SecondaryInsurancePolicyNumber VARCHAR(50) NULL,
	@DateRun varchar(10), 
	--[LoadDate] [date] NOT NULL,
	@DataDate varchar(10),
	@srcFileName [varchar](100),
	--[CreatedDate] [datetime] NULL,
	@CreatedBy [varchar](50),
	@LastUpdatedBy [varchar](100),
--	[LastUpdatedDate] [datetime] NULL,

    --- for MSSP Patient Attri
	@MBI_ID [varchar](50),
	@PatientFirstName [varchar](50) ,
	@PatientLastName [varchar](50) ,
	@DOB VARCHAR(10),
	--@Sex [varchar](10) ,
	@AttributedNPI [varchar](50) 
	--,
--	@ProviderName [varchar](50) ,
--	@HCCRiskScore varchar(10) ,
--	@NEW_2021_Patient [varchar](10) ,
--	@Patient_AWV_Last_12Month varchar(10) ,
--	@UnplannedIPVisit_12Month varchar(10) ,
--	@PatientIdentified_High_Risk [varchar](10) 
	--,
	--@PatientDiagnosedDiabetes [varchar](10) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImporttmpMSSP_AWV]

	@ProgramName ,
	@MeasureName  ,
	@ProviderName  ,
	@ProviderUsername  ,
	@NPI  ,
	@PatientID  ,
    @LastName  ,
	@FirstName  ,
	@DOBDATE ,
	@Age ,
	@Sex ,
	@Phone ,
	@RAFScore ,
	@GAPScore ,
	@Race ,
	@Ethnicity ,
	@Language ,
	@Department_Last_Encounter ,
	@LastEncounter ,
	@NextAppointment ,
	@ResultStatus ,
	@Result ,
	@SatisfiedDate ,
	@SupportingDocumentation ,
	@PrimaryInsurance ,
	@PrimaryInsurancePackageType ,
	@PrimaryInsurancePolicyNumber ,
	@SecondaryInsurance ,
	@SecondaryInsurancePackageType ,
	@SecondaryInsurancePolicyNumber ,
	@DateRun , 
	--[LoadDate] [date] NOT NULL,
	@DataDate ,
	@srcFileName ,
	--[CreatedDate] [datetime] NULL,
	@CreatedBy ,
	@LastUpdatedBy 
--	[LastUpdatedDate] [datetime] NULL,
	
	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPatientAttribution]
	 @SrcFileName  ,
	--[CreateDate] [datetime] ,
	 @CreatedBy  ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@DataDate ,
	@MBI_ID ,
	@PatientFirstName ,
	@PatientLastName ,
	@DOB ,
	@Sex ,
	@AttributedNPI  ,
	@ProviderName ,
	1.2, --@HCCRiskScore ,
	'YES',    ---@NEW_2021_Patient ,
	 '2021-01-01',  --@Patient_AWV_Last_12Month  ,
	1, ---@UnplannedIPVisit_12Month ,
	'YES',   ---@PatientIdentified_High_Risk ,
	'YES' --@PatientDiagnosedDiabetes 

END

﻿-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPRiskPopulation]
    @SrcFileName varchar(100) ,
	--[CreateDate] [datetime] NULL,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100),
	@LastUpdatedBy varchar(100),
	--LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@YearNBR varchar(4) ,
	@Region varchar(50),
	@MedicareBeneficiaryID varchar(50),
	@HealthInsuranceClaimNBR [varchar](50),
	@FirstNM varchar(50),
	@LastNM varchar(50),
	@SexCD varchar(1) ,
	@BirthDTS varchar(10) ,
	@DeathDTS varchar(10),
	@CountyNM varchar(50),
	@HomeStateCD varchar(50) ,
	@CountyNBR varchar(50) ,
	@NPIMapping varchar(50),
	@BeneLivesinTX_LA_AR varchar(1),
	@FileNM 	[varchar](50) 
            
AS
BEGIN
	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPRiskPopulation]
    @SrcFileName  ,
	--[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--LastUpdatedDate [datetime] NULL,
	@DataDate ,
	@YearNBR  ,
	@Region ,
	@MedicareBeneficiaryID ,
	@HealthInsuranceClaimNBR ,
	@FirstNM ,
	@LastNM ,
	@SexCD  ,
	@BirthDTS ,
	@DeathDTS ,
	@CountyNM ,
	@HomeStateCD ,
	@CountyNBR  ,
	@NPIMapping ,
	@BeneLivesinTX_LA_AR ,
	@FileNM 	 
END

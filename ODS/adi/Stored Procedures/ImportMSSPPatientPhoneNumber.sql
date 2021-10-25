-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportMSSPPatientPhoneNumber]
    @SrcFileName [varchar](100),
	--[CreateDate] [datetime] NOT NULL,
	@CreateBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](100),
	@DataDate varchar(10),
	@PatientPolicyidNumber [varchar](50) ,
	@PatientFirstName [varchar](50),
	@PatientLastName [varchar](50),
	@PatientHomePhone varchar(15),
	@PatientMobilePhone [varchar](15) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_SHCN_MSSP].[adi].[ImportMSSPPatientPhoneNumber]
	 @SrcFileName ,
	--[CreateDate] [datetime] NOT NULL,
	@CreateBy  ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@DataDate ,
	@PatientPolicyidNumber  ,
	@PatientFirstName ,
	@PatientLastName ,
	@PatientHomePhone ,
	@PatientMobilePhone 
   

 END

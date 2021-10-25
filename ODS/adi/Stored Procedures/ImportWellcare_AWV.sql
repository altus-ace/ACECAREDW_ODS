
-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert Wellcare IPACLM Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportWellcare_AWV]
    
	@ProvID VARCHAR(20) ,
	@PROV_FIRST_NAME [varchar](50),
	@PROV_LAST_NAME [varchar](50),
	@ProcCode [varchar](20),
	@ProcMod [varchar](20),
	@ServiceDate varchar(10),
	@SubID [varchar](20) ,
	@AA [varchar](10),
	@CPE [varchar](10),
	@MEM_FIRST_NAME [varchar](50),
	@MEM_LAST_NAME [varchar](50),
	@BirthDate varchar(10),
	@MEDICAID_NO [varchar](20),
	@MEDICARE_NO [varchar](20) ,
	@LoadDate varchar(10),
	@DataDate varchar(10),
	@srcFileName [varchar](100) ,
--	@CreatedDate] [datetime] NULL,
	@CreatedBy [varchar](50),
	@LastUpdatedBy [varchar](100)
--	@LastUpdatedDate] [datetime] NULL,


            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ADD ACE ETL AUDIT

   EXEC [ACDW_CLMS_WLC].[adi].[ImportWellcare_AWV]
   @ProvID ,
	@PROV_FIRST_NAME ,
	@PROV_LAST_NAME ,
	@ProcCode ,
	@ProcMod ,
	@ServiceDate ,
	@SubID  ,
	@AA ,
	@CPE ,
	@MEM_FIRST_NAME ,
	@MEM_LAST_NAME ,
	@BirthDate ,
	@MEDICAID_NO ,
	@MEDICARE_NO ,
	@LoadDate ,
	@DataDate ,
	@srcFileName ,
--	@CreatedDate] [datetime] NULL,
	@CreatedBy ,
	@LastUpdatedBy 
--	@LastUpdatedDate] [datetime] NULL,

END




-- =============================================
-- Author:		Bing Yu
-- Create date: 04/08/2020
-- Description:	Insert Membership to DB
-- ============================================
CREATE PROCEDURE [adi].[ImportCignaMA_ACECustomerSummary]

	@SrcFileName [varchar](100),
	--[LoadDate] [date] NOT NULL,
    @DataDate varchar(10),
	-- [CreatedDate] [datetime] NOT NULL,
	@CreatedBy [varchar](50),
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](50) ,
	@Mbr_Name VARCHAR(50) ,
	@DOB varchar(50),
	@Mbr_ID VARCHAR(50),
	@PCP_Name VARCHAR(50),
	@PCP_NPI VARCHAR(15),
	@POD VARCHAR(50),
	@Meas_Abbv VARCHAR(50),
	@Eligible CHAR(1),
	@Compliant CHAr(1)
--	[CopLoadStatus] tinyint 
  
        
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;
	--IF(LEN(@DOS_Yr) != 0 OR @DOS_Yr != 'DOS_Yr')
	--BEGIN	
   EXEC [ACDW_CLMS_CIGNA_MA].[adi].[ImportCignaMA_ACECustomerSummary]
   
	@SrcFileName ,
	--[LoadDate] [date] NOT NULL,
    @DataDate ,
	-- [CreatedDate] [datetime] NOT NULL,
	@CreatedBy ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy ,
	@Mbr_Name  ,
	@DOB ,
	@Mbr_ID ,
	@PCP_Name ,
	@PCP_NPI ,
	@POD ,
	@Meas_Abbv ,
	@Eligible ,
	@Compliant 

END




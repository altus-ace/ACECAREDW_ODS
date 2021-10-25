-- =============================================
-- Author:		Bing Yu
-- Create date: 11/21/2019
-- Description:	Insert UHC RX Alternative file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportUhcWHU]
    @DataDate varchar(10),
	@OriginalFileName varchar(100),
	@SrcFileName varchar(100),
	--[CreatedDate datetime2(7),
	@CreatedBy varchar(50),
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy varchar(50),
	
	@LOB varchar(20),
	@ProductSubGroup varchar(50),
	@SubID varchar(50),
	@Program varchar(50),
	@StartDate DATE,
	@EndDate DATE  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_UHC].[adi].[ImportUhcWHU]
	@DataDate ,
	@OriginalFileName ,
	@SrcFileName ,
	--[CreatedDate datetime2(7),
	@CreatedBy ,
	--[LastUpdatedDate] [datetime2](7) NOT NULL,
	@LastUpdatedBy ,
	
	@LOB ,
	@ProductSubGroup,
	@SubID ,
	@Program ,
	@StartDate ,
	@EndDate  
    
END
-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert ECP Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportUHC_PRVDRPCKT_NPI_Lookup]
   -- @CreatedDate datetime  ,
	@CreatedBy varchar(50)  ,
--	@LastUpdatedDate datetime  ,
	@LastUpdatedBy varchar(50)  ,
	@OriginalFileName varchar(100) ,
	@SrcFileName varchar(100) ,
	--@LoadDate varchar(10) ,
	@DataDate varchar(10),
	@NPI varchar(10) ,
	@PcpID varchar(15) ,
	@PcpName varchar(100) 
          
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_UHC].[adi].[ImportUHC_PRVDRPCKT_NPI_Lookup]
	   -- @CreatedDate datetime  ,
	@CreatedBy   ,
--	@LastUpdatedDate datetime  ,
	@LastUpdatedBy ,
	@OriginalFileName ,
	@SrcFileName  ,
	--@LoadDate  ,
	@DataDate  ,
	@NPI  ,
	@PcpID  ,
	@PcpName  
  
END


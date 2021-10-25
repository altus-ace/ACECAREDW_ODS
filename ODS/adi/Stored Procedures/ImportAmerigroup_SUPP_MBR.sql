

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroup_SUPP_MBR]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
   @MCID_MASTER_CONSUMER_ID  bigint  ,
	@PG_ID  varchar(32) ,
	@PG_Name  varchar(100) ,
	@PGM_ID  varchar(32) ,
	@Panel_ID  varchar(32) ,
	@Line_Business  varchar(32) ,
	@RiskDrivers  varchar(2000) ,
	@Condition_based_Opportunities  decimal (9, 3) ,
	@CDOIHighPriority  char(1) ,
	@NeedAnnualVisit  char(1) ,
	@LastAnnualVisit  varchar(10) ,
	@Conditions  varchar(500) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_SUPP_MBR]
	@OriginalFileName    ,
	@SrcFileName    ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate ,  
	@FileDate  , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
    @MCID_MASTER_CONSUMER_ID    ,
	@PG_ID  ,
	@PG_Name ,
	@PGM_ID   ,
	@Panel_ID  ,
	@Line_Business  ,
	@RiskDrivers   ,
	@Condition_based_Opportunities   ,
	@CDOIHighPriority ,
	@NeedAnnualVisit   ,
	@LastAnnualVisit  ,
	@Conditions  

	

END






-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert Cigna MA AWV to DB
-- ============================================
CREAtE PROCEDURE [adi].[ImportAmerigroup_MemberEligibility]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
	@MASTER_CONSUMER_ID [bigint] ,
	@EligibilityEffectiveDate varchar(10) ,
	@EligibilityEndDate varchar(10) ,
	@PG_ID [varchar](32) ,
	@PG_NAME [varchar](150) ,
	@PRDCTSL [varchar](32) ,
	@RXBNFLG [varchar](3)    
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_MemberEligibility]
	   @OriginalFileName   ,
	@SrcFileName   ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate ,  
	@FileDate  , 
	@CreatedBy   ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy   ,
	@MASTER_CONSUMER_ID  ,
	@EligibilityEffectiveDate ,
	@EligibilityEndDate  ,
	@PG_ID ,
	@PG_NAME  ,
	@PRDCTSL  ,
	@RXBNFLG    
   

END





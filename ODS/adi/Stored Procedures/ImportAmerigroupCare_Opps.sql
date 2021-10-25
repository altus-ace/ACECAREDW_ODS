

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[ImportAmerigroupCare_Opps]
    @OriginalFileName  varchar(100)  ,
	@SrcFileName  varchar(100)  ,
	@LoadDate varchar(10) ,
	--@CreatedDate  
	@DataDate varchar(10) ,  
	@FileDate varchar(10) , 
	@CreatedBy  varchar(50)  ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy  varchar(50)  ,
    @MasterConsumerID  bigint ,
	@HealthCardIdentifier  varchar(50) ,
	@FirstName  varchar(50) ,
	@LastName  varchar(50) ,
	@DateBirth  varchar(10) ,
	@Gender  varchar(3) ,
	@EnterpriseMemberCode  varchar(3) ,
	@MemberSequenceNumber  varchar(15) ,
	@MSR_CMPLNC_CD  varchar(32) ,
	@RULE_ID  varchar(8) ,
	@ANLYSS_AS_OF_DT  varchar(10) ,
	@LAST_SRVC_DT  varchar(10) ,
	@RULE_NM  varchar(255) ,
	@PG_ID  varchar(32) ,
	@PG_NAME  varchar(100) ,
	@PGM_ID  varchar(32) ,
	@Panel_ID  varchar(32) ,
	@MemberKey  varchar(32) ,
	@MSR_NMRTR_NBR  varchar(3) ,
	@MSR_DNMNTR_NBR  varchar(3) ,
	@NEXT_CLNCL_DUE_DT  varchar(10) ,
	@MSRMNT_PRD_STRT_DT  varchar(10) ,
	@MSRMNT_PRD_END_DT  varchar(10) ,
	@LatestValue  varchar(100) ,
	@AttributionAsDate  varchar(10) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    EXEC [ACDW_CLMS_AMGTX_MA].[adi].[ImportAmerigroup_CARE-OPPS]
	  @OriginalFileName    ,
	@SrcFileName    ,
	@LoadDate  ,
	--@CreatedDate  
	@DataDate  ,  
	@FileDate , 
	@CreatedBy    ,
	--@LastUpdatedDate  @datetime   ,
	@LastUpdatedBy    ,
    @MasterConsumerID   ,
	@HealthCardIdentifier  ,
	@FirstName   ,
	@LastName   ,
	@DateBirth  ,
	@Gender   ,
	@EnterpriseMemberCode   ,
	@MemberSequenceNumber   ,
	@MSR_CMPLNC_CD   ,
	@RULE_ID  ,
	@ANLYSS_AS_OF_DT   ,
	@LAST_SRVC_DT   ,
	@RULE_NM  ,
	@PG_ID   ,
	@PG_NAME  ,
	@PGM_ID   ,
	@Panel_ID  ,
	@MemberKey   ,
	@MSR_NMRTR_NBR   ,
	@MSR_DNMNTR_NBR  ,
	@NEXT_CLNCL_DUE_DT  ,
	@MSRMNT_PRD_STRT_DT   ,
	@MSRMNT_PRD_END_DT  ,
	@LatestValue   ,
	@AttributionAsDate  

END





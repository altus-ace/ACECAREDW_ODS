-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adw].[ImportMSSP_List_PCP]
   	--[CreatedDate] [datetime] ,
	@CreatedBy [varchar](50),
	--[LastUpdated] [datetime] NOT ,
	@LastUpdatedBy [varchar](50),
	@SrcFileName [varchar](50),
	@CLIENT_ID [varchar](50) ,
	@PCP_NPI [varchar](50) ,
	@PCP_FIRST_NAME [varchar](50) ,
	@PCP_MI [varchar](50) ,
	@PCP_LAST_NAME [varchar](50) ,
	@PCP__ADDRESS [varchar](50) ,
	@PCP__ADDRESS2 [varchar](50),
	@PCP_CITY [varchar](50) ,
	@PCP_STATE [varchar](50) ,
	@PCP_ZIP [varchar](50) ,
	@PCP_PHONE [varchar](50) ,
	@PCP_CLIENT_ID [varchar](50) ,
	@PCP_PRACTICE_TIN [varchar](50) ,
	@PCP_PRACTICE_TIN_NAME [varchar](50) ,
	@PRIM_SPECIALTY [varchar](100) ,
	@PROV_TYPE [varchar](20) ,
	@PCP_FLAG [varchar](1) ,
	@CAMPAIGN_RUN_ID varchar(10) ,
	@T_Modify_by [varchar](50) ,
	@ACTIVE [char](1) ,
	@EffectiveDate varchar(10),
	@ExpirationDate varchar(10),
	@PCP_POD [varchar](50)
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

EXEC [ACDW_CLMS_SHCN_MSSP].[adw].[ImportMSSP_List_PCP]
          	--[CreatedDate] [datetime] ,
	@CreatedBy ,
	--[LastUpdated] [datetime] NOT ,
	@LastUpdatedBy ,
	@SrcFileName ,
	@CLIENT_ID ,
	@PCP_NPI ,
	@PCP_FIRST_NAME ,
	@PCP_MI ,
	@PCP_LAST_NAME ,
	@PCP__ADDRESS ,
	@PCP__ADDRESS2 ,
	@PCP_CITY ,
	@PCP_STATE ,
	@PCP_ZIP ,
	@PCP_PHONE ,
	@PCP_CLIENT_ID ,
	@PCP_PRACTICE_TIN ,
	@PCP_PRACTICE_TIN_NAME ,
	@PRIM_SPECIALTY ,
	@PROV_TYPE ,
	@PCP_FLAG ,
	@CAMPAIGN_RUN_ID ,
	@T_Modify_by ,
	@ACTIVE ,
	@EffectiveDate,
	@ExpirationDate ,
	@PCP_POD 
        
 END

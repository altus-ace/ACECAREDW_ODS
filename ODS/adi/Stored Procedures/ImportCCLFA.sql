﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportCCLFA](
	-- Add the parameters for the stored procedure here
    @CUR_CLM_UNIQ_ID varchar(13) ,
	@BENE_MBI_ID varchar(11),
	@BENE_HIC_NUM varchar(11) ,
	@CLM_TYPE_CD varchar(2),
	@CLM_ACTV_CARE_FROM_DT varchar(12),
	@CLM_NGACO_PBPMT_SW char(1),
	@CLM_NGACO_PDSCHRG_HCBS_SW char(1),
	@CLM_NGACO_SNF_WVR_SW char(1),
	@CLM_NGACO_TLHLTH_SW char(1),
	@CLM_NGACO_CPTATN_SW char(1) ,
	@CLM_DEMO_1ST_NUM varchar(2),
	@CLM_DEMO_2ND_NUM varchar(2) ,
	@CLM_DEMO_3RD_NUM varchar(2) ,
	@CLM_DEMO_4TH_NUM varchar(2) ,
	@CLM_DEMO_5TH_NUM varchar(2) ,
	@CLM_PBP_INCLSN_AMT varchar(10),
	@CLM_PBP_RDCTN_AMT varchar(10) ,
    @SrcFileName varchar(100)
   ,@FileDate varchar(10)
   ,@originalFileName varchar(100)
     -- ,@CreateDate 
  ,@CreateBy varchar(20)

)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	--DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
	--SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', '[ACECARDW].[adi].[copUhcPcor]', '' ;



 --IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 

    -- Insert statements for procedure here
--INSERT INTO [adi].[CCLFb]
--(
--    [CUR_CLM_UNIQ_ID] ,
--	[CLM_LINE_NUM] ,
--	[BENE_MBI_ID] ,
--	[BENE_HIC_NUM] ,
--	[CLM_TYPE_CD] ,
--	[CLM_LINE_NGACO_PBPMT_SW],
--	[CLM_LINE_NGACO_PDSCHRG_HCBS_SW] ,
--	[CLM_LINE_NGACO_SNF_WVR_SW] ,
--	[CLM_LINE_NGACO_TLHLTH_SW] ,
--	[CLM_LINE_NGACO_CPTATN_SW] ,
--	[CLM_DEMO_1ST_NUM] ,
--	[CLM_DEMO_2ND_NUM] ,
--	[CLM_DEMO_3RD_NUM] ,
--	[CLM_DEMO_4TH_NUM] ,
--	[CLM_DEMO_5TH_NUM] ,
--	[CLM_PBP_INCLSN_AMT] ,
--	[CLM_PBP_RDCTN_AMT] ,
--	[SrcFileName] ,
--	[FileDate] ,
--	[originalFileName] ,
--	--[CreateDate] ,
--	[CreateBy] 
--)
--  VALUES
--(
--    @CUR_CLM_UNIQ_ID ,
--	@CLM_LINE_NUM,
--	@BENE_MBI_ID ,
--	@BENE_HIC_NUM ,
--	@CLM_TYPE_CD ,
--	@CLM_LINE_NGACO_PBPMT_SW ,
--	@CLM_LINE_NGACO_PDSCHRG_HCBS_SW ,
--	@CLM_LINE_NGACO_SNF_WVR_SW ,
--	@CLM_LINE_NGACO_TLHLTH_SW ,
--	@CLM_LINE_NGACO_CPTATN_SW ,
--	@CLM_DEMO_1ST_NUM ,
--	@CLM_DEMO_2ND_NUM ,
--	@CLM_DEMO_3RD_NUM ,
--	@CLM_DEMO_4TH_NUM ,
--	@CLM_DEMO_5TH_NUM ,
--	CASE WHEN (@CLM_PBP_INCLSN_AMT = '')
--	THEN NULL
--	ELSE CONVERT(money, @CLM_PBP_INCLSN_AMT)
--	END,
--	CASE WHEN (@CLM_PBP_RDCTN_AMT = '')
--	THEN NULL
--	ELSE CONVERT(money, @CLM_PBP_RDCTN_AMT)
--	END, 
	
--	@SrcFileName ,
--	@FileDate ,
--	@originalFileName ,
--	--[CreateDate] [datetime] ,
--	@CreateBy 
	
	
	

  
--)

EXEC [ACDW_CLMS_CCACO].[adi].[ImportCCLFA]
    @CUR_CLM_UNIQ_ID,
	@BENE_MBI_ID ,
	@BENE_HIC_NUM ,
	@CLM_TYPE_CD ,
	@CLM_ACTV_CARE_FROM_DT ,
	@CLM_NGACO_PBPMT_SW ,
	@CLM_NGACO_PDSCHRG_HCBS_SW ,
	@CLM_NGACO_SNF_WVR_SW ,
	@CLM_NGACO_TLHLTH_SW ,
	@CLM_NGACO_CPTATN_SW ,
	@CLM_DEMO_1ST_NUM ,
	@CLM_DEMO_2ND_NUM ,
	@CLM_DEMO_3RD_NUM ,
	@CLM_DEMO_4TH_NUM  ,
	@CLM_DEMO_5TH_NUM  ,
	@CLM_PBP_INCLSN_AMT ,
	@CLM_PBP_RDCTN_AMT ,
    @SrcFileName 
   ,@FileDate 
   ,@originalFileName 
     -- ,@CreateDate 
  ,@CreateBy 


END


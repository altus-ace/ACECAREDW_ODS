








CREATE PROCEDURE [dbo].[sp_GetMbrAttrition]
	AS
	BEGIN
		SET NOCOUNT ON;


IF OBJECT_ID('[dbo].[tmp_MbrAttrition]', 'U') IS NOT NULL 
  DROP TABLE [dbo].[tmp_MbrAttrition]; 


CREATE TABLE [dbo].[tmp_MbrAttrition](
	[SUBSCRIBER_ID]		[varchar](20) NOT NULL,
	[LOB_ID]			[varchar](20) NULL,
	[PLAN_ID]			[varchar](20) NULL,
	[PRODUCT_CODE]		[varchar](20) NULL,
	[SUBGRP_ID]			[varchar](20) NULL,
	[AUTO_ASSIGN]		[varchar](20) NULL,
	[MBR_MTH]			[int] NULL,
	[MBR_YEAR]			[int] NULL,
) ON [PRIMARY]



INSERT INTO [dbo].[tmp_MbrAttrition](
		[SUBSCRIBER_ID]	,
		[LOB_ID]		,			
		[PLAN_ID]		,	
		[PRODUCT_CODE]	,	
		[SUBGRP_ID]		,	
		[AUTO_ASSIGN]	,	
		[MBR_YEAR]		,
		[MBR_MTH]				
		)    
	SELECT	
		a.UHC_SUBSCRIBER_ID
		,(CASE a.PRODUCT_CODE
			WHEN		'TXCHIP0' THEN   'CHIP'
			WHEN 		'TXCHIP1' THEN   'CHIP' 
			WHEN 		'TXCHIP2' THEN   'CHIP'
			WHEN 		'TXCHIP3' THEN   'CHIP'
			WHEN 		'TXCHIPI' THEN   'CHIP'             
			WHEN 		'TXCHPNM1' THEN   'CHIP'            
			WHEN 		'TXCHPNM2' THEN   'CHIP'            
			WHEN 		'TXKIN' THEN   'KIDS' 
			WHEN 		'TXKMN' THEN   'KIDS' 
			WHEN 		'TXKSIN' THEN   'KIDS' 
			WHEN 		'TXKYN' THEN   'KIDS' 
			WHEN 		'TXMMP' THEN   'MMP' 
			WHEN 		'TXMMPHW' THEN   'MMP' 
			WHEN 		'TXSNPH1' THEN   'SPEC' 
			WHEN 		'TXSPCRT1' THEN   'STAR+'             
			WHEN 		'TXSPCRT2' THEN   'STAR+' 
			WHEN 		'TXSPCRT3' THEN   'STAR+' 
			WHEN 		'TXSPCRT7' THEN   'STAR+' 
			WHEN 		'TXSTAR' THEN   'STAR' 
			ELSE		'UNK'
			END) 
		,a.PLAN_ID	
		,a.PRODUCT_CODE
		,a.SUBGRP_ID
		,a.AUTO_ASSIGN
		,YEAR([A_LAST_UPDATE_DATE]) AS MBR_YEAR
		,MONTH([A_LAST_UPDATE_DATE]) AS MBR_MTH 
	FROM dbo.UHC_MembersByPCP a
	WHERE [LoadType] = 'P'
	AND A_LAST_UPDATE_DATE not in ('2017-07-24')
	AND SUBGRP_ID  NOT IN ('TX99','1001','1002','1003','0603','0601','0602','0600','0606','0604','0605')
	ORDER BY UHC_SUBSCRIBER_ID, YEAR([A_LAST_UPDATE_DATE]), MONTH([A_LAST_UPDATE_DATE])
  
  END








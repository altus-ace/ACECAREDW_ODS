-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [lst].[Load_ListTableByCatalogAndListTableType]
(  @Catalog varchar(50),
   @ListTable varchar(50)
)
AS
	SET NOCOUNT ON;

BEGIN
 
	 EXEC [AceMasterData].[lst].[Load_ListTableByCatalogAndListTableType]
	 @Catalog,
     @ListTable

--Load QM_Mapping
--  EXEC [lst].[usp_lstAllClientQMMapping]'ACDW_CLMS_SHCN_MSSP.[lst].[LIST_QM_Mapping]'
--  EXEC [lst].[usp_lstAllClientQMMapping]'ACDW_CLMS_UHC.[lst].LIST_QM_Mapping'
--  EXEC [lst].[usp_lstAllClientQMMapping]'ACDW_CLMS_WLC.[lst].LIST_QM_Mapping'
--  EXEC [lst].[usp_lstAllClientQMMapping]'ACECAREDW_TEST.[lst].LIST_QM_Mapping'
--  EXEC [lst].[usp_lstAllClientQMMapping]'ACECAREDW.[lst].LIST_QM_Mapping'
--  EXEC [lst].[usp_lstAllClientQMMapping]'ACDW_CLMS_DHTX.[lst].LIST_QM_Mapping'


----Load CareOppsPrograms
--  EXEC [lst].[usp_lstAllClientMapCareoppsPrograms]'ACDW_CLMS_UHC.lst.lstMapCareoppsPrograms'
--  EXEC [lst].[usp_lstAllClientMapCareoppsPrograms]'ACDW_CLMS_WLC.lst.lstMapCareoppsPrograms'
--  EXEC [lst].[usp_lstAllClientMapCareoppsPrograms]'ACECAREDW_TEST.lst.lstMapCareoppsPrograms'
--  EXEC [lst].[usp_lstAllClientMapCareoppsPrograms]'ACECAREDW.lst.lstMapCareoppsPrograms'
--  EXEC [lst].[usp_lstAllClientMapCareoppsPrograms]'ACDW_CLMS_DHTX.lst.lstMapCareoppsPrograms'
--  EXEC [lst].[usp_lstAllClientMapCareoppsPrograms]'ACDW_CLMS_SHCN_MSSP.lst.lstMapCareoppsPrograms'


--  --Load CareopTo Plan
--  EXEC [lst].[usp_lstAllClientCareOpToPlan]'ACDW_CLMS_UHC.lst.lstCareOpToPlan'
--  EXEC [lst].[usp_lstAllClientCareOpToPlan]'ACDW_CLMS_WLC.lst.lstCareOpToPlan'
--  EXEC [lst].[usp_lstAllClientCareOpToPlan]'ACECAREDW_TEST.lst.lstCareOpToPlan'
--  EXEC [lst].[usp_lstAllClientCareOpToPlan]'ACECAREDW.lst.lstCareOpToPlan'
--  EXEC [lst].[usp_lstAllClientCareOpToPlan]'ACDW_CLMS_DHTX.lst.lstCareOpToPlan'
--  EXEC [lst].[usp_lstAllClientCareOpToPlan]'ACDW_CLMS_SHCN_MSSP.lst.lstCareOpToPlan'


--  --Load Hedis Code
--  EXEC [lst].[usp_lstAllClientHedisCode]'ACECAREDW.dbo.LIST_HEDIS_CODE'
--  EXEC [lst].[usp_lstAllClientHedisCode]'ACECAREDW_TEST.dbo.LIST_HEDIS_CODE'
--  EXEC [lst].[usp_lstAllClientHedisCode]'AceMasterQMCalc.lst.LIST_HEDIS_CODE'
--  EXEC [lst].[usp_lstAllClientHedisCode]'ACDW_CLMS_UHC.lst.LIST_HEDIS_CODE'
--  EXEC [lst].[usp_lstAllClientHedisCode]'[ACDW_CLMS_DHTX].lst.LIST_HEDIS_CODE'
--  EXEC [lst].[usp_lstAllClientHedisCode]'ACDW_CLMS_SHCN_MSSP.lst.LIST_HEDIS_CODE'

--  --Load Drug Package
--  EXEC [lst].[usp_lstAllClientDrugPackage]'ACDW_CLMS_DHTX.lst.[lstNdcDrugPackage]'
--  EXEC [lst].[usp_lstAllClientDrugPackage]'ACDW_CLMS_SHCN_MSSP.lst.[lstNdcDrugPackage]'
--  EXEC [lst].[usp_lstAllClientDrugPackage]'ACECAREDW_TEST.dbo.[lstNdcDrugPackage]'
--  EXEC [lst].[usp_lstAllClientDrugPackage]'ACECAREDW_TEST.lst.[lstNdcDrugPackage]'

--  --Load Drug Product
--  EXEC [lst].[usp_lstAllClientDrugProduct]'ACDW_CLMS_DHTX.[lst].[lstNdcDrugProduct]'
--  EXEC [lst].[usp_lstAllClientDrugProduct]'[ACDW_CLMS_SHCN_MSSP].[lst].[lstNdcDrugProduct]'
--  EXEC [lst].[usp_lstAllClientDrugProduct]'ACDW_CLMS_UHC.lst.[lstNdcDrugProduct]'

-- --Load NippesNIP
-- EXEC [lst].[usp_lstAllClientNippesNIP]'[ACDW_CLMS_SHCN_MSSP].[lst].[LIST_NPPES_NPI]'
-- EXEC [lst].[usp_lstAllClientNippesNIP]'ACDW_CLMS_DHTX.[lst].[LIST_NPPES_NPI]'
-- EXEC [lst].[usp_lstAllClientNippesNIP]'[ACECAREDW_TEST].[lst].[LIST_NPPES_NPI]'

-- --Load HccCodes
-- EXEC [lst].[usp_lstAllClientHccCodes]'ACDW_CLMS_SHCN_MSSP.[lst].[LIST_HCC_CODES]'
-- EXEC [lst].[usp_lstAllClientHccCodes]'[ACDW_CLMS_AET_TX_COM].[lst].[LIST_HCC_CODES]'
-- EXEC [lst].[usp_lstAllClientHccCodes]'[ACDW_CLMS_DHTX].[lst].[LIST_HCC_CODES]'
-- EXEC [lst].[usp_lstAllClientHccCodes]'[ACECAREDW].[lst].[LIST_HCC_CODES]'


  --Keep updating SP

END

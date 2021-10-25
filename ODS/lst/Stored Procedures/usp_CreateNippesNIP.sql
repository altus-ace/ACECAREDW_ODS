

CREATE PROCEDURE [lst].[usp_CreateNippesNIP]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_AET_TX_COM.lst.LIST_ICD10CM'
EXEC 	[AceMasterData].[lst].[usp_CreateNippesNIP]
        @ConnectionString  
END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_NPPES_NPI]
	--Targets
	/*

	*/
	
	
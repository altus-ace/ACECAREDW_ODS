



CREATE PROCEDURE [ast].[pls_NtfClients]

AS

BEGIN
			--Processing source files into staging

			EXECUTE [ast].[ntfLoadToStgGHH]
			EXECUTE [ast].[ntfLoadToStgAetnaMA]
			EXECUTE [ast].[ntfLoadToStgAetnaCOM]
			EXECUTE [ast].[ntfLoadToStgUhcIP]
			EXECUTE [ast].[ntfLoadToStgUhcER]
			EXECUTE [ast].[ntfLoadToStgDevoted]
			EXECUTE [ast].[ntfLoadToStgShcnMssp]
			EXECUTE [ast].[ntfLoadToStgCignaMA]
			EXECUTE [ast].[ntfLoadToStgShcnBCBS]



END

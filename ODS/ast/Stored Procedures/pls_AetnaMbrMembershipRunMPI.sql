﻿



CREATE PROCEDURE [ast].[pls_AetnaMbrMembershipRunMPI](@ClientKey INT)

AS

BEGIN
BEGIN TRAN
BEGIN TRY

			--SELECT * FROM  [AceMPI].[ast].[MPI_SourceTable]
BEGIN
			TRUNCATE TABLE [AceMPI].[ast].[MPI_SourceTable] 
END


BEGIN
			TRUNCATE TABLE [AceMPI].[ast].[MPI_OUTPUTTABLE] 
END


BEGIN

			INSERT INTO [AceMPI].[ast].[MPI_SourceTable] (
						[ClientSubscriberId]
						, [ClientKey]
						, [MstrMrnKey]
						, [mbrLastName]
						, [mbrFirstName]
						, [mbrMiddleName]
						, [mbrGENDER]
						, [mbrDob]
						, [SrcFileName]
						, [AdiTableName]
						, [ExternalUniqueID]
						, [MbrState]
						, [DataDate])
			SELECT		[ClientSubscriberId]
						, [ClientKey]
						, [MstrMrnKey]
						, [mbrLastName]
						, [mbrFirstName]
						, [mbrMiddleName]
						, [mbrGENDER]
						, [mbrDob]
						, [SrcFileName]
						, [AdiTableName]
						, [AdiKey]
						, [MbrState]
						, [DataDate]
			FROM		[ACECAREDW].[ast].[MbrStg2_MbrData]
			WHERE		DataDate = (SELECT MAX(DataDate) FROM [ACECAREDW].[ast].[MbrStg2_MbrData]
									WHERE ClientKey = @ClientKey)
			AND			ClientKey =@ClientKey
			AND			prvNPI <> '0'



				-- Run Load_MPI_MasterJob algorithm to Generate Mstrmrnkeys for members
			IF (SELECT COUNT(*) FROM [AceMPI].[ast].[MPI_SourceTable]) >= 1
			EXECUTE ACEMPI.adw.[Load_MasterJob_MPI]


END


BEGIN
			
			--Update stg table with the mstrmrnkeys
			--	BEGIN TRAN				-- rollback -- COMMIT
			UPDATE		ACECAREDW.ast.MbrStg2_MbrData
			SET			MstrMrnKey = z.MstrMrn
			-- SELECT		z.ClientSubscriberId,a.ClientKey,MstrMrn,a.MstrMrnKey,a.ClientSubscriberId,z.ClientKey --a.ExternalUniqueID,b.ExternalUniqueID,
			FROM		ACECAREDW.ast.MbrStg2_MbrData a
			JOIN		(	SELECT		ClientSubscriberId, ClientKey,a.ExternalUniqueID,b.ExternalUniqueID bExternalUniqueID
										,MstrMrnKey,MstrMrn
							FROM		AceMPI.ast.MPI_SourceTable a
							JOIN		AceMPI.ast.MPI_OutputTable b
							ON			a.ExternalUniqueID = b.ExternalUniqueID
						)z
			ON			a.ClientSubscriberId = z.ClientSubscriberId
			WHERE		a.ClientKey = @ClientKey
			AND			LoadDate =  (	SELECT	MAX(LoadDate) 
										FROM	ACECAREDW.ast.MbrStg2_MbrData 
										WHERE	ClientKey = @ClientKey
									)

END



COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH


END


	

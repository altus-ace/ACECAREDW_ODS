

 CREATE PROCEDURE [ast].[Pst_MbrPhnAddEmail_Validate]
	@LoadDate DATE 
	, @ClientKey INT 
	
 AS 

    --DECLARE @LoadDate DATE = '01/25/2021'
    --DECLARE  @ClientKey INT = 9
	   -- business rule check: All rows are valid, insert em!!
    --SELECT src.*
    UPDATE ast SET ast.stgRowStatus = 'Valid'
    FROM ast.mbrStg2_PhoneAddEmail ast
	   JOIN (SELECT m.mbrStg2_PhoneAddEmailUrn, m.stgRowStatus
			 FROM ast.MbrStg2_PhoneAddEmail m    
			 WHERE m.LoadDate = @LoadDate
				AND m.ClientKey = @ClientKey 
				AND m.stgRowStatus IN ('Loaded', 'Valid')
			 ) src
		  ON ast.mbrStg2_PhoneAddEmailUrn = src.mbrStg2_PhoneAddEmailUrn    
    ;


	 /*Update stgRowStatus in PhoneAdd and Email Table using Stg Members Table*/
		BEGIN
		UPDATE		ACECAREDW.[ast].[MbrStg2_PhoneAddEmail]
		SET			stgRowStatus = m.stgRowStatus --- select m.AdiKey,ad.AdiKey,ad.stgRowStatus,m.stgRowStatus, *
		FROM		ACECAREDW.[ast].[MbrStg2_PhoneAddEmail] ad
		JOIN		(SELECT  MAX(DataDate) DataDate
										,AdiKey,stgRowStatus
								FROM	ACECAREDW.ast.MbrStg2_MbrData
								WHERE	ClientKey = @ClientKey
								AND		LoadDate =  @LoadDate-- '2021-06-01'
								AND		stgRowStatus  = 'Not Valid' 
								GROUP BY AdiKey,stgRowStatus
									)m
		ON		   ad.AdiKey = m.AdiKey
		WHERE	   ad.LoadDate = @LoadDate
		AND			ad.ClientKey = @ClientKey
		
		END
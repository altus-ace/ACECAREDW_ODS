

 CREATE PROCEDURE [ast].[Pst_MbrPhnAddEmail_MarkExported]
	@LoadDate DATE 
	, @ClientKey INT 
 AS 
    --SELECT *
    UPDATE trg SET trg.stgRowStatus = 'Exported'
    FROM ast.MbrStg2_PhoneAddEmail trg
	   JOIN (SELECT m.mbrStg2_PhoneAddEmailUrn, m.stgRowStatus
			 FROM ast.MbrStg2_PhoneAddEmail m    
			 WHERE m.LoadDate = @LoadDate
				AND m.ClientKey = @ClientKey 
				AND m.stgRowStatus IN ('Valid')
			 ) src
		  ON trg.mbrStg2_PhoneAddEmailUrn = src.mbrStg2_PhoneAddEmailUrn
    ;

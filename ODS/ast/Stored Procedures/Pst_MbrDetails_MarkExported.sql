
CREATE PROCEDURE [ast].[Pst_MbrDetails_MarkExported]
	@LoadDate DATE 
	, @ClientKey INT 	
 AS	   

    --SELECT *
    UPDATE trg SET trg.stgRowStatus = 'Exported'
    FROM ast.MbrStg2_MbrData trg
	   JOIN (SELECT m.mbrStg2_MbrDataURN, m.stgRowStatus, m.MstrMrnKey
			 FROM ast.MbrStg2_MbrData m    
			 WHERE m.LoadDate = @LoadDate
				AND m.ClientKey = @ClientKey 
				AND m.stgRowStatus IN ('Valid')
			 ) src
		  ON trg.mbrStg2_MbrDataURN = src.mbrStg2_MbrDataURN
			 AND src.MstrMrnKey <> -1 -- business rule check: Mbr Must have MRN KEY
    
    ;

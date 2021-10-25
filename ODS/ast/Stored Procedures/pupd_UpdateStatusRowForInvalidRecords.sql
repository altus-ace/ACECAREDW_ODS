
CREATE PROCEDURE [ast].[pupd_UpdateStatusRowForInvalidRecords]
			(@LoadDate DATE, @ClientKey INT)

AS
	---Update invalid Mbrs records BEGIN TRAN COMMIT
		  
		  --Update Not Valid Records
		  UPDATE ast.MbrStg2_MbrData 
		  SET	stgRowStatus = 'Not Valid'
		  WHERE	 ClientKey = @ClientKey 
		  AND	LoadDate = @LoadDate 
		  AND    (prvNPI IS  NULL
		  OR    plnProductPlan IS  NULL) 

		 
		 --Update Invalid Members Address, Email and Phones
		  
		  UPDATE		ast.MbrStg2_PhoneAddEmail
		  SET			stgRowStatus = mbr.stgRowStatus
		  -- SELECT		em.AdiKey,mbr.AdiKey,em.stgRowStatus,mbr.stgRowStatus
		  FROM			ast.MbrStg2_PhoneAddEmail em
		  JOIN			ast.MbrStg2_MbrData mbr
		  ON			em.AdiKey = mbr.AdiKey
		  WHERE			mbr.LoadDate = @LoadDate
		  AND			mbr.stgRowStatus = 'Not Valid'
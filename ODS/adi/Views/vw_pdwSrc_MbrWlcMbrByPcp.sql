
CREATE VIEW adi.[vw_pdwSrc_MbrWlcMbrByPcp]
AS 		  
    
    SELECT m.mbrWlcMbrByPcpKey, m.SEQ_Mem_ID, m.Sub_ID, 
       m.FirstName, m.LastName, m.GENDER, m.IPA, m.BirthDate, 
       m.MEDICAID_NO, m.MEDICAL_REC_NO, m.EffDate, m.TermDate, 
       m.Prov_id, m.Prov_Name, m.LOB, m.BenePLAN, 
       m.ADDRESS_TYPE, m.Address, m.City, m.[State], m.Zip, m.County, 
       m.PhoneNumber, m.MOBILE_PHONE, m.ALT_PHONE, m.AGENT_NUM, m.Enrollment_Source, 
       m.SrcFileName, m.InQuarantine, m.LoadDate, m.DataDate, 
	  m.CreateDate, m.CreateBy, m.LastUpdatedDate, m.LastUpdatedBy
	  , ROW_NUMBER() OVER (PARTITION BY m.SUB_ID ORDER BY m.LoadDATE DESC) arn
	FROM adi.MbrWlcMbrByPcp m
	   JOIN (SELECT Max(M.LoadDate) AS LoadDate
			 FROM adi.mbrWlcMbrByPcp m
			 ) LatestAdi ON m.LoadDate = LatestAdi.LoadDate
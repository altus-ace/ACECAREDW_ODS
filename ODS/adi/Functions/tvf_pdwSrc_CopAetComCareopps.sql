
CREATE Function [adi].[tvf_pdwSrc_CopAetComCareopps] (
    @LoadDate Date
    )
    /* Pdw: process data warehouse, src: Load Source     */
    RETURNS TABLE 
AS 
RETURN
    SELECT Client.ClientKey      
      , MemberID_Lookup.Member_ID  AS ClientMemberKey         
	 , CareOps.PatientId		AS Aetna_Card_ID
      , qm.QM As QmMsrID	 
	 , CASE WHEN (CareOps.Numerator = 'Y') THEN 'NUM' 
		  WHEN (CareOps.Numerator = 'N') THEN 'COP' 
		  ELSE 'UNK' END QmCntCat      
      ,CareOps.DataDate as QmDate
      ,CareOps.copAetComCareOppsKey AS adiKey
      , 'copAetComCareopps' As AdiTableName
	 ,CareOps.OrignalSrcFileName      
	 ,CareOps.SrcFileName      
	 ,CareOps.Measure_Number      
	 ,CareOps.Numerator     	 
    FROM adi.copAetComCareopps CareOps
	   JOIN (SELECT * FROM lst.List_Client c WHERE c.ClientKey = 9) Client ON 9 = Client.ClientKey
	   JOIN (SELECT qm.QM, SUBSTRING(qm.QM_DESC, 1, 6)QmMatch FROM lst.LIST_QM_Mapping QM )qm
	   	  ON CareOps.Measure_Number = qm.QmMatch
	   JOIN adi.tvf_MbrAetCom_MapMemberIdFromAetnaCardId (getdate())  MemberID_Lookup 
		  ON CareOps.PatientId = MemberID_Lookup.Aetna_Card_ID
    WHERE DataDate = @LoadDate;


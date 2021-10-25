

CREATE VIEW [adw].[VW_EXP_AH_Programs]
AS  
    /* Purpose to provide data to the EXPORT boomi job to send programs to AHS Currently reads from ADI tables 
	   will read from the adwMbrProgram table where Exported = 0
	   */
	   /* had to clean the input data as there was a typo in the LOB NAME */
	   /* SELECT * --UPDATE progName set PRogName.LOB = 'SHCN_MSSP'
	   FROM [adi].[ACEProgramName] ProgName
	   where progName.LOB = 'SCHN_MSSP'
	   */
SELECT  --ProgName.DataDate, ProgName.OriginalFileName, ProgName.SrcFileName, ProgName.CreatedDate, ProgName.CreatedBy, ProgName.LastUpdatedDate, ProgName.LastUpdatedBy, ProgName.LOB, 
    ProgName.ACEProgramNameKey, 
    ProgName.loadDate,     
    client.CLientKey, client.CS_Export_LobName,
    ProgName.MemberID, 
    ProgName.Program, 
    ProgName.StartDate, 
    ProgName.EndDate, 
    '' PROGRAM_STATUS, 
    '' REASON_DESCRIPTION, 
    '' REFERAL_TYPE,
     cs.MbrCsSubPlanName AS CS_PlanName
FROM [adi].[ACEProgramName] ProgName
    JOIN lst.List_Client Client ON ProgName.LOB = Client.CS_Export_LobName    
    JOIN adw.MbrMember mbr ON mbr.ClientKey  = 1 and mbr.ClientMemberKey = ProgName.MemberID
    JOIN adw.mbrCsPlanHistory cs 
	   ON mbr.mbrMemberKey = cs.MbrMemberKey 
	   --and getdate() between cs.EffectiveDate and cs. ExpirationDate
WHERE client.ClientKey = 1 and progName.loaddate ='08/27/2020'
UNION
SELECT  --ProgName.DataDate, ProgName.OriginalFileName, ProgName.SrcFileName, ProgName.CreatedDate, ProgName.CreatedBy, ProgName.LastUpdatedDate, ProgName.LastUpdatedBy, ProgName.LOB,
    ProgName.ACEProgramNameKey, 
    ProgName.loadDate,     
    client.CLientKey, client.CS_Export_LobName,
    ProgName.MemberID, 
    ProgName.Program, 
    ProgName.StartDate, 
    ProgName.EndDate, 
    --ProgName.ProductSubgroup
    '' PROGRAM_STATUS, 
    '' REASON_DESCRIPTION, 
    '' REFERAL_TYPE,
     mbr.PlanName AS CS_PlanName
FROM [adi].[ACEProgramName] ProgName
    JOIN lst.List_Client Client ON ProgName.LOB = Client.CS_Export_LobName    
    JOIN ACDW_CLMS_SHCN_MSSP.adw.FctMembership mbr 
	   ON mbr.ClientKey  = 16 
		  and mbr.ClientMemberKey = ProgName.MemberID
		  AND  ProgName.LOADDATE BETWEEN mbr.RwEffectiveDate and mbr.RwExpirationDate    
WHERE client.ClientKey = 16
   and progName.loaddate ='08/27/2020'
UNION
--- export WLC and Cigna MA AWV
SELECT --ProgName.DataDate, ProgName.OriginalFileName, ProgName.SrcFileName, ProgName.CreatedDate, ProgName.CreatedBy, ProgName.LastUpdatedDate, ProgName.LastUpdatedBy, ProgName.LOB,
    awv.adiKey, 
    awv.loadDate,     
    awv.CLientKey, awv.CS_Export_LobName,
    awv.Member_id, 
    awv.Program, 
    awv.StartDate, 
    awv.EndDate, 
    awv.PROGRAM_STATUS, 
    awv.REASON_DESCRIPTION, 
    awv.REFERAL_TYPE,
    --ProgName.ProductSubgroup
     '' AS CS_PlanName
FROM ACDW_CLMS_WLC.dbo.Vw_Exp_AH_AWV_Program awv
UNION
SELECT Awv.AdiKey,
	  Awv.LoadDate,
	  awv.ClientKey, awv.CS_Export_LobName,
	  awv.Member_id, 
       awv.Program_Name, 
       awv.StartDate, 
       awv.EndDate,               
       awv.PROGRAM_STATUS, 
       awv.REASON_DESCRIPTION, 
       awv.REFERAL_TYPE,
	  '' CS_PlanName
FROM ACDW_CLMS_CIGNA_MA.adw.vw_EXP_AH_AWV AWV;

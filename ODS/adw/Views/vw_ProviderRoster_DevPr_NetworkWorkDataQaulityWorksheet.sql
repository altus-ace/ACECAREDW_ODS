
CREATE VIEW ADW.vw_ProviderRoster_DevPr_NetworkWorkDataQaulityWorksheet
AS 
    SELECT distinct        
	   pr.NPI--, adi.adiNpi
	   , pr.LastName, pr.FirstName
        , pr.AttribTIN, pr.AttribTINName, pr.AccountType, pr.Chapter, pr.PrimaryCounty
        , Client.ClientName, pr.ClientProviderID
        , pr.TINHealthPlan, pr.TinLOB, pr.TinHPEffectiveDate, pr.TinHPExpirationDate
        , pr.NpiHealthPlan, pr.NpiLOB, pr.NpiHpEffectiveDate, pr.NpiHpExpirationDate
        , pr.LastUpdatedDate
    FROM adw.tvf_AllClient_ProviderRoster_DevPR_ByClient(0) pr
        LEFT JOIN lst.List_Client client ON pr.ClientKey = client.ClientKey
	   
--		  ON pr.NPI = adi.adiNpi
    --WHERE pr.TINHealthPlan = 'SHCN_BCBS'
    WHERE 1 = 1
        and getdate() between pr.TinHPEffectiveDate and pr.TinHPExpirationDate
        and getdate() between pr.NpiHpEffectiveDate and pr.NpiHPExpirationDate
--	   and adi.adiNpi is null
--  ORDER BY Client.ClientName ASC

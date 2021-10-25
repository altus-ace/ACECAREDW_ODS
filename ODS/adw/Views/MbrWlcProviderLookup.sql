
CREATE VIEW [adw].[MbrWlcProviderLookup]
AS
--BRIT: V1:  Changes to PR
   SELECT DISTINCT	pr.NPI
			, pr.ClientProviderID AS Prov_ID
			, pr.[FirstName] + ' ' + pr.LastName as ProvName    
			, pr.AttribTINName AS PracticeName
			, pr.NpiHpExpirationDate    AS Term_Date
			,pr.NpiHpEffectiveDate AS EffectiveDate
			,pr.NpiHpExpirationDate AS ExpirationDate
			,pr.AttribTIN AS TIN
	FROM	 adw.tvf_AllClient_ProviderRoster(2,GETDATE(),1) pr
   
	




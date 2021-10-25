
CREATE VIEW [adw].[zz_MbrWlcProviderLookup_old]
AS
SELECT DISTINCT 
    --m.Prov_id, 
    m.Prov_Name, provLookup.NPI, provLookup.TIN, provLookup.PracticeName
FROM adi.MbrWlcMbrByPcp m
    JOIN (SELECT distinct 
		  ta.name AS PracticeName
		  ,ta.tax_id_number__C AS TIN ,tc.[Provider_NPI__c] AS NPI
		  ,tc.[FirstName] + ' ' + tc.LastName as ProvFullName
		  ,tc.[LastName], tc.FirstName      
	   FROM [dbo].[tmpSalesforce_Contact] tc
		  inner join dbo.tmpsalesforce_account ta on ta.id=tc.accountId
		  inner join dbo.tmpsalesforce_contract_information__C tci on tci.account_name__c=ta.id --and tci.Health_plans__c='WellCare'	   
		  ) provLookup ON m.Prov_Name = provLookup.ProvFullName


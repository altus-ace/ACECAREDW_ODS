CREATE VIEW [adw].[zz_MbrWlcProviderLookup_v2]
AS
SELECT DISTINCT 
    m.Prov_id, 
  -- provLookup.provClient_id,
    m.Prov_Name, provLookup.NPI, provLookup.TIN, provLookup.PracticeName--,provlookup.Term_date__C
FROM adi.MbrWlcMbrByPcp m
    JOIN (SELECT distinct 
		  ta.name AS PracticeName
		  ,pc.Provider_Client_ID__c as provClient_id
		  ,ta.tax_id_number__C AS TIN ,tc.[Provider_NPI__c] AS NPI
		  ,tc.[FirstName] + ' ' + tc.LastName as ProvFullName
		  ,tc.[LastName], tc.FirstName      ,pc.Term_date__C
	   FROM [dbo].[tmpSalesforce_Contact] tc
		  inner join dbo.tmpsalesforce_account ta on ta.id=tc.accountId
		  inner join dbo.tmpsalesforce_contract_information__C tci on tci.account_name__c=ta.id --and tci.Health_plans__c='WellCare' 
		  left join dbo.tmpSalesforce_Provider_Client__c pc on pc.provider_name__c=tc.id and pc.term_date__C ='' --and pc.Provider_Client_ID__c <>'' 
		  where tc.type__C not in ('UHC PCP')
		  ) provLookup ON m.Prov_id = provLookup.provClient_id
	   

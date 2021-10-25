

CREATE VIEW adi.ProvRost_DataQuality_04_NpiTermHlthPlnActive
/*  PURPOSE: NPI status termed but HPs not termed
*/
AS 
     SELECT SF_Contact.Provider_NPI__c NPI, SF_Contact.Status__c AS IsActive, SF_Contact.DEA_Expiration__c StatusTermDate, 
	   SF_ProviderClient.ProvHealthPlans HealthPlan, SF_ProviderClient.Line_of_Business__c LOB, SF_ProviderClient.Effective_Date__c, SF_ProviderClient.Term_Date__c
	   , 'PURPOSE: NPI status termed but HPs not termed' Purpose
    FROM TMPSALESFORCE_CONTACT AS SF_Contact
	   LEFT JOIN tmpSalesforce_Account SF_Account ON SF_Contact.ACCOUNTID = SF_Account.ID
	   LEFT JOIN dbo.tmpSalesforce_Provider_Client__c AS SF_ProviderClient ON SF_ProviderClient.provider_name__c = SF_Contact.id 
		  AND SF_ProviderClient.ProvHealthPlans = SF_ProviderClient.ProvHealthPlans
    WHERE SF_Contact.Status__c = 'Termed'	   
	   and ((Term_Date__c = '') OR (Term_Date__c > getdate()))

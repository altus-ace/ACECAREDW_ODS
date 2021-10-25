
CREATE VIEW adi.ProvRost_DataQuality_02_NpiWithoutTin
/*  PURPOSE: NPIs with no TINs
*/
AS 
    SELECT sf_contact.Provider_NPI__c AS NPI, SF_ProviderClient.ProvHealthPlans As NpiHealthPlan, SF_ProviderClient.Line_of_Business__c AS LOB, SF_Account.Tax_ID_Number__c AS TIN    
	   , 'PURPOSE: NPIs with no TINs' Purpose
    FROM TMPSALESFORCE_CONTACT AS SF_Contact	   
	   LEFT JOIN tmpSalesforce_Account SF_Account ON SF_Contact.ACCOUNTID = SF_Account.ID
	   LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C AS SF_ProvSpecialties ON SF_ProvSpecialties .Provider_Name__c = SF_Contact.ID
		  AND Specialtiy_Type__c = 'PRIMARY'
	   LEFT JOIN dbo.tmpSalesforce_Provider_Client__c AS SF_ProviderClient ON SF_ProviderClient.provider_name__c = SF_Contact.id 
		  AND SF_ProviderClient.ProvHealthPlans = SF_ProviderClient.ProvHealthPlans	   
    WHERE ISNULL(SF_Account.Tax_ID_Number__c,'') = ''


CREATE VIEW adi.ProvRost_DataQuality_03_TinsWithoutNpi
/*  PURPOSE: TINs with no NPIs
*/
AS 
    SELECT SF_Account.Tax_ID_Number__c AS TIN, SF_Account.Name as TinName, 'PURPOSE: TINs with no NPIs' Purpose
    FROM tmpSalesforce_Account SF_Account 
	   LEFT JOIN TMPSALESFORCE_CONTACT AS SF_Contact ON SF_Account.ID = SF_Contact.ACCOUNTID 
    WHERE ISNULL(SF_Contact.Provider_NPI__c, '') = ''

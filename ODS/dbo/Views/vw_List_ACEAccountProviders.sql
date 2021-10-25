
CREATE VIEW [dbo].[vw_List_ACEAccountProviders]
AS
     SELECT DISTINCT TOP (100) PERCENT dbo.tmpSalesforce_Account.ACE_Acct_ID1__c + dbo.tmpSalesforce_Account.ACE_Acct_ID2__c AS ACEAccountID,
                                       UPPER(dbo.tmpSalesforce_Account.Name) AS AccountName,
                                       dbo.tmpSalesforce_Account.Tax_ID_Number__c AS AccountTIN,
                                       dbo.tmpsalesforce_Account.Group_NPI_Number__c AS AccountNPI,
                                       UPPER(dbo.tmpSalesforce_Account.Type__c) AS AccountType,
                                       dbo.tmpSalesforce_Contact.ACE_Provider_ID1__c + dbo.tmpSalesforce_Contact.ACE_Provider_ID2__c AS ACEProviderID,
                                       dbo.tmpSalesforce_Contact.Provider_NPI__c AS ProviderNPI,
                                       UPPER(dbo.tmpSalesforce_Contact.FirstName)+' '+UPPER(dbo.tmpSalesforce_Contact.LastName) AS ProviderName,
                                       UPPER(dbo.tmpSalesforce_Contact.Type__c) AS ProviderType,
                                       dbo.tmpSalesforce_Contact.Provider_TIN_Number__c AS ProviderTIN,
                                       dbo.tmpSalesforce_Contact.Status__c,
							    UPPER(dbo.tmpSalesforce_Contact.FirstName) as ProviderFirstName,
							    UPPER(dbo.tmpSalesforce_Contact.LastName) as ProviderLastName
						   -- tc.[Health_Plans__c],
						  --  tc.[Line_of_Business__c]
     FROM dbo.tmpSalesforce_Account
          LEFT JOIN dbo.tmpSalesforce_Contact ON dbo.tmpSalesforce_Account.Id = dbo.tmpSalesforce_Contact.AccountId
	--LEFT JOIN [tmpSalesforce_Contract_Information__c] tc on tc.Account_Name__c=tmpSalesforce_Account.Id 
     WHERE(dbo.tmpSalesforce_Account.In_network__c = 1)
          --AND tmpSalesforce_Contact.Type__c IN('PCP') and dbo.tmpSalesforce_Account.Tax_ID_Number__c='202798379'
        --  AND (tmpSalesforce_Contact.Status__c IN('Active')
     --OR (tmpSalesforce_Contact.Status__c IS NULL)
	;



CREATE VIEW [dbo].[vw_List_ACEAccountProvidersAddressesLOB]
AS
     SELECT DISTINCT TOP (100) PERCENT dbo.tmpSalesforce_Account.ACE_Acct_ID1__c + dbo.tmpSalesforce_Account.ACE_Acct_ID2__c AS ACEAccountID,
                                       UPPER(dbo.tmpSalesforce_Account.Name) AS AccountName,
                                       dbo.tmpSalesforce_Account.Tax_ID_Number__c AS AccountTIN,
                                       dbo.tmpsalesforce_Account.Group_NPI_Number__c AS AccountNPI,
                                       UPPER(dbo.tmpSalesforce_Account.Type__c) AS AccountType,
							    UPPER(dbo.tmpSalesforce_Account.Network_Contact__c) as ACE_NETWORKCONTACT,
                                       dbo.tmpSalesforce_Contact.ACE_Provider_ID1__c + dbo.tmpSalesforce_Contact.ACE_Provider_ID2__c AS ACEProviderID,
                                       dbo.tmpSalesforce_Contact.Provider_NPI__c AS ProviderNPI,
                                       UPPER(dbo.tmpSalesforce_Contact.FirstName)+' '+UPPER(dbo.tmpSalesforce_Contact.LastName) AS ProviderName,
                                       UPPER(dbo.tmpSalesforce_Contact.Type__c) AS ProviderType,
                                       dbo.tmpSalesforce_Contact.Provider_TIN_Number__c AS ProviderTIN,
                                       dbo.tmpSalesforce_Contact.Status__c,
                                       UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'ACCOUNT_PRIMARY_ADDRESS',
                                       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'ACCOUNT_PRIMARY_CITY',
                                       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'ACCOUNT_PRIMARY_STATE',
                                       UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'ACCOUNT_PRIMARY_ZIPCODE',
							    UPPER(ISNULL(tmpSalesforce_Account_Locations__c.County__C,' ')) as ACCOUNT_PRIMARY_COUNTY,
                                       UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'ACCOUNT_PRIMARY_POD',
                                       UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'ACCOUNT_PRIMARY_ADDRESS_PHONE#',
                                       UPPER(ISNULL((tmpSalesforce_Location__c.Address_1__c+' '+tmpSalesforce_Location__c.Address_2__c), ' ')) AS 'PROVIDER_PRIMARY_ADDRESS',
                                       UPPER(ISNULL(tmpSalesforce_Location__c.City__c, ' ')) AS 'PROVIDER_PRIMARY_CITY',
                                       UPPER(ISNULL(tmpSalesforce_Location__c.State__c, ' ')) AS 'PROVIDER_PRIMARY_STATE',
                                       UPPER(ISNULL(TZ2.NAME, ' ')) AS 'PROVIDER_PRIMARY_ZIPCODE',
                                       UPPER(ISNULL(TZ2.Quadrant__c, ' ')) AS 'PROVIDER_PRIMARY_POD',
                                       UPPER(ISNULL(tmpSalesforce_Location__c.Phone__c, ' ')) AS 'PROVIDER_PRIMARY_ADDRESS_PHONE#',
                                        tc.[Health_Plans__c],                                         
						   tc.[Line_of_Business__c]
     FROM dbo.tmpSalesforce_Account
          LEFT JOIN dbo.tmpSalesforce_Contact ON dbo.tmpSalesforce_Account.Id = dbo.tmpSalesforce_Contact.AccountId
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                          AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
          LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
          LEFT JOIN tmpSalesforce_Location__c ON tmpSalesforce_Location__c.Provider_Name__c = dbo.tmpSalesforce_Contact.ID
                                                 AND tmpSalesforce_Location__c.Address_Type__c = 'Primary'
          LEFT JOIN tmpSalesforce_Zip_Code__c TZ2 ON tmpSalesforce_Location__c.ZipCode_New__c = TZ2.id
          LEFT JOIN tmpSalesforce_Contract_Information__c tc ON tc.Account_Name__c = dbo.tmpSalesforce_Account.id
                                                               -- AND tc.[Health_Plans__c] = 'UHC'
         ---- LEFT JOIN tmpSalesforce_Contract_Information__c tc1 ON tc1.Account_Name__c = dbo.tmpSalesforce_Account.id
            --                                                     AND RTRIM(tc1.[Health_Plans__c]) = 'Wellcare'
     WHERE(dbo.tmpSalesforce_Account.In_network__c = 1)
          AND tmpSalesforce_Contact.Type__c IN('PCP')
          AND (tmpSalesforce_Contact.Status__c IN('Active')
     OR (tmpSalesforce_Contact.Status__c IS NULL));


CREATE view [dbo].vw_RP_PCP_PRACTICE_LOCATIONS
   as
   SELECT DISTINCT 
       LTRIM(RTRIM(dbo.tmpSalesforce_Account.Tax_ID_Number__c)) AS TIN, 
       UPPER(LTRIM(RTRIM(dbo.tmpSalesforce_Account.Name))) AS PracticeName, 
       LTRIM(RTRIM(dbo.tmpSalesforce_Contact.Provider_NPI__c)) AS ProviderNPI, 
       UPPER(LTRIM(RTRIM(dbo.tmpSalesforce_Contact.FirstName))) AS ProviderFirstName, 
       UPPER(LTRIM(RTRIM(dbo.tmpSalesforce_Contact.LastName))) AS ProviderLastName, 
       UPPER(LTRIM(RTRIM(dbo.[tmpSalesforce_Account_Locations__c].[Location_Type__c]))) AS LocationType, 
       concat(UPPER(LTRIM(RTRIM([dbo].[tmpSalesforce_Account_Locations__c].[Address_1__c]))), ' ', UPPER(LTRIM(RTRIM([dbo].[tmpSalesforce_Account_Locations__c].[Address_2__c])))) AS Practice_Address, 
       UPPER(LTRIM(RTRIM([dbo].[tmpSalesforce_Account_Locations__c].[City__c]))) Practice_City, 
       UPPER(LTRIM(RTRIM([dbo].[tmpSalesforce_Account_Locations__c].[State__c]))) Practice_State, 
       [dbo].[tmpSalesforce_Zip_Code__c].name AS Practice_Zipcode, 
       dbo.tmpSalesforce_Account.Type__c AS Accounttype, 
       UPPER(LTRIM(RTRIM([dbo].[tmpSalesforce_Account_Locations__c].[County__c]))) Practice_County, 
       UPPER(LTRIM(RTRIM([dbo].[tmpSalesforce_Zip_Code__c].Quadrant__c))) Practice_Pod, 
       UPPER(LTRIM(RTRIM(dbo.tmpSalesforce_Account.Network_Contact__c))) Ace_Network_contact, 
       UPPER(LTRIM(RTRIM(tmpSalesforce_Account.Email__c))) AS EMAIL, 
       UPPER(LTRIM(RTRIM(tmpSalesforce_Account.CAQH_Number__c))) CAQH_number, 
       UPPER(LTRIM(RTRIM(tmpSalesforce_Account.Phone))) AS Phone, 
       UPPER(LTRIM(RTRIM(tmpSalesforce_Account.Fax))) AS Fax, 
       CONCAT(UPPER(LTRIM(RTRIM(tmpSalesforce_Provider_Client__c.ProvHealthPlans))), '-', UPPER(LTRIM(RTRIM(tmpSalesforce_Provider_Client__c.Line_of_Business__c)))) AS [Client], 
       LTRIM(RTRIM(dbo.tmpSalesforce_Contact.Provider_Medicaid_Number__c)) AS Medicaid#, 
       LTRIM(RTRIM(dbo.tmpSalesforce_Contact.Provider_Medicare_Number__c)) AS Medicare#
    FROM dbo.tmpSalesforce_Account
         LEFT JOIN dbo.tmpSalesforce_Contact ON dbo.tmpSalesforce_Account.Id = dbo.tmpSalesforce_Contact.AccountId
         LEFT JOIN [dbo].[tmpSalesforce_Account_Locations__c] ON [dbo].[tmpSalesforce_Account_Locations__c].account_name__C = dbo.tmpSalesforce_Account.id
         INNER JOIN [dbo].[tmpSalesforce_Zip_Code__c] ON [dbo].[tmpSalesforce_Zip_Code__c].id = [dbo].[tmpSalesforce_Account_Locations__c].[Zip_Code__c]
         LEFT JOIN dbo.tmpSalesforce_Provider_Client__c ON tmpSalesforce_Provider_Client__c.OwnerId = dbo.tmpSalesforce_Account.OwnerId
    WHERE(dbo.tmpSalesforce_Account.In_network__c = 1)
         AND tmpSalesforce_Contact.Type__c IN('PCP')
         AND tmpSalesforce_Account.Name NOT LIKE '%test%'
         AND tmpSalesforce_Contact.Status__c IN('Active');
      

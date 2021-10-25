CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_ProviderinSFNotinMembership]
AS
     SELECT DISTINCT 
            pc.Provider_Client_ID__c, 
            m.Prov_id, 
            --m.Prov_Name,
            -- m.loaddate,
            ta.name AS PracticeName
            ,
            --  ,pc.Provider_Client_ID__c as provClient_id 
            ta.tax_id_number__C AS TIN, 
            tc.[Provider_NPI__c] AS NPI, 
            tc.[FirstName] + ' ' + tc.LastName AS ProvFullName, 
            tc.[LastName], 
            tc.FirstName   --   ,pc.Term_date__C
     FROM acecaredw.[dbo].[tmpSalesforce_Contact] tc
          INNER JOIN acecaredw.dbo.tmpsalesforce_account ta ON ta.id = tc.accountId
			 and tc.type__C not in ('UHC PCP')  -- added this to fix doubled results for cross carrier joining: GK 12/20/2018
          INNER JOIN acecaredw.dbo.tmpsalesforce_contract_information__C tci ON tci.account_name__c = ta.id --and tci.Health_plans__c='WellCare' 
          LEFT JOIN acecaredw.dbo.tmpSalesforce_Provider_Client__c pc ON pc.provider_name__c = tc.id
                                                                         AND pc.term_date__C = '' --and pc.Provider_Client_ID__c <>''
          LEFT JOIN
     (
         SELECT DISTINCT 
                prov_id, 
                Prov_Name, 
                loaddate
         FROM adi.MbrWlcMbrByPcp
         WHERE MONTH(loaddate) = MONTH(GETDATE())
               AND YEAR(LoadDate) = YEAR(GETDATE())
     ) m ON m.Prov_id = pc.Provider_Client_ID__c
     WHERE pc.Provider_Client_ID__c IS NOT NULL
           AND m.Prov_id IS NULL;

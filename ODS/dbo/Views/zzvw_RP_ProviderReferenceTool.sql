CREATE VIEW [dbo].[zzvw_RP_ProviderReferenceTool]
AS
SELECT *
FROM (
SELECT DISTINCT
       UPPER(ISNULL(ltrim(rtrim(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c)), ' ')) AS 'TAX_ID',
        CASE WHEN ( ltrim(rtrim(  UPPER(CAST(STUFF((
		  SELECT ', '+provider_Client_id__c
		  FROM tmpSalesforce_Provider_Client__c tsccl
		  WHERE tsccl.Provider_Name__c = PC.Provider_Name__c FOR XML PATH('')
		  ), 1, 1, '') AS VARCHAR(100)))))) IS NULL THEN '' ELSE 'X' END  AS WELLCARE
    
FROM TMPSALESFORCE_CONTACT
     LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
                                                       AND td2.Degree_Name__c <> '(OTHER)'
                                                       AND td2.Degree_Name__c <> ' '
     LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                        AND Specialtiy_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Location__c ON tmpSalesforce_Location__c.[Provider_Name__c] = TMPSALESFORCE_CONTACT.ID
                                            AND tmpSalesforce_Location__c.[Address_Type__c] = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Location__c.[ZipCode_New__c] = tmpSalesforce_Zip_Code__c.ID
     LEFT JOIN [dbo].[tmpSalesforce_Additional_Contact__c] ON [dbo].[tmpSalesforce_Additional_Contact__c].Account_Name__c = tmpSalesforce_Account.id
                                                              AND [tmpSalesforce_Additional_Contact__c].Title__c LIKE 'Office%'
	left join  tmpSalesforce_Provider_Client__c pc on pc.Provider_Name__c= TMPSALESFORCE_CONTACT.id and PC.term_date__c =' '
                                                                 and PC.provHealthplans ='Wellcare' 
													and PC.provider_Client_id__c <>''
WHERE tmpSalesforce_Contact.Status__c = 'Active'
      AND tmpsalesforce_Contact.Type__c NOT IN('UHC PCP')
     AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
AND TMPSALESFORCE_ACCOUNT.NAME NOT LIKE '%TEST%' 
) s
where s. WELLCARE = 'X';




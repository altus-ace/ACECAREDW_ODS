
CREATE VIEW [dbo].[vw_RP_NCQA_OtherEntities]
AS
     SELECT DISTINCT
		UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'ENTITY NAME',
		--UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.NAME,' ')) AS 'PRACTICE SITE NAME',
		 --  UPPER(ISNULL(TMPSALESFORCE_Contact.FirstName,' '))+' '+UPPER(ISNULL(TMPSALESFORCE_Contact.LastName,' ')) AS 'PROVIDER NAME',
		  -- tmpSalesforce_Contact.Type__c,
	          UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c), ' ')) AS 'ADDRESS 1',
		  UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'ADDRESS 2',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS ' STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'ZIPCODE',
            UPPER(ISNULL(tmpSalesforce_Account.Main_Contact__c, ' ')) AS 'CONTACT FIRST AND LAST NAME',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PHONE NUMBER',
		
		  UPPER(ISNULL(tmpsalesforce_Account.Type__c,' ')) AS 'ENTITY ROLE IN THE ACO'
		   FROM TMPSALESFORCE_Contact
          LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
          LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
	    -- AND tmpSalesforce_Account_Locations__c.Location_Type__c='PRIMARY'
          LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
		 
          WHERE tmpSalesforce_aCCOUNT.Termination_with_cause__c IS NULL
           AND tmpsalesforce_account.Type__c IN('FQHC','Ancillary')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
		AND FIRSTNAME NOT IN ('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1'

	union
	SELECT DISTINCT
		UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'ENTITY NAME',
		--UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.NAME,' ')) AS 'PRACTICE SITE NAME',
		--   UPPER(ISNULL(TMPSALESFORCE_Contact.FirstName,' '))+' '+UPPER(ISNULL(TMPSALESFORCE_Contact.LastName,' ')) AS 'PROVIDER NAME',
		  -- tmpSalesforce_Contact.Type__c,
	          UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c), ' ')) AS 'ADDRESS 1',
		  UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'ADDRESS 2',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS ' STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'ZIPCODE',
            UPPER(ISNULL(tmpSalesforce_Account.Main_Contact__c, ' ')) AS 'CONTACT FIRST AND LAST NAME',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PHONE NUMBER',
		
		  UPPER(ISNULL(tmpsalesforce_Account.Type__c,' ')) AS 'ENTITY ROLE IN THE ACO'
		   FROM TMPSALESFORCE_Contact
          LEFT JOIN tmpSalesforce_Provider_Degree__c TD2 ON TD2.CONTACT__C = TMPSALESFORCE_CONTACT.ID
          LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
	  --   AND tmpSalesforce_Account_Locations__c.Location_Type__c='PRIMARY'
          LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
		 
          WHERE tmpSalesforce_aCCOUNT.Termination_with_cause__c in ('ACTIVE')
           AND tmpsalesforce_account.Type__c IN('FQHC','Ancillary')
          AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
		AND FIRSTNAME NOT IN ('TEST', 'TESTLAST', 'ACETEST','  CAINTEST')
     AND tmpsalesforce_Account.in_Network__c = '1'
CREATE FUNCTION [dbo].[tvf_RP_AccountPODNetworkcontact](@EffectiveDate DATE , @ENDDATE DATE)
RETURNS TABLE
AS
     RETURN
(

SELECT distinct
       UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAXID',
       UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE_NAME',
	  UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.CreatedDate,' ')) AS 'CREATED_DATE',
       UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'PRIMARY_ADDRESS',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'PRIMARY_CITY',
       UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'PRIMARY_STATE',
       UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'PRIMARY_ZIPCODE',
       UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY_POD',
	  upper(isnull(tmpSalesforce_Account.network_contact__C,' ')) as 'NETWORK_CONTACT'
  FROM TMPSALESFORCE_CONTACT
     LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                        AND tmpSalesforce_Account.IN_NETWORK__c = 1
     LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                     AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
     LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID

WHERE tmpSalesforce_Contact.Status__c IN ('ACTIVE')
      AND tmpsalesforce_Contact.Type__c IN('PCP')
     AND LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')

AND tmpsalesforce_Account.in_Network__c = '1'
AND CONVERT(DATE,TMPSALESFORCE_ACCOUNT.CreatedDate) BETWEEN @EffectiveDate AND @ENDDATE

)

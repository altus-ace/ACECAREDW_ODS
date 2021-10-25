

CREATE view [dbo].[vw_RP_255_mbrship_LOB_count_UHC]
as
SELECT DISTINCT a.[NPI]
	,CONCAT(a.[LAST NAME],', ',a.[FIRST NAME]) as PROVIDER_NAME
	,a.[PRACTICE NAME]
	,b.PLAN_ID
	,count(b.PLAN_ID) AS LOB_COUNT
	,DATENAME(MONTH,b.A_LAST_UPDATE_DATE) +'-'+ DATENAME(YEAR,b.A_LAST_UPDATE_DATE) as MBRSHIP_MTH
FROM 
( SELECT DISTINCT
            TMPSALESFORCE_CONTACT.PROVIDER_NPI__C AS 'NPI',
		  upper(isnull(tmpsalesforce_Contact.Type__c,' ')) as 'PROVIDER TYPE',
                  UPPER(ISNULL(TMPSALESFORCE_CONTACT.LASTNAME, ' ')) AS 'LAST NAME',
            UPPER(ISNULL(TMPSALESFORCE_CONTACT.FIRSTNAME, ' ')) AS 'FIRST NAME',
            UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.Tax_ID_Number__c, ' ')) AS 'TAX ID',
            UPPER(ISNULL(TMPSALESFORCE_PROVIDER_Specialties__C.Speciality_Name_CAQH__c, ' ')) AS 'PRIMARY SPECIALTY',
		  UPPER(ISNULL(TSS2.Speciality_Name_CAQH__c, ' ')) AS 'SECONDARY SPECIALTY',
		  UPPER(ISNULL(TMPSALESFORCE_ACCOUNT.NAME, ' ')) AS 'PRACTICE NAME',
            UPPER(ISNULL((tmpSalesforce_Account_Locations__c.Address_1__c+' '+tmpSalesforce_Account_Locations__c.Address_2__c), ' ')) AS 'PRIMARY ADDRESS',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.City__c, ' ')) AS 'PRIMARY CITY',
            UPPER(ISNULL(tmpSalesforce_Account_Locations__c.State__c, ' ')) AS 'PRIMARY STATE',
            UPPER(ISNULL(tmpSalesforce_Zip_Code__c.NAME, ' ')) AS 'PRIMARY ZIPCODE',
            UPPER(ISNULL(tmpsalesforce_zip_code__c.Quadrant__c, ' ')) AS 'PRIMARY POD',
		  UPPER(ISNULL(tmpsalesforce_zip_code__c.pod__c, ' ')) AS 'PRIMARY Quadrant',
            UPPER(ISNULL(tmpSalesforce_Account_LocationS__C.Phone__c, ' ')) AS 'PRIMARY ADDRESS PHONE#',
		  UPPER(ISNULL(tmpSalesforce_Contact.Status__c,' ')) AS STATUS
		 , tc.Health_Plans__c as CLIENT
		 ,tmpSalesforce_Account.TYPE__c AS 'ACCOUNT TYPE'
		 ,tmpSalesforce_Account.NETWORK_CONTACT__c
           FROM TMPSALESFORCE_CONTACT
           LEFT JOIN tmpSalesforce_Account ON TMPSALESFORCE_CONTACT.ACCOUNTID = tmpSalesforce_Account.ID
                                             AND tmpSalesforce_Account.IN_NETWORK__c = 1
          LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C ON TMPSALESFORCE_PROVIDER_SPECIALTIES__C.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND Specialtiy_Type__c = 'PRIMARY'
	   LEFT JOIN TMPSALESFORCE_PROVIDER_Specialties__C TSS2 ON TSS2.Provider_Name__c = TMPSALESFORCE_CONTACT.ID
                                                             AND TSS2.Specialtiy_Type__c = 'SECONDARY'
          LEFT JOIN tmpSalesforce_Account_Locations__c ON tmpSalesforce_Account_Locations__c.Account_Name__c = TMPSALESFORCE_ACCOUNT.ID
                                                         AND tmpSalesforce_Account_Locations__c.Location_Type__c = 'PRIMARY'
                  LEFT JOIN tmpSalesforce_Zip_Code__c ON tmpSalesforce_Account_Locations__c.Zip_Code__c = tmpSalesforce_Zip_Code__c.ID
			 	inner JOIN [tmpSalesforce_Contract_Information__c] tc on tc.Account_Name__c=tmpSalesforce_Account.Id
              WHERE tmpSalesforce_Contact.Status__c In ('ACTIVE')
--          AND 			tmpsalesforce_Contact.Type__c  NOT IN('UHC PCP')
     and     tmpsalesforce_Contact.LASTNAME NOT IN('TEST', 'TESTLAST', 'ACETEST')
		and tmpSalesforce_Account.Name not like '%Test%'
     AND tmpsalesforce_Account.in_Network__c = '1'

--	 and TMPSALESFORCE_CONTACT.PROVIDER_NPI__C = '1265568042'
	 and tc.Health_Plans__c = 'UHC') a
INNER JOIN acecaredw.dbo.UHC_MembersByPCP b ON b.PCP_NPI = a.NPI
--INNER join ACECAREDW.adi.MbrAetMbrByPcp c on  c.NPI = a.NPI
WHERE a.STATUS = 'Active'
	and CLIENT = 'UHC'
	and b.loadtype = 'P'
	AND b.A_LAST_UPDATE_DATE between '2017-08-24' and '2018-09-06'
GROUP BY a.client
	,a.[FIRST NAME]
	,a.[LAST NAME]
	,a.[PRACTICE NAME]
	,a.[NPI]
	,b.plan_id
	,b.A_LAST_UPDATE_DATE


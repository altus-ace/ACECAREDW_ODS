



 CREATE view [dbo].[vw_RP_SPECIALIST_PRACTICE_LOCATIONS]
   as
   SELECT DISTINCT                ltrim(rtrim(c.Provider_NPI__c)) AS ProviderNPI,
 ltrim(rtrim(a.[Tax_ID_Number__c])) as TIN,
 upper(ltrim(rtrim(a.name))) as Practice_Name,
							  UPPER(ltrim(rtrim(c.FirstName))) as ProviderFirstName,
						  UPPER(ltrim(rtrim(c.LastName))) AS ProviderLastName,
								upper(ltrim(rtrim(c1.[Address_Type__c]))) as LocationType,
							  concat(  upper(ltrim(rtrim(c1.[Address_1__c])))
						  ,' '
							   ,upper(ltrim(rtrim(c1.[Address_2__c])))) as Practice_Address
								,upper(ltrim(rtrim(c1.[City__c]))) Practice_City
								,upper(ltrim(rtrim(c1.[State__c]))) Practice_State
								,c2.name as Practice_Zipcode
								,upper(ltrim(rtrim(c1.[County__c]))) Practice_County
								,upper(ltrim(rtrim(c2.Quadrant__c))) Practice_Pod
								,UPPER(LTRIM(RTRIM(a.Network_Contact__c))) Ace_Network_contact
    ,upper(ltrim(rtrim(c.email))) as EMAIL
	,upper(ltrim(rtrim(Provider_CAQH_Number__c))) CAQH_number
	,UPPER(Ltrim(rtrim(c.Phone))) as Phone
	,UPPER(Ltrim(rtrim(c.Fax))) as Fax
	,CONCAT(UPPER(ltrim(rtrim(tmpSalesforce_Provider_Client__c.ProvHealthPlans))),'-',UPPER(ltrim(rtrim(tmpSalesforce_Provider_Client__c.Line_of_Business__c)))) as [Client]
	      ,ltrim(rtrim(c.Provider_Medicaid_Number__c)) AS Medicaid#
	 ,ltrim(rtrim(c.Provider_Medicare_Number__c)) AS Medicare#
	 FROM acecaredw.dbo.[tmpSalesforce_Contact] c
	left join acecaredw.dbo.tmpSalesforce_Account a on a.id=c.AccountId
	left join acecaredw.[dbo].[tmpSalesforce_Location__c] c1 on c1.[Provider_Name__c]=c.id
	inner join acecaredw.[dbo].[tmpSalesforce_Zip_Code__c] c2 on c2.id=c1.ZipCode_New__c
	left join acecaredw.dbo.tmpSalesforce_Provider_Client__c on tmpSalesforce_Provider_Client__c.OwnerId = c.OwnerId
     WHERE c.status__C in ('Active') and c.type__c  in ('Specialist')


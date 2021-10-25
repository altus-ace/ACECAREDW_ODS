
CREATE VIEW [dbo].[vw_AH_ProviderAddress]
AS
    /*  Purpose pulls all available address and formates them to export to AHS
    Change Log    
    09/3/2020: GK 
	   due to the business need for addresses being only to get the addresses into AHS,
	   the export pulls from the latest temp tables (gettin the latest temp data)
	   Added a 

	   */
     SELECT DISTINCT
            SF_Contact.Provider_NPI__c AS PROVIDER_ID,
            --case when tci.[Health_Plans__c] is null then 'UHC' else tci.[Health_Plans__c] end AS CLIENT_ID,
		  /* client id removed since it is not used in the export etl */
            UPPER(SF_ProvLoc .Address_Type__c) AS [ADDRESS TYPE],
            UPPER(REPLACE(SF_ProvLoc.Address_1__c, ',', ' ')) AS [ADDRESS 1],
            UPPER(REPLACE(SF_ProvLoc.Address_2__c, ',', ' ')) AS [ADDRESS 2],
            UPPER(REPLACE(' ', ',', ' ')) AS [ADDRESS 3],
            UPPER(SF_ProvLoc.City__c) AS CITY,
            SF_ProvLoc.State__c AS [STATE],
            UPPER(REPLACE(SF_ProvLoc.County__c, 'COUNTY', '')) AS COUNTY,
            SF_Zips.NAME AS ZIPCODE,
            SF_ProvLoc.Phone__c AS TELEPHONE,
            SF_ProvLoc.Fax__c AS FAX,
            SF_ProvLoc.Location_Email_Address__c AS [EMAIL ADDRESS],
            ' ' AS [EFFECTIVE DATE],
            ' ' AS [TERM DATE],
            CASE
                WHEN SF_AcceptPats.Patient_Type__c IS NOT NULL
                THEN 'Y'
                ELSE ' '
            END AS [ACCEPTING NEW PATIENTS Y/N?],
            'A' AS ADDRESS_ADDITIONAL_INFORMATION_2,
            CAST(STUFF((	   SELECT ';'+tm.Day_of_the_Week__c+' '+tm.Start_Hours__c+' - '+tm.End_Hours__c
					   FROM dbo.tmpsalesforce_practice_hours__c tm
					   WHERE tm.Location_Name__c = tm3.Location_Name__c FOR XML PATH('')
					   ), 1, 1, '') AS VARCHAR(100)) AS 'OFFICE HOURS',
            SF_Zips.Quadrant__C AS POD,
            UPPER(SF_ProvLoc.Patient_Gender_Limitation__c) AS AGE_SEEN,
            'TEST' AS 'WALK_IN',
            UPPER(SF_ProvLoc.Location_Note__c) AS NOTE
     FROM dbo.tmpSalesforce_Contact SF_Contact
          LEFT JOIN dbo.tmpSalesforce_Location__c SF_ProvLoc ON SF_Contact.Id = SF_ProvLoc .Provider_Name__c
          LEFT JOIN dbo.tmpSalesforce_Zip_Code__c SF_Zips ON SF_Zips.Id = SF_ProvLoc.ZipCode_New__c
          LEFT JOIN dbo.tmpSalesforce_Account SF_Account ON SF_Account.Id = SF_Contact.AccountId
          LEFT JOIN dbo.tmpSalesforce_Accepting_Patient_Type__c SF_AcceptPats ON SF_ProvLoc .Id = SF_AcceptPats.Location_Name__c
          LEFT JOIN dbo.tmpsalesforce_practice_hours__c tm3 ON SF_ProvLoc .id = tm3.Location_Name__c		
		LEFT JOIN (SELECT cl.Provider_Name__c, cl.Name, cl.Line_of_Business__c, cl.ProvHealthPlans, cl.Effective_Date__c, cl.Term_Date__c
				FROM dbo.tmpSalesforce_Provider_Client__c cl) SF_ProvContractInfo
			 ON SF_Contact.Id = SF_ProvContractInfo.Provider_Name__c
				AND GETDATE() BETWEEN SF_ProvContractInfo.Effective_Date__c 
				AND COALESCE(NULLIF(SF_ProvContractInfo.Term_Date__c,''), '12/31/2099')
	   LEFT JOIN (SELECT NPI FROM adw.fctProviderRoster pr where getdate() between pr.RowEffectiveDate and pr.RowExpirationDate group by pr.Npi) ProvRost
		  ON SF_Contact.Provider_NPI__c = ProvRost.NPI	        
     WHERE(SF_Contact.Provider_NPI__c <> ' ')  and /*AND (dbo.tmpSalesforce_Location__c.Address_Type__c IS NOT NULL) */
           (SF_Contact.Status__c in ('ACTIVE')) AND 
		 (SF_Account.In_network__c = '1') AND 
		 (SF_Contact.FirstName NOT LIKE '%TEST%') AND 
		 SF_Contact.Provider_NPI__c IS NOT NULL AND 
		 SF_ProvLoc.Address_Type__c IS NOT NULL	


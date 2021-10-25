
CREATE PROCEDURE ast.Validate_Staging_PR

AS

SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Accepting_Patient_Type__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Account
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Account_Locations__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Contact
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Location__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Location_Language__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Practice_Hours__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Boards_Certifications__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_DEA_License__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Hospital_Privilege__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Insurance__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Language_Spoken__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Medicaid_License__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Medical_License__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Medicare_Licenses__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Provider_Specialties__c
SELECT MIN(A_last_Update_Date) minUpdate, MAX(A_Last_Update_date)maxUpdate  FROM dbo.tmpSalesforce_Zip_Code__c
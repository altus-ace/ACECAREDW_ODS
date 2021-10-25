create view vw_RP_POD_ZIPCODE
AS

SELECT        Name AS Zipcode, Quadrant__c AS POD,POD__c as Quadrant
FROM            dbo.tmpSalesforce_Zip_Code__c
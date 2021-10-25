
CREATE VIEW [dbo].[vw_EXP_AH_PodAssignment]
AS
SELECT        'UHC' AS CLIENT_ID, Name AS Zipcode, Quadrant__c AS POD
FROM            dbo.tmpSalesforce_Zip_Code__c
Create View dbo.[yy_vw_AllClient_ProviderRoster_UpdateFctSource]
AS
	SELECT src.SF_Npi, src.ProvHealthPlan_New, src.ProvLOB_New
		, CONVERT(DATE, src.ProvHealthPlan_EffDate_New) ProvHealthPlan_EffDate_New
		, CONVERT(DATE, src.ProvHealthPlan_ExpDate_New) ProvHealthPlan_ExpDate_New
	FROM (SELECT DISTINCT sf_Provider.Provider_NPI__c SF_Npi
					, sf_ProvContractInfo.Line_of_Business__c ProvLOB_New
					, SF_ProvContractInfo.ProvHealthPlans ProvHealthPlan_New
					, SF_ProvContractInfo.Effective_Date__c ProvHealthPlan_EffDate_New
					, CASE WHEN (SF_ProvContractInfo.Term_Date__c = '') THEN '12/31/2099'
							ELSE SF_ProvContractInfo.Term_Date__c  END AS ProvHealthPlan_ExpDate_New
					, ROW_NUMBER() OVER (PARTITION BY sf_Provider.Provider_NPI__c
								, sf_ProvContractInfo.Line_of_Business__c, SF_ProvContractInfo.ProvHealthPlans 
								ORDER BY  SF_ProvContractInfo.Term_Date__c DESC, SF_ProvContractInfo.Effective_Date__c DESC ) aRowNumber
					
			FROM dbo.tmpSalesforce_Contact SF_Provider --ON pr.NPI = SF_Provider.Provider_NPI__c
				LEFT JOIN (SELECT cl.Provider_Name__c, cl.Name, cl.Line_of_Business__c, cl.ProvHealthPlans, cl.Effective_Date__c, cl.Term_Date__c
							, ROW_NUMBER() over (PARTITION BY cl.Provider_Name__c, cl.Line_of_Business__c, cl.ProvHealthPlans 
													ORDER BY cl.Effective_Date__c DESC, cl.Term_Date__c DESC)	aRowNum
							FROM dbo.tmpSalesforce_Provider_Client__c cl			
						) SF_ProvContractInfo
					ON SF_Provider.Id = SF_ProvContractInfo.Provider_Name__c
						AND GETDATE() BETWEEN SF_ProvContractInfo.Effective_Date__c 
						AND COALESCE(NULLIF(SF_ProvContractInfo.Term_Date__c,''), '12/31/2099')
						AND SF_ProvContractInfo.aRowNum = 1
			WHERE ISNULL(SF_ProvContractInfo.Line_of_Business__c, '') <> ''
				AND ISNULL(SF_ProvContractInfo.ProvHealthPlans, '') <> ''
		) src
	WHERE src.aRowNumber = 1

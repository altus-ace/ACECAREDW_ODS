

 
 CREATE VIEW [dbo].[vw_RP_Wlccareopps_byTIN]
 As
 SELECT distinct ta.tax_id_number__C AS TIN
		  ,ta.name AS PRACTICE_NAME,
		 CASE WHEN a.total_care_gaps IS NULL THEN 0 ELSE a.total_care_gaps END AS TOTAL_CARE_GAPS,
		 CASE WHEN a.num_memb_w_care_gap IS NULL THEN 0 ELSE a.num_memb_w_care_gap  END AS NUMBER_OF_MEMB_WITH_CARE_GAPS,
		   CASE WHEN B.CNT IS NULL THEN 0 ELSE B.CNT END AS  MEMB_CNT,
            CASE WHEN CAST(A.total_care_gaps AS FLOAT) / B.CNT IS NULL THEN 0 ELSE Round ((CAST(A.total_care_gaps AS FLOAT)  / B.CNT ),2) 
		     END   AS GAPS_OVER_MEMB_CNT
	   FROM acecaredw.[dbo].[tmpSalesforce_Contact] tc
		  inner join acecaredw.dbo.tmpsalesforce_account ta on ta.id=tc.accountId
		  inner join acecaredw.dbo.tmpsalesforce_contract_information__C tci on tci.account_name__c=ta.id and tci.Health_plans__c='WellCare' 
		  left join acecaredw.dbo.tmpSalesforce_Provider_Client__c pc on pc.provider_name__c=tc.id and pc.term_date__C ='' 
	
 left join (

    SELECT TIN_Num,
           TIN_Name,
           SUM(TotalGaps) AS total_care_gaps,
           COUNT(DISTINCT memberId) AS num_memb_w_care_gap
    FROM vw_RP_WlcCareopps_details A
    GROUP BY TIN_Num,
             TIN_Name
) A  on convert(int,a.tin_num)=convert(int,ta.tax_id_number__C)
LEFT JOIN
(
    SELECT distinct CASE
               WHEN LEN(PCP_PRACTICE_TIN) = 8
               THEN concat('0', PCP_PRACTICE_TIN)
               ELSE PCP_PRACTICE_TIN
           END AS PCP_PRACTICE_TIN,
           COUNT(DISTINCT MEMBER_ID) AS CNT
    FROM vw_ActiveMembers
    where CLIENT='WLC'
    GROUP BY PCP_PRACTICE_TIN
) B on convert(int,b.PCP_PRACTICE_TIN)=convert(int,ta.tax_id_number__C)
	  where pc.Provider_Client_ID__c is not null




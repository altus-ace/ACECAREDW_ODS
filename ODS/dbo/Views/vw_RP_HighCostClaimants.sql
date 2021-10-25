





/**************************************************************
Created by : AC
Create Date : 10/08/2019
Description : 
				

Modification:
 Date		User   Comment
 10/25/2019  AC    Updated column name - report month 
 10/28/2019  AC    Added client column and Plans
 Trying to build a report which can be used on demand by quality dept,
 List of all Claimants, High cost claimants 
 Example - ALTUS_ACE_Ops_Claims trough 201903

 11/11/2019 AC    Added Practice Name column 
 The below column names are defined as per the excel sheet and analysis.


******************************************************************/

CREATE VIEW [dbo].[vw_RP_HighCostClaimants]
AS

SELECT DISTINCT	   
	   'UHC' as 'Client',
       [uhc_subscriber_id] as SubscriberID, 
	   [member_last_name]  as 'Member FirstName', 
	   [member_first_name] as 'Member LastName' , 
	   [date_of_birth] as 'DOB',
	   [ipro_admit_risk_score] as 'Prospective Risk', 
	   [LINE_OF_BUSINESS] as Plans,
       [pcp_name] as 'PCP Name', 
	   [PCP_PRACTICE_NAME] as 'Practice Name',
       [primary_risk_factor] as 'Primary Diagnosis', 
       Cast([total_costs_last_12_mos] AS MONEY)                          AS 
       'Total Net Paid Last 12 Months ', 
       [count_open_care_opps], 
       [inp_costs_last_12_mos]                                           AS 
       'I/P Costs Last 12 Months', 
       [er_costs_last_12_mos] 'ER Costs Last 12 Months', 
       [outp_costs_last_12_mos]                                          AS 
       'O/P Costs Last 12 Months', 
       [pharmacy_costs_last_12_mos]                                      AS 
       'Pharmacy Costs Last 12 Months', 
       primary_care_costs_last_12_mos, 
       other_office_costs_last_12_mos, 
       Cast(Replace(other_office_costs_last_12_mos, '$', '') AS MONEY) 
       + Cast(Replace(primary_care_costs_last_12_mos, '$', '') AS MONEY) AS 
       'Physician Cost', 
       [inp_admits_last_12_mos]                                          AS 
       Admits, 
       [er_visits_last_12_mos]                                           AS 
       'ER Visits Last 12 Months', 
       [last_pcp_visit], 
       [last_pcp_practice_seen], 
        concat(ltrim(rtrim([report_month])),'01') as Report_Month, 
       [a_last_update_date] 
--  ,row_number() over (partition by  [UHC_SUBSCRIBER_ID] order by [FILE_GENERATION_DATE] desc) as arn 
FROM   uhc_membership c 
WHERE 
  --c.UHC_SUBSCRIBER_ID = '114930096'  and 
  Year(a_last_update_date) > '2018' 
  and Cast([total_costs_last_12_mos] AS MONEY) >'24,999'
--- AND other_office_costs_last_12_mos IS NOT NULL 




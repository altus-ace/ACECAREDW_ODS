



CREATE VIEW [dbo].[vw_AH_PE_WLC_Careopps_V1]
As
    Select distinct
     'WellCare' as Client_id,
	map.DESTINATION_PROGRAM_NAME as PROGRAM_NAME,
	 CO.subscriber AS MEMBER_ID,
	CONVERT(VARCHAR(10),DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE()),0),120) AS ENROLL_DATE,
	CONVERT(DATE,CO.A_LAST_UPDATE_DATE,101) AS CREATE_DATE,
	 CONVERT(DATE, '12/31/2019', 101) AS ENROLL_END_DATE,
	   convert(nvarchar,RTRIM('ACTIVE')) AS PROGRAM_STATUS,
	    'Enrolled in a Program' AS REASON_DESCRIPTION,
	     'WLC CareOpps' AS REFERAL_TYPE
    from (
   SELECT DISTINCT
           wc.Subscriber,
           wc.Measure,

			 
       case when ( 
	   CONVERT(int, CASE
               WHEN(wc.ComplianceStatus = 'In-Play - 100%')
               then     right( left(RIGHT(wc.ComplianceStatus, (LEN(wc.ComplianceStatus)-7)),6),3) 
              
               WHEN(wc.ComplianceStatus LIKE 'in%') and wc.ComplianceStatus <> 'In-Play - 100%'
               then     left(right( left(RIGHT(wc.ComplianceStatus, (LEN(wc.ComplianceStatus)-7)),6),3),2) 
           END)
		 ) between 80 and 100 then  'Compliant' Else 'Non-Compliant' end
		  AS ComplianceStatus,
		CONVERT(DATE,WC.ServiceStartDate) AS ENROLL_DATE,
		wc.ServiceEndDate,
           wc.ComplianceDetail,
           wc.A_LAST_UPDATE_FLAG,
		 wc.A_LAST_UPDATE_DATE
    FROM tmpWLC_careopps wc
    where wc.ComplianceStatus like 'In%'
    union 
    SELECT DISTINCT
           wc1.Subscriber,
           wc1.Measure,
           wc1.ComplianceStatus,
		 CONVERT(DATE,WC1.ServiceStartDate) AS ENROLL_DATE,
		 wc1.ServiceEndDate,
		 wc1.ComplianceDetail,
           wc1.A_LAST_UPDATE_FLAG,
		  wc1.A_LAST_UPDATE_DATE
    FROM tmpWLC_careopps wc1
    where wc1.ComplianceStatus not like 'In%') as co
         INNER JOIN
(
    SELECT DISTINCT
           Member_id,MEMBER_CUR_EFF_DATE
    FROM vw_ActiveMembers where client='WLC'
) a ON CONVERT(INT, a.member_id) = CONVERT(INT, co.subscriber)
inner join acecaredw.dbo.ACE_MAP_CAREOPPS_PROGRAMS map on map.SOURCE_MEASURE_NAME=co.Measure 
and map.destination='Altruista' and MAP.is_active=1 
AND MAP.SOURCE='WellCare'
where co.ComplianceStatus='Non-Compliant' and CO.A_LAST_UPDATE_FLAG='Y' 
--ORDER BY MEMBER_ID



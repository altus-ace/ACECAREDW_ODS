






CREATE VIEW [dbo].[vw_AH_PH_WLC_careopps]
AS
    Select distinct
     map.source as Client_id,
	 CO.subscriber AS MEMBER_ID,
	   concat(ltrim(rtrim(M.SOURCE_MEASURE_ID)),'-',ltrim(rtrim(M.SOURCE_MEASURE_NAME))) AS OPPURTUNITY,
            ltrim(rtrim(M.SOURCE_MEASURE_ID)) AS MEASURE_CODE,
		  ltrim(rtrim(M.Source)) as MEASURE_CATEGORY,
		   --case when pr.PROGRAM_STATUS_NAME='ACTIVE' then 'Not Addressed'
		  --when pr.PROGRAM_STATUS_NAME='In Progress' then 'In Progress'
		--  when pr.PROGRAM_STATUS_NAME='CLOSE-PENDING CLAIMS' then 'Completed' 
		--  else 
		'Not Addressed'  AS 'STATUS', 
          	CONVERT(DATE,CO.A_LAST_UPDATE_DATE,101) AS DATE_IDENTIFIED,
            YEAR(GETDATE()-1) AS MEASURE_VERSION
		-- , pr.CLIENT_PATIENT_ID,
	-- pr.PROGRAM_STATUS_NAME,
	--	 pr.PROGRAM_NAME
    from (
    SELECT DISTINCT
           wc.Subscriber,
           wc.Measure,
       case when ( 
	   CONVERT(int, CASE
               WHEN(wc.ComplianceStatus = 'In-Play - 100%')
               then     LEFT(RIGHT(wc.ComplianceStatus, LEN(wc.ComplianceStatus) - 9), 4) 
              
               WHEN(wc.ComplianceStatus LIKE 'in%') and wc.ComplianceStatus <> 'In-Play - 100%'
               then     LEFT(RIGHT(wc.ComplianceStatus, LEN(wc.ComplianceStatus) - 9), 3)
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
) a ON  a.member_id =  co.subscriber
inner join (SELECT *
    FROM ACE_MAP_CAREOPPS_PROGRAMS
            WHERE is_active=1) map on map.SOURCE_MEASURE_NAME=co.Measure 
and map.destination='Altruista' and MAP.is_active=1 and map.SOURCE='Wellcare'
  inner join (SELECT *
    FROM [ACE_MAP_PROGRAMS_HEDIS]
    WHERE [Source] = 'hedis'
          AND Destination = 'ALTRUISTA'
) AS M ON M.Destination_program_name = map.DESTINATION_PROGRAM_NAME and M.IS_ACTIVE=1
AND MAP.SOURCE='WellCare'

left join (
	Select CLIENT_PATIENT_ID,
	PROGRAM_NAME,START_DATE,end_date,PROGRAM_STATUS_NAME from Ahs_Altus_Prod.dbo.vw_ACE_ALT_PE
 where YEAR(start_date)=YEAR(getdate()-1)) as  pr on pr.client_patient_id=co.Subscriber
 and pr.PROGRAM_NAME=map.DESTINATION_PROGRAM_NAME
where co.ComplianceStatus='Non-Compliant' and CO.A_LAST_UPDATE_FLAG='Y' 
--ORDER BY MEMBER_ID











CREATE view [dbo].[vw_AH_PE_UHC_Microincentive]
as
select 'UHC' as [Client_id]
    ,p.Destination_program_name as [PROGRAM_NAME]
    ,m.subscriber_id as [MEMBER_ID]
    ,CONVERT(VARCHAR(10),DATEADD(MONTH, DATEDIFF(MONTH,0,GETDATE()),0),120) AS ENROLL_DATE
    ,CONVERT(DATE,m.loaddate,101) AS CREATE_DATE
    ,CONVERT(DATE, '12/31/2018', 101) AS ENROLL_END_DATE
     ,convert(nvarchar,RTRIM('ACTIVE')) AS PROGRAM_STATUS
	 ,'Enrolled in a Program' AS REASON_DESCRIPTION
	     ,'UHC-Microincentive' AS REFERAL_TYPE
 from adi.MbrUhcMicroIncentives m
inner join acecaredw.[dbo].[ACE_MAP_CAREOPPS_PROGRAMS] p on ltrim(rtrim(p.Source_measure_name))= ltrim(rtrim(m.MeasureAndLOB))
 and p.Source='UHC_MI' 







CREATE VIEW [dbo].[vw_RP_CCProgramCounts]
AS
     SELECT DISTINCT
       LOB,Department,Program,programStatus,COUNT(totalmembers) as TotalMembers,mm,month_appeared from (
  
  SELECT DISTINCT
            LOB,
		  case when  PROGRAM_NAME  IN('Transitions of Care- Inpatient-2'
		 , 'Transitions of Care-Emergency Room'
		 , 'Transitions of Care-Emergency Room-2'
		 , 'Transitions of Care-Mental Health'
		 , 'Transitions of Care-Mental Health-2'
		 , 'High Risk', 'High Risk Cohort'
		 , 'High Utilizer Emergency Room Visits'
		 , 'High Utilizers Inpatient Admission'
		 , 'Diabetes Management'
		 , 'Transitions of Care- Inpatient') then 'ICT' else 'CC' end as Department,
            LTRIM(RTRIM(Program_name)) AS Program,
		  LTRIM(RTRIM(Program_status_name)) as ProgramStatus,
            Client_patient_id AS TotalMembers,
		  month(start_Date) as mm,
            convert(nvarchar(10),concat(MONTH(CONVERT(DATE, start_date)), ' - ', YEAR(CONVERT(DATE, start_date)))) AS Month_appeared
		 -- Updated_on
     FROM ahs_altus_prod.dbo.[vw_ACE_ALT_PE]
     WHERE YEAR(start_date) >= '2018' --and MONTH(start_date)=11 and LOB='UHC' and PROGRAM_NAME='Newly Enrolled'
      /*     AND PROGRAM_NAME NOT IN('Transitions of Care- Inpatient-2'
		 , 'Transitions of Care-Emergency Room'
		 , 'Transitions of Care-Emergency Room-2'
		 , 'Transitions of Care-Mental Health'
		 , 'Transitions of Care-Mental Health-2'
		 , 'High Risk', 'High Risk Cohort'
		 , 'High Utilizer Emergency Room Visits'
		 , 'High Utilizers Inpatient Admission'
		 , 'Diabetes Management'
		 , 'Transitions of Care- Inpatient')*/
    -- GROUP BY lob,
     --         program_name,
      --        START_DATE,Program_status_name--,Updated_on
	 ) as s 
	 group by LOB,Program,ProgramStatus,month_appeared,mm,Department










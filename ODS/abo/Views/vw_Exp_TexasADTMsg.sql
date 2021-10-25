


CREATE VIEW [abo].[vw_Exp_TexasADTMsg]
AS 
    SELECT 
	 [Facility Name]
      ,[Facility NPI]
      ,[Facility City]
      ,[Facility State]
      ,[Facility Type]
      ,[Visit ID]
      ,[Status]
      ,[AdmitDate]
      ,[DischargeDate]
      ,[Setting]
      ,[Patient ID]
      ,[Last Name]
      ,[First Name]
      ,[Middle Name]
      ,[Suffix]
      ,[DOB]
      ,[Gender]
      ,[Address1]
      ,[Address2]
      ,[Address3]
      ,[City]
      ,[State]
      ,[Zip]
      ,[Mobile Phone]
      ,[Home Phone]
      ,[Patient Phone Number (Unknown source)]
      ,[Primary Insurance Number]
      ,[Primary Insurer]
      ,[Primary Insurance Plan]
      ,[Insurance Billed]
      ,[Other Practices]
      ,[Other Providers]
      ,[Other Programs]
      ,[Facility Visit Id]
      ,[Account Number]
      ,[Admitted From]
      ,[Discharged Disposition]
      ,[Discharge Location]
      ,[MLOA Disposition]
      ,[MLOA Location]
      ,[Admit Care Coordinator]
      ,[Discharge Care Coordinator]
      ,[Entry Delay]
      ,[Visit Duration - (days)]
      ,[LOS]
      ,[CCD]
      ,[Attending Provider NPI]
      ,[Attending Provider Las tName]
      ,[Attending Provider First Name]
      ,[Active Roster Patient]
      ,[Primary Diagnosis Description]
      ,[Primary Diagnosis Code]
      ,[Diagnosis Category]
      ,[Subsequent Diagnosis Codes]
      ,[High Utilizer Flag]
      ,[Readmission Risk Flag]
      ,[Recent SNF Stay Flag]
      ,[Recent Inpatient Stay Flag]
      ,[COVID_19 Flags]
	  ,CASE [Patient Type] 
	   WHEN 'O' THEN 'Outpatient'
	   WHEN 'I' THEN 'Inpatient'
	   WHEN 'R' THEN 'Recurring patient'
	   WHEN 'E' THEN 'Emergency'
	   WHEN 'P' THEN 'Preadmit'
	   WHEN 'B' THEN 'Obstetrics'
	   WHEN 'C' THEN 'Commercial Account'
	   WHEN 'U' THEN 'Unknown'
	   WHEN 'N' THEN 'Not Applicable'
	   ELSE 'Other'
	   END [Patient Type]
	  ,CASE [Admit Type]
	   WHEN '1' THEN 'Emergency'
	   WHEN '2' THEN 'Urgent'
	   WHEN '3' THEN 'Elective'
	   WHEN '4' THEN 'Newborn'
	   WHEN '5' THEN 'Trauma Center'
	   WHEN '9' THEN 'Information Not Available'
	   WHEN 'A' THEN 'Accident'
	   WHEN 'E' THEN 'Emergency'
	   WHEN 'L' THEN 'Labor and Delivery'
	   WHEN 'R' THEN 'Routine'
	   WHEN 'N' THEN 'Newborn'
	   WHEN 'U' THEN 'Urgent'
	   WHEN 'C' THEN 'Elective'
	   ELSE 'Unknown'
	   END [Admit Type]
	  ,[DRG Code]
	  ,[DRG DESC]
	 
FROM 
--[ACDW_CLMS_SHCN_MSSP].[adw].[vw_Exp_TexasADAllTMsg_Dev]
[ACDW_CLMS_SHCN_MSSP].[adw].[vw_Exp_TexasADTAllMsg]






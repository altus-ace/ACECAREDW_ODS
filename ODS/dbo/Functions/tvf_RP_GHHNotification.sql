/****** Script for SelectTopNRows command from SSMS  ******/
CREATE FUNCTION [dbo].[tvf_RP_GHHNotification](@startdate DATE
                                        , @enddate   DATE, @Name varchar(20))
RETURNS TABLE
AS
     RETURN
( 

SELECT am.Member_id
      ,nt.[TRANSACTION]
      ,nt.[HospitalAccountNumber]
      ,nt.[MedicalRecordNumber]
      ,nt.[PatientLastName]
      ,nt.[PatientFirstName]
      ,nt.[PatientMiddleInitial]
      ,nt.[PatientAddress1]
      ,nt.[PatientAddress2]
      ,nt.[PatientCity]
      ,nt.[PatientState]
      ,nt.[PatientZip]
      ,nt.[PatientPhone]
      ,nt.[PatientDob]
      ,nt.[PatientGender]
      ,nt.[AdmitDate]
      ,nt.[AdmitTime]
      ,nt.[AdmitHospital]
      ,nt.[ChiefComplaint]
      ,nt.[Carrier1Code]
      ,nt.[Carrier1Name]
      ,nt.[InsuredID1] as Medicaid_id
      ,nt.[AdmittingPhysician]
      ,nt.[AttendingPhysician]
      ,nt.[ReferringPhysician]
      ,nt.[ConsultingPhysician]
      ,nt.[Comments]
      ,nt.[NursingStation]
      ,nt.[PatientRoom]
      ,nt.[PatientBed]
      ,nt.[PatientServiceCode]
      ,nt.[PatientType]
      ,nt.[DischargeDate]
      ,nt.[DischargeTime]
      ,nt.[DischargeDisposition]
      ,nt.[FileDate] as DateAppeared
	 ,dateadd( day, 7,nt.[fileDate]) as Follow_up_visit_due_Date
      ,am.PCP_PRACTICE_TIN
	-- ,am.PCP_PRACTICE_NAME
	 ,upper(case when a.name IS null then am.PCP_PRACTICE_NAME else a.Name end) as PCP_PRACTICE_NAME
	 
  FROM [ACECAREDW].[ast].[NtfGhhActivity] nt
  inner join vw_UHC_ActiveMembers am on convert(int,am.MEDICAID_ID)=convert(int,nt.[InsuredID1])
  left join tmpsalesforce_Account a on convert(int,a.tax_id_number__C) =Convert(int,am.pcp_practice_tin)
   where Filedate between @startdate and @enddate and
    nt.[TRANSACTION]='DISCHARGE'
 and [transaction]=@Name
  );


CREATE FUNCTION [dbo].[tvf_UHC_ER_DailyCensus](@FileDate DATE)

RETURNS TABLE
AS
    RETURN
(  
-- declare @fileDate date = getdate()
    SELECT distinct 
	  a.[PcpID]
      ,a.[PcpFirstName]
      ,a.[PcpLastName]
      ,a.[PatientFirstName]
      ,a.[PatientLastName]
      ,a.[PatientId]
      ,b.PLAN_DESC
      ,a.[PatientCardID]
      ,a.[MemberHealthPlanNumber]
      ,a.[PatientBirthDate]
      ,a.[PatientGender]
      ,a.[PrimaryLanguage]
      ,a.[Address]
      ,a.[City]
      ,a.[State]
      ,a.[Zip]
      ,a.[ContactPhoneNumber]
      ,a.[AlternativePhoneNumber]
      ,a.[LOB]
      ,a.[ServiceDate]
      ,a.[AdmitTime]
      ,a.[DischargeTime]
      ,a.[ServiceDateReported]
      ,a.[DayOfWeek]
      ,a.[ReOccuranceWithin30Days]
      ,a.[AvoidableERVisit]
      ,a.[LastIpVisitDate]
      ,a.[PrimaryDiagnosisCode]
      ,a.[PrimaryDiagnosisDescription]
      ,a.[AttendingPhysicianFirstName]
      ,a.[AttendingPhysicianLastName]
      ,a.[FacilityName]
      ,a.[FacilityState]
      ,a.[PcpNpi]
      ,a.[LoadDate]
	 ,a.[DataDate]
      ,a.[SrcFileName]
	  ,case when c.phonenumber is not null then 'No' else 'Yes' end as [Text Sent?]
  FROM [adi].[NtfUhcErCensus] a
  join dbo.vw_ActiveMembers b on b.MEMBER_ID = a.PatientCardID
  left join (select * 
	   from (SELECT   ClientMemberKey,Ace_ID_Mrn,phoneNumber ,
			 row_number() over (partition by  clientmemberkey order by loaddate desc) as arn
			 FROM [AceCareDw].[adi].[MPulsePhoneScrubbed]	
			 WHERE carrier_type = 'Mobile' 
	   ) as x where x.arn = 1
    ) C ON B.member_ID = C.ClientMemberKey
  where a.LoadDate = @FileDate
 );





CREATE view [dbo].[vw_RP_AetCareopps_details]
As
Select * ,SUM([Readmissions-AllCause]+
MedicationReconciliationPostDischarge+
[BreastCancerScreening]+
ColorectalCancerScreening+
[MedAdherence-RAS]+
[DiabetesEyeExam]+
[DiabetesMedicationAdherence]+
DiabetesHbA1cTest+
StatinUseInDiabetics+
[MedAdherence-Statins]+
AdultBMIAssessment+
[HCC-ChronicConditionRevalidation]+
[OfficeVisists-Chronic1stHalf]+[OfficeVisists-Chronic2stHalf]+
ControllingHighBloodPressure+AnnualFluShot) as TotalGaps
 from (
select a.AetSubscriberId as MemberID
--,a.SrcMemberID
, c.MemberlastName
,c.MemberFirstName
,convert(date,c.MemberDOB) as DOB
,a.gender as Gender
 ,CASE WHEN c.MemberPhone ='' THEN '' ELSE  SUBSTRING('('+c.MemberPhone , 1, 4) + ')' + 
                  SUBSTRING(c.MemberPhone , 5,8) END AS [Member_Phone]
--,c.MemberPhone as Phone
,c.NPI
,c.ProviderName as NPIName
,c.Tin as TIN_num
,c.TinName as TIN_Name
,c.A_last_update_date as ReportAsOf
,case when LTRIM(RTRIM(LEFT(c.AdultBMIAssessment,1)))='N' then 1 else 0 end as AdultBMIAssessment
,case when LTRIM(RTRIM(LEFT( c.[AnnualFluVaccine],1)))='N' then 1 else 0 end AnnualFluShot
     ,  case when LTRIM(RTRIM(LEFT(c.[Breast ScreeningCompliance], 1)))='N' then 1 else 0 end as [BreastCancerScreening]
	, case when LTRIM(RTRIM(LEFT( c.ControllingHighBloodPressure,1)))='N' then 1 else 0 end as  ControllingHighBloodPressure
	  ,  case when LTRIM(RTRIM(LEFT(c.ColorectalScreeningCompliance, 1)))='N' then 1 else 0 end as ColorectalCancerScreening
	  ,case when LTRIM(RTRIM(LEFT(c.DiabetesEyeExam, 1)))='N' then 1 else 0 end as DiabetesEyeExam
	   ,case when LTRIM(RTRIM(LEFT(c.DiabetesMedicationAdherence, 1)))='N' then 1 else 0 end as DiabetesMedicationAdherence
	   ,case when LTRIM(RTRIM(LEFT(c.DiabetesControlledHbA1c,1)))='N' then 1 else 0 end as DiabetesHbA1cTest
   ,  case when LTRIM(RTRIM(LEFT(c.MedicationReconciliationPostDischarge, 1)))='N' then 1 else 0 end as MedicationReconciliationPostDischarge  
     ,  case when LTRIM(RTRIM(LEFT(c.AceiArbAdherence, 1)))='N' then 1 else 0 end as [MedAdherence-RAS]
  ,case when LTRIM(RTRIM(LEFT(c.[Readmissions-AllCause], 1)))='N' then 1 else 0 end as [Readmissions-AllCause]
  , case when LTRIM(RTRIM(LEFT(c.StatinUseInDiabetics, 1)))='N' then 1 else 0 end as StatinUseInDiabetics
,  case when LTRIM(RTRIM(LEFT(c.StatinMedicationAdherence,1)))='N' then 1 else 0 end as [MedAdherence-Statins]
,case when LTRIM(RTRIM(LEFT(c.[HCC-ChronicConditionRevalidation],1)))='N' then 1 else 0 end as [HCC-ChronicConditionRevalidation]
--,	        case when LTRIM(RTRIM(LEFT( c.[Last OfficeVisit-Chronic],1)))='N' then 1 else 0 end as [LastOfficeVisit-Chronic]
,	        case when LTRIM(RTRIM(LEFT( c.[OfficeVisits-Chronic1stHalf],1)))<>' ' then 1 else 0 end as [OfficeVisists-Chronic1stHalf]
,	        case when LTRIM(RTRIM(LEFT( c.[Office Visits-Chronic2ndHalf],1)))<>' ' then 1 else 0 end as [OfficeVisists-Chronic2stHalf]
 from tmpAET_Careopps c

 inner join (select Distinct m.SrcMemberID,m.AetSubscriberId,a1.GENDER from [adi].[MbrAetMbrByPcp]  m
 inner join vw_ActiveMembers a1 on a1.Member_id= m.AetSubscriberId) a on a.SrcMemberID=c.MemberID

  where c.A_last_update_flag='Y') as s
  group by 
  s.MemberID,s.MemberlastName,
s.MemberFirstName,
s.DOB,
s.Member_Phone,
s.NPI,
s.NPIName,
s.TIN_num,
s.TIN_Name,
s.ReportAsOf,s.[Readmissions-AllCause],s.AnnualFluShot,
s.MedicationReconciliationPostDischarge,
s.[BreastCancerScreening],
s.ColorectalCancerScreening,
s.[MedAdherence-RAS],
s.[DiabetesEyeExam],
s.[DiabetesMedicationAdherence],
s.DiabetesHbA1cTest,
s.StatinUseInDiabetics,
s.[MedAdherence-Statins],
s.AdultBMIAssessment,
s.[HCC-ChronicConditionRevalidation],
--s.[LastOfficeVisit-Chronic],
s.ControllingHighBloodPressure,
s.[OfficeVisists-Chronic1stHalf],
s.[OfficeVisists-Chronic2stHalf],
s.Gender

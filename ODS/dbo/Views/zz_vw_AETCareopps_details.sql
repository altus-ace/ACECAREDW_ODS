create view [zz_vw_AETCareopps_details]
As
select a.AetSubscriberId as MemberID
--,a.SrcMemberID
, c.MemberlastName
,c.MemberFirstName
,convert(date,c.MemberDOB) as DOB
 ,CASE WHEN c.MemberPhone ='' THEN '' ELSE  SUBSTRING('('+c.MemberPhone , 1, 4) + ')' + 
                  SUBSTRING(c.MemberPhone , 5,8) END AS [Member_Phone]
--,c.MemberPhone as Phone
,c.NPI
,c.ProviderName as NPIName
,c.Tin as TIN_num
,c.TinName as TIN_Name
,c.A_last_update_date
  ,case when LTRIM(RTRIM(LEFT(c.[Readmissions-AllCause], 1)))='N' then 1 else 0 end as [Readmissions-AllCause],
 
       case when LTRIM(RTRIM(LEFT(c.MedicationReconciliationPostDischarge, 1)))='N' then 1 else 0 end as MedicationReconciliationPostDischarge,
	 
       case when LTRIM(RTRIM(LEFT(c.[Breast ScreeningCompliance], 1)))='N' then 1 else 0 end as [Breast ScreeningCompliance],
	
       case when LTRIM(RTRIM(LEFT(c.ColorectalScreeningCompliance, 1)))='N' then 1 else 0 end as ColorectalScreeningCompliance,
	  
       case when LTRIM(RTRIM(LEFT(c.AceiArbAdherence, 1)))='N' then 1 else 0 end as AceiArbAdherence ,
	
case when LTRIM(RTRIM(LEFT(c.DiabetesEyeExam, 1)))='N' then 1 else 0 end as DiabetesEyeExam, 

 case when LTRIM(RTRIM(LEFT(c.DiabetesMedicationAdherence, 1)))='N' then 1 else 0 end as DiabetesMedicationAdherence,

case when LTRIM(RTRIM(LEFT(c.DiabetesControlledHbA1c,1)))='N' then 1 else 0 end as DiabetesControlledHbA1c,
  case when LTRIM(RTRIM(LEFT(c.StatinUseInDiabetics, 1)))='N' then 1 else 0 end as StatinUseInDiabetics,
  case when LTRIM(RTRIM(LEFT(c.StatinMedicationAdherence,1)))='N' then 1 else 0 end as StatinMedicationAdherence,
case when LTRIM(RTRIM(LEFT(c.AdultBMIAssessment,1)))='N' then 1 else 0 end as AdultBMIAssessment,
case when LTRIM(RTRIM(LEFT(c.[HCC-ChronicConditionRevalidation],1)))='N' then 1 else 0 end as [HCC-ChronicConditionRevalidation],
	        case when LTRIM(RTRIM(LEFT( c.[Last OfficeVisit-Chronic],1)))='N' then 1 else 0 end as [Last OfficeVisit-Chronic],

--Generic Dispensing Rate 
 case when LTRIM(RTRIM(LEFT( c.ControllingHighBloodPressure,1)))='N' then 1 else 0 end as  ControllingHighBloodPressure

  -- ,c.A_LAST_UPDATE_FLAG
 from tmpAET_Careopps c

 inner join (select Distinct m.SrcMemberID,m.AetSubscriberId from [adi].[MbrAetMbrByPcp]  m
 inner join vw_ActiveMembers a1 on a1.Member_id= m.AetSubscriberId) a on a.SrcMemberID=c.MemberID

  where c.A_last_update_flag='Y'
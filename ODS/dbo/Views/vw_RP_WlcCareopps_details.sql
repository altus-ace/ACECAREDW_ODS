




CREATE view [dbo].[vw_RP_WlcCareopps_details]
As
Select  distinct MemberID,
MemberLastName,
MemberFirstName,
DOB,
Gender,
Member_Phone,
NPI,
NPIName,
TIN_Num,
TIN_Name,ComplianceStatus,
StarMeasureComplianceUpdatedThru,
ClaimsThruDate,
ReportAsOf,
[Adult BMI Percentile/Value] as AdultBMIAssessment,
[Annual Flu Shot] as AnnualFluShot,
[Adult Preventive Visit]  as AdultPreventiveVisit ,
[Annual Visit with Assigned PCP] as AnnualVisitwithAssignedPCP,
[Anti-Rheumatic Drug] as [Anti-RheumaticDrug],
Mammogram as BreastCancerScreening,
[COA - Functional Status Assessment] as [COA-FunctionalStatusAssessment],
[COA - Medication List and Review] as [COA-MedicationListandReview],
[COA - Pain Screening] [COA-PainScreening],
[Colorectal Cancer Screen] ColorectalCancerScreening,
[Diabetes - Dilated Eye Exam] as DiabetesEyeExam,
[Diabetes HbA1c <= 9] as [DiabetesHbA1c<=9],
[Diabetes HbA1c Test] as DiabetesHbA1cTest,
[Diabetes Monitor Nephropathy] DiabetesMonitorNephropathy,
[HCC- Chronic Condition Revalidations ] as [HCC-ChronicConditionRevalidation] ,
[Med Adherence - Diabetic] as [MedAdherence-Diabetic],
[Med Adherence - RAS] as [MedAdherence-RAS] ,
[Med Adherence - Statins] [MedAdherence-Statins],
[Medication Reconciliation Post Discharge] [MedicationReconciliationPostDischarge],
[SPC - Statin Therapy for Patients with CVD] [SPC-StatinTherapyforPatientswithCVD],
[SPD - Statin Therapy for Patients with Diabetes] StatinUseInDiabetics,
SUM(
[Adult BMI Percentile/Value]+[Annual Flu Shot]+
[Adult Preventive Visit]+
[Annual Visit with Assigned PCP]+
[Anti-Rheumatic Drug]+
[COA - Functional Status Assessment]+
[COA - Medication List and Review]+
[COA - Pain Screening]+
[Colorectal Cancer Screen]+
[Diabetes - Dilated Eye Exam]+
[Diabetes HbA1c <= 9]+
[Diabetes HbA1c Test]+
[Diabetes Monitor Nephropathy]+
[Mammogram]+
[Med Adherence - Diabetic]+
[Med Adherence - RAS]+
[Med Adherence - Statins]+
[Medication Reconciliation Post Discharge]+
[SPC - Statin Therapy for Patients with CVD]+
[SPD - Statin Therapy for Patients with Diabetes]+
[HCC- Chronic Condition Revalidations ]) as TotalGaps from (
SELECT c.URN,
    ltrim(rtrim(c.Measure))  as Meas,
     ltrim(rtrim(c.Subscriber)) as MemberID,
	   ltrim(rtrim(a.MEMBER_LAST_NAME)) as MemberLastName ,
	   ltrim(rtrim(a.MEMBER_LAST_NAME)) as MemberFirstName,
	   convert(date,c.[DOB]) as DOB,
	   a.GENDER Gender,
	  -- C.Phone,
	   CASE WHEN c.Phone ='' THEN '' ELSE  SUBSTRING('('+ltrim(rtrim(c.Phone)) , 1, 4) + ')' + 
                  SUBSTRING(c.Phone , 5,8) END AS [Member_Phone],
	   ltrim(rtrim(c.NPI)) as NPI,
       ltrim(rtrim(c.NPIName)) as NPIName,
      ltrim(rtrim(N.tin)) AS TIN_Num,
	  ltrim(rtrim(N.PracticeName)) as TIN_Name,
	  c.[StarMeasureComplianceUpdatedThru ] as StarMeasureComplianceUpdatedThru,
	  c.ClaimsThruDate,
       c.ComplianceStatus,
       ltrim(rtrim(convert(date,c.A_LAST_UPDATE_DATE))) as ReportAsOf
FROM (  SELECT DISTINCT wc.URN,wc.MemberName,wc.DOB,wc.Phone,wc.NPI,wc.NPIName,wc.ProviderID,
           wc.Subscriber,
           wc.Measure,
		 wc.ComplianceStatus,
		CONVERT(DATE,WC.ServiceStartDate) AS ENROLL_DATE,
		wc.ServiceEndDate,
           wc.ComplianceDetail,
           wc.A_LAST_UPDATE_FLAG,
		 wc.A_LAST_UPDATE_DATE,
		   wc.[StarMeasureComplianceUpdatedThru ],
		  wc.ClaimsThruDate
    FROM tmpWLC_careopps wc
    where wc.ComplianceStatus like 'In%' and wc.A_LAST_UPDATE_FLAG='y'
    union 
    SELECT DISTINCT wc1.URN,wc1.MemberName,wc1.DOB,wc1.Phone,wc1.NPI,wc1.NPIName,wc1.ProviderID,
           wc1.Subscriber,
           wc1.Measure,
           wc1.ComplianceStatus,
		 CONVERT(DATE,WC1.ServiceStartDate) AS ENROLL_DATE,
		 wc1.ServiceEndDate,
		 wc1.ComplianceDetail,
           wc1.A_LAST_UPDATE_FLAG,
		  wc1.A_LAST_UPDATE_DATE,
		  wc1.[StarMeasureComplianceUpdatedThru ],
		  wc1.ClaimsThruDate
    FROM tmpWLC_careopps wc1
    where wc1.ComplianceStatus not like 'In%'and wc1.A_LAST_UPDATE_FLAG='y' and wc1.ComplianceStatus='Non-compliant')  as c
inner join (select Distinct Member_id,Member_first_name,Member_last_name,GENDER from vw_ActiveMembers ) as a on a.Member_id=c.subscriber
inner JOIN (SELECT distinct * FROM [adw].[MbrWlcProviderLookup]) AS N ON N.Prov_id=c.ProviderID
WHERE c.a_last_update_flag = 'Y'  -- and c.Subscriber='19330316'
--and c.Subscriber='19834856' 
) as s pivot(count(urn) for meas in ([Adult BMI Percentile/Value],[Annual Flu Shot],
[Adult Preventive Visit],
[Annual Visit with Assigned PCP],
[Anti-Rheumatic Drug],
[COA - Functional Status Assessment],
[COA - Medication List and Review],
[COA - Pain Screening],
[Colorectal Cancer Screen],
[Diabetes - Dilated Eye Exam],
[Diabetes HbA1c <= 9],
[Diabetes HbA1c Test],
[Diabetes Monitor Nephropathy],
[Mammogram],
[Med Adherence - Diabetic],
[Med Adherence - RAS],
[Med Adherence - Statins],
[Medication Reconciliation Post Discharge],
[SPC - Statin Therapy for Patients with CVD],
[SPD - Statin Therapy for Patients with Diabetes],
[HCC- Chronic Condition Revalidations ])) as pvt
Group by pvt.[Adult BMI Percentile/Value],
pvt.[Adult Preventive Visit],
pvt.[Annual Visit with Assigned PCP],
pvt.[Anti-Rheumatic Drug],
pvt.[COA - Functional Status Assessment],
pvt.[COA - Medication List and Review],
pvt.[COA - Pain Screening],
pvt.[Colorectal Cancer Screen],
pvt.[Diabetes - Dilated Eye Exam],
pvt.[Diabetes HbA1c <= 9],
pvt.[Diabetes HbA1c Test],
pvt.[Diabetes Monitor Nephropathy],
pvt.[Mammogram],
pvt.[Med Adherence - Diabetic],
pvt.[Med Adherence - RAS],
pvt.[Med Adherence - Statins],
pvt.[Medication Reconciliation Post Discharge],
pvt.[SPC - Statin Therapy for Patients with CVD],
pvt.[SPD - Statin Therapy for Patients with Diabetes],
pvt.[HCC- Chronic Condition Revalidations ],pvt.MemberID,pvt.MemberLastName,pvt.MemberFirstName,pvt.DOB,pvt.Gender,pvt.[Member_Phone],pvt.NPI,pvt.[Annual Flu Shot],
pvt.[Adult Preventive Visit],
       pvt.NPIName,
      pvt.TIN_Num,
	 pvt.TIN_Name,
	 pvt.StarMeasureComplianceUpdatedThru,
	 pvt.ClaimsThruDate,
	 pvt.ReportAsOf,
       pvt.ComplianceStatus
      -- pvt.A_LAST_UPDATE_DATE







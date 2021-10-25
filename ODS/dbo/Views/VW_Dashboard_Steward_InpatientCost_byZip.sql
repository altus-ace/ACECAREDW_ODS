create view VW_Dashboard_Steward_InpatientCost_byZip
as
SELECT DISTINCT 
       a.PatientIdentifier, 
       a.zip, 
       a.LengthOfStay as DaysOfCare, 
       b.total_paid_amt, 
       a.dischargedate
FROM adi.NtfUhcIpCensus a
     LEFT JOIN ACECAREDW_TEST.dbo.claims_headers b ON b.subscriber_id = a.PatientIdentifier 
--join ACECAREDW_TEST.dbo.claims_details b on b.subscriberid = a.patientcardid and a.dischargedate = b.SVC_TO_DATE
WHERE YEAR(CONVERT(DATE, a.dischargedate, 101)) = 2018
      AND YEAR(b.svc_to_date) = 2018
      AND b.TOTAL_PAID_AMT IS NOT NULL
	  and a.DischargeDate is not null;

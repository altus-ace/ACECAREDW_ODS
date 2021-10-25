
CREATE view [dbo].[vw_RP_TOTALGAPS_DECACTIVEGAPS]
as
SELECT concat(MONTH(c1.a_last_update_Date), '-', YEAR(c1.a_last_update_date)) AS MONTH_YEAR,
       concat(c1.Measure_desc, '-', c1.Sub_Meas) AS MEASURE,
       COUNT(DISTINCT c1.MemberID) AS TOTAL_Member,
	
       p.ACTIVEMEMBER_GAPS,
	  p1.NewMem_Gaps
FROM UHC_CareOpps c1
     LEFT JOIN
(
    SELECT concat(MONTH(c.a_last_update_Date), '-', YEAR(c.a_last_update_date)) AS Month_year,
           concat(c.Measure_desc, '-', c.Sub_Meas) AS MEASURE,
           COUNT(DISTINCT c.MemberId) AS ActiveMember_Gaps,
		 count(distinct c.urn) as active_gap
    FROM UHC_CareOpps c
         INNER JOIN (SELECT UHC_SUBSCRIBER_ID AS mEMBER_ID FROM UHC_MEMBERSBYPCP WHERE LOADTYPE='P'
	    AND SUBGRP_ID NOT IN ('TX99','1001','1002','1003','0603','0601','0602','0600','0606','0604','0605') AND
	    MONTH(A_LAST_UPDATE_DATE)=12 AND YEAR(A_LAST_UPDATE_DATE)=2018) a ON a.MEMBER_ID = c.MemberID  
    WHERE MONTH(c.a_last_update_Date) = 12
          AND YEAR(c.a_last_update_date) = 2018
    GROUP BY concat(MONTH(c.a_last_update_Date), '-', YEAR(c.a_last_update_date)),
             concat(c.Measure_desc, '-', c.Sub_Meas)
) AS p ON p.MEASURE = concat(c1.Measure_desc, '-', c1.Sub_Meas)

left join 
( SELECT concat(MONTH(c.a_last_update_Date), '-', YEAR(c.a_last_update_date)) AS Month_year,
           concat(c.Measure_desc, '-', c.Sub_Meas) AS MEASURE,
           COUNT(DISTINCT c.MemberId) AS NewMem_Gaps,
		 count(distinct c.urn) as active_gap
    FROM UHC_CareOpps c
         INNER JOIN (
	    --SELECT UHC_SUBSCRIBER_ID AS mEMBER_ID FROM UHC_MEMBERSBYPCP WHERE LOADTYPE='P'
	 --   AND SUBGRP_ID NOT IN ('TX99','1001','1002','1003','0603','0601','0602','0600','0606','0604','0605') AND
	  --  MONTH(A_LAST_UPDATE_DATE)=12 AND YEAR(A_LAST_UPDATE_DATE)=2018 and month(MEMBER_ORG_EFF_DATE)=11 and year(MEMBER_ORG_EFF_DATE)=2018)
	    SELECT Member_id AS mEMBER_ID FROM cc.dbo.p11 WHERE Clientkey=1
	    AND
	    MONTH(lst_update_date)=12 AND YEAR(lst_update_date)=2018)
	   a ON a.MEMBER_ID = c.MemberID  
    WHERE MONTH(c.a_last_update_Date) = 12
          AND YEAR(c.a_last_update_date) = 2018
    GROUP BY concat(MONTH(c.a_last_update_Date), '-', YEAR(c.a_last_update_date)),
             concat(c.Measure_desc, '-', c.Sub_Meas)
) AS p1 ON p1.MEASURE = concat(c1.Measure_desc, '-', c1.Sub_Meas)
WHERE MONTH(c1.a_last_update_Date) = 12
      AND
	  YEAR(c1.a_last_update_date) = 2018 and concat(c1.Measure_desc, '-', c1.Sub_Meas) not in ('Appropriate Treatment for Children with Upper Respiratory Infection-(Default)',
	  'Diabetes Screening for People With Schizophrenia or Bipolar Disorder Who Are Using Antipsychotic Medications-(Default)','Prenatal and Postpartum Care-Postpartum Care',
	  'Prenatal and Postpartum Care-Prenatal Care',
	  'Follow-Up After Hospitalization for Mental Illness-30-Day Follow-Up',
'Follow-Up After Hospitalization for Mental Illness-7-Day Follow-Up','Controlling High Blood Pressure-(Default)')
GROUP BY concat(MONTH(c1.a_last_update_Date), '-', YEAR(c1.a_last_update_date)),
         concat(c1.Measure_desc, '-', c1.Sub_Meas),
         p.ActiveMember_Gaps, p1.NewMem_Gaps


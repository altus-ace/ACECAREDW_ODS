

CREATE VIEW [dbo].[vw_care_gaps_by_tin]
AS
     SELECT A.*,
            B.CNT AS Memb_cnt,
			c.AUTO_ASSIGNED_CNT,
            ROUND(CAST(A.total_care_gaps AS FLOAT) / B.CNT * 100, 1) AS gaps_over_memb_cnt
     FROM
(
    SELECT Membership_tin,
           membership_practice_name,
           SUM(total) AS total_care_gaps,
           COUNT(DISTINCT member_Id) AS num_memb_w_care_gap
    FROM vw_care_op_distr_list A
    GROUP BY Membership_tin,
             membership_practice_name
) A
LEFT JOIN
(
    SELECT CASE
               WHEN LEN(PCP_PRACTICE_TIN) = 8
               THEN concat('0', PCP_PRACTICE_TIN)
               ELSE PCP_PRACTICE_TIN
           END AS PCP_PRACTICE_TIN,
           COUNT(DISTINCT MEMBER_ID) AS CNT
		   --,CASE 
		   --WHEN AUTO_ASSIGN = 'AUTO'
		   --THEN '1'
		   --WHEN AUTO_ASSIGN = 'SELF'
		   --then '0'
		   --END as AUTO_ASSIGNED
    FROM vw_UHC_ActiveMembers
    GROUP BY PCP_PRACTICE_TIN
) B ON a.membership_tin = b.PCP_PRACTICE_TIN
LEFT JOIN
(
    SELECT CASE
               WHEN AUTO_ASSIGN = 'AUTO'
               THEN '1'
               ELSE '0'
           END AS AUTO_ASSIGNED,
           COUNT(DISTINCT MEMBER_ID) AS AUTO_ASSIGNED_CNT,
		   PCP_PRACTICE_TIN

    FROM vw_UHC_ActiveMembers
    GROUP BY PCP_PRACTICE_TIN,AUTO_ASSIGN
) C ON a.Membership_TIN  = C.PCP_PRACTICE_TIN
where AUTO_ASSIGNED = '1'
;

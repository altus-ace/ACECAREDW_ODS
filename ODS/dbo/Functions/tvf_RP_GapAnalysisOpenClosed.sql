
CREATE FUNCTION [dbo].tvf_RP_GapAnalysisOpenClosed(@MemberMonth int, @MemberYear int)
RETURNS TABLE
AS
     RETURN
(

--DECLARE @Membermonth INT;
--SET @Membermonth = 11;
SELECT DISTINCT
       r.[Tax Id],
       r.[PRACTICE NAME],
	  CC.PCP_PRACTICE_TIN,
       concat(cc.Measure_desc,'-',CC.Sub_Meas) as Measure,
      --  cc.MemberID,
	   cc.previousGap,
	   cc.currentGap MembermonthGap,
	   CC.nextmonthgap,
	   cc.activeMember,
       Gap_status
FROM vw_NetworkRoster r
     inner JOIN
(
    SELECT DISTINCT
           s.Measure_Desc,
		 s.Sub_Meas,
           CONVERT(INT, s.MemberID) MemberID,
           s.PCP_Practice_tin,
 --p.MemberID AS 'CURRENTMONTH+1_GAP',
 p3.memberID as previousGap,
 s.MemberID as currentgap,
 P.MemberId as nextmonthgap,
 c3.uhc_subscriber_id as activeMember,
 /*PREVIOUS MONTH GAP IS NULL AND CURRENT GAP IS NOT NULL THEN NEW GAP FOR CURRENT MONTH*/
           CASE WHEN p3.MemberID IS NULL AND s.MemberID IS NOT NULL AND p.MemberID IS NOT NULL THEN 'NEW GAP'
		  /*CURRENT GAP IS NOT NULL AND NEXT MONTH GAP IS NULL AND ACTIVE MEMBER IS N ULL THEN TERM*/
               WHEN S.MEMBERID IS NOT NULL AND c3.UHC_SUBSCRIBER_ID IS NULL AND p.MemberID IS NULL THEN 'TERM'
			/* ACTIVE MEMMBER IS NOT NULL AND NEXT MONTH IS NULL THEN GAP CLOSED*/
			WHEN c3.UHC_SUBSCRIBER_ID IS NOT NULL AND p.MemberID IS NULL THEN 'GAP CLOSED'
               ELSE 'OPEN GAP'
           END AS GAP_STATUS
	 --  C3.uhc_subscriber_id AS 'CURRENTMONTH+1_MEM'

    FROM
(
    SELECT MemberID,
           Measure_Desc,
           Sub_Meas,
           CONCAT(MONTH(CONVERT(DATE, A_LAST_UPDATE_DATE)), '-', YEAR(CONVERT(DATE, A_LAST_UPDATE_DATE))) AS Month_year,
           PCP_PRACTICE_TIN
    FROM uhc_careopps c
         INNER JOIN
(
    SELECT DISTINCT
           pp.UHC_SUBSCRIBER_ID,
           pp.PCP_PRACTICE_TIN
    FROM UHC_MembersByPCP pp
    WHERE pp.loadtype = 'p'
          AND SUBGRP_ID NOT IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
    AND MONTH(a_last_update_date) = @Membermonth
    AND YEAR(a_last_update_date) = @MemberYear
) cc ON cc.UHC_SUBSCRIBER_ID = c.MemberID
    WHERE MONTH(CONVERT(DATE, c.A_LAST_UPDATE_DATE)) = @Membermonth
          AND YEAR(CONVERT(DATE, c.A_LAST_UPDATE_DATE)) = @MemberYear
) AS s


LEFT JOIN
(
    SELECT MemberID,
           Measure_Desc,
           Sub_Meas,
           CONCAT(MONTH(CONVERT(DATE, A_LAST_UPDATE_DATE)), '-', YEAR(CONVERT(DATE, A_LAST_UPDATE_DATE))) AS Month_year,
           PCP_PRACTICE_TIN
    FROM uhc_careopps c
         INNER JOIN
(
    SELECT DISTINCT
           pp.UHC_SUBSCRIBER_ID,
           pp.PCP_PRACTICE_TIN
    FROM UHC_MembersByPCP pp
    WHERE pp.loadtype = 'p'
          AND SUBGRP_ID NOT IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
    AND MONTH(a_last_update_date) IN(@Membermonth - 1)
    AND YEAR(a_last_update_date) = @MemberYear
) cc ON cc.UHC_SUBSCRIBER_ID = c.MemberID
    WHERE MONTH(CONVERT(DATE, c.A_LAST_UPDATE_DATE)) = @Membermonth - 1
          AND YEAR(CONVERT(DATE, c.A_LAST_UPDATE_DATE)) = @MemberYear
) AS p3 ON p3.MemberID = s.MemberID
          AND p3.Measure_Desc = s.Measure_Desc
          AND p3.Sub_Meas = s.Sub_Meas


LEFT JOIN
(
    SELECT MemberID,
           Measure_Desc,
           Sub_Meas,
           CONCAT(MONTH(CONVERT(DATE, A_LAST_UPDATE_DATE)), '-', YEAR(CONVERT(DATE, A_LAST_UPDATE_DATE))) AS Month_year,
           PCP_PRACTICE_TIN
    FROM uhc_careopps c
         INNER JOIN
(
    SELECT DISTINCT
           pp.UHC_SUBSCRIBER_ID,
           pp.PCP_PRACTICE_TIN
    FROM UHC_MembersByPCP pp
    WHERE pp.loadtype = 'p'
          AND SUBGRP_ID NOT IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
    AND MONTH(a_last_update_date) IN(@Membermonth + 1)
    AND YEAR(a_last_update_date) = @MemberYear
) cc ON cc.UHC_SUBSCRIBER_ID = c.MemberID
    WHERE MONTH(CONVERT(DATE, c.A_LAST_UPDATE_DATE)) = @Membermonth + 1
          AND YEAR(CONVERT(DATE, c.A_LAST_UPDATE_DATE)) = @MemberYear
) AS p ON p.MemberID = s.MemberID
          AND p.Measure_Desc = s.Measure_Desc
          AND p.Sub_Meas = s.Sub_Meas
LEFT JOIN
(
    SELECT DISTINCT
           UHC_SUBSCRIBER_ID
    FROM UHC_MembersByPCP
    WHERE loadtype = 'p'
          AND SUBGRP_ID NOT IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
    AND MONTH(a_last_update_date) = @Membermonth + 1
    AND YEAR(a_last_update_date) = @MemberYear
) c3 ON c3.uhc_subscriber_id = s.MemberID
) AS cc ON CONVERT(INT, cc.pcp_practice_tin) = CONVERT(INT, r.[TAX ID])
);



CREATE ViEW dbo.VW_RP_Legacy_2018_QM_trends
AS 
SELECT ma.[MBR_YEAR], ma.[MBR_MTH], COUNT(distinct ma.Member_ID) [Membership Count], COUNT(distinct c.MemberID) [Members With CareOpps], COUNT(distinct c.URN) [CareGap Count]
FROM (SELECT m.UHC_SUBSCRIBER_ID AS Member_id, MONTH(m.[A_LAST_UPDATE_DATE]) AS [MBR_MTH] , YEAR(m.A_LAST_UPDATE_DATE) as Mbr_Year,  m.PCP_PRACTICE_TIN
          FROM dbo.uhc_MembersByPCP m
          WHERE m.PCP_PRACTICE_TIN = '760009637'
                and m.LoadType = 'P'
                and m.A_LAST_UPDATE_DATE between '01/1/2018' and getdate()) ma
    LEFT JOIN (SELECT c.URN, c.MemberID, MONTH(c.A_LAST_UPDATE_DATE) COmht, YEAR(c.A_LAST_UPDATE_DATE) COyr 
                      FROM dbo.UHC_CareOpps c 
                      WHERE c.TIN_Num = '760009637'
and concat( measure_desc,'-',Sub_meas) in ( 'Comprehensive Diabetes Care (Commercial/Medicaid)-HbA1c Poor Control'
												,'Well Child Visits in the First 15 Months of Life-6 or More Visits'
												,'Breast Cancer Screening-(Default)'
												,'Adolescent Well Care Visits-(Default)'
												,'Weight Assessment and Counseling for Nutrition and Physical Activity for Children/Adolescents-Counseling for Nutrition'
												,'Cervical Cancer Screening (Medicaid/Marketplace)-(Default)')) c 
                      ON ma.MEMBER_ID = c.MemberID
                           AND ma.MBR_MTH = c.COmht
                           AND ma.MBR_YEAR = c.COyr
GROUP BY [MBR_YEAR],[MBR_MTH]


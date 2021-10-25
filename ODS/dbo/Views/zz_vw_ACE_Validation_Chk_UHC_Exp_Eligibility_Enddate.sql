

/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[zz_vw_ACE_Validation_Chk_UHC_Exp_Eligibility_Enddate]
AS
(
sELECT END_DATE,[TX-STAR],[TX-STAR+PLUS],[TX-CHIP],[TX-STAR Pregnant Women],[N/A],[TX-CHIP Pregnant Women],
 SUM([TX-STAR]+[TX-STAR+PLUS]+[TX-CHIP]+[TX-STAR Pregnant Women]+[N/A]+[TX-CHIP Pregnant Women]) AS TOTAL_MEMBER FROM (
Select END_DATE,[TX-STAR],[TX-STAR+PLUS],[TX-CHIP],[TX-STAR Pregnant Women],[N/A],[TX-CHIP Pregnant Women]from (
SELECT member_id,end_Date,CASE WHEN [BENEFIT PLAN] ='' THEN 'N/A' ELSE [BENEFIT PLAN] END AS [BENEFIT PLAN]
    
  FROM [ACECAREDW].[dbo].[vw_AH_Eligibility] ) AS P
 PIVOT(COUNT(p.Member_id) FOR [BENEFIT PLAN] IN([TX-STAR],
                                                         [TX-STAR Pregnant Women],
                                                         [TX-CHIP],
                                                         [TX-STAR+PLUS],[N/A],[TX-CHIP Pregnant Women]
                                                         )) AS pvt) AS S
							GROUP BY END_DATE,[TX-STAR],[TX-STAR+PLUS],[TX-CHIP],[TX-STAR Pregnant Women],[N/A],[TX-CHIP Pregnant Women]);



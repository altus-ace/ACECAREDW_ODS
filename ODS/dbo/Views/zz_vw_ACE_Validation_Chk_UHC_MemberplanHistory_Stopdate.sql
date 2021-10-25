


CREATE view [dbo].[zz_vw_ACE_Validation_Chk_UHC_MemberplanHistory_Stopdate]
AS(
Select *,
 sum([TX-STAR]+[TX-STAR+PLUS]+[TX-CHIP]+[TX-STAR Pregnant Women]+[N/A]+[TX-CHIP Pregnant Women]) As Total_Members from (
select  distinct STOPDATE,
 [TX-STAR] ,[TX-STAR+PLUS],[TX-CHIP],[TX-STAR Pregnant Women],[TX-CHIP Pregnant Women], [N/A]
 FROM (
SELECT 
   mp.Client_Member_ID,
  convert(date,mp.stopDate,101) as stopdate,
  
	  mp.Benefit_plan

      
FROM adw.[A_ALT_MemberPlanHistory] mp
   
					where planHistoryStatus=1			 ) AS P
			 PIVOT(COUNT(p.Client_Member_id) FOR p.Benefit_plan IN([TX-STAR],
                                                         [TX-STAR Pregnant Women],
                                                         [TX-CHIP],
											  [TX-CHIP Pregnant Women], 
                                                         [TX-STAR+PLUS],
                                                         [N/A])) AS pvt) s 
										
				 Group by [TX-STAR],[TX-STAR+PLUS],[TX-CHIP],[TX-STAR Pregnant Women],[N/A],STOPDATE,[TX-CHIP Pregnant Women]
				 )




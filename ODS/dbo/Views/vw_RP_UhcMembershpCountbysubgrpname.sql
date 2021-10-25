CREATE view vw_RP_UhcMembershpCountbysubgrpname
as
select ss.plan_name, SUM(ss.TotalMember) as TotalMembers from (
SELECT subgrp_id,CASE
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 1-5 Child - QA'
           THEN 'TX STAR Age 1-5 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 15-18 Child - QA'
           THEN 'TX STAR Age 15-18 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 6-14 Child - QA'
           THEN 'TX STAR Age 6-14 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX CHIP CHIP Clients  Age < 1'
           THEN 'TX STAR Under Age 1 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX CHIP Perinate Perinatal <= 198 FPL before birth'
           THEN 'TX CHIP Perinate Perinatal <= 198 FPL before birth'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('62','63') 
           THEN 'TX STAR Age 1-5 Child'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('66','67') 
           THEN 'TX STAR Age 15-18 Child'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('64','65') 
           THEN 'TX STAR Age 6-14 Child'
		   WHEN LTRIM(RTRIM(subgrp_id)) IN ('301','60') then  'TX STAR Under Age 1 Child'
           
           ELSE LTRIM(RTRIM(subgrp_name))
       END AS Plan_name,
       COUNT(MEMBER_ID) AS TotalMember
FROM vw_UHC_ActiveMembers
--WHERE AGE BETWEEN 0 AND 20
GROUP BY SUBGRP_NAME,SUBGRP_ID


/*union
SELECT subgrp_id,CASE
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 1-5 Child - QA'
           THEN 'TX STAR Age 1-5 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 15-18 Child - QA'
           THEN 'TX STAR Age 15-18 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 6-14 Child - QA'
           THEN 'TX STAR Age 6-14 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX CHIP CHIP Clients  Age < 1'
           THEN 'TX STAR Under Age 1 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX CHIP Perinate Perinatal <= 198 FPL before birth'
           THEN 'TX CHIP Perinate Perinatal <= 198 FPL before birth'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('62','63') 
           THEN 'TX STAR Age 1-5 Child'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('66','67') 
           THEN 'TX STAR Age 15-18 Child'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('64','65') 
           THEN 'TX STAR Age 6-14 Child'
		   WHEN LTRIM(RTRIM(subgrp_id)) IN ('301','60') then  'TX STAR Under Age 1 Child'
           
           ELSE LTRIM(RTRIM(subgrp_name))
       END AS Plan_name,
       COUNT(MEMBER_ID) AS TotalMember
FROM vw_UHC_ActiveMembers
where SUBGRP_NAME like '%198%'
group by SUBGRP_NAME,subgrp_id

union 

SELECT subgrp_id,CASE
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 1-5 Child - QA'
           THEN 'TX STAR Age 1-5 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 15-18 Child - QA'
           THEN 'TX STAR Age 15-18 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX STAR Age 6-14 Child - QA'
           THEN 'TX STAR Age 6-14 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX CHIP CHIP Clients  Age < 1'
           THEN 'TX STAR Under Age 1 Child'
           WHEN LTRIM(RTRIM(subgrp_name)) = 'TX CHIP Perinate Perinatal <= 198 FPL before birth'
           THEN 'TX CHIP Perinate Perinatal <= 198 FPL before birth'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('62','63') 
           THEN 'TX STAR Age 1-5 Child'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('66','67') 
           THEN 'TX STAR Age 15-18 Child'
           WHEN LTRIM(RTRIM(subgrp_id)) IN ('64','65') 
           THEN 'TX STAR Age 6-14 Child'
		   WHEN LTRIM(RTRIM(subgrp_id)) IN ('301','60') then  'TX STAR Under Age 1 Child'
           
           ELSE LTRIM(RTRIM(subgrp_name))
       END AS Plan_name,
       COUNT(MEMBER_ID) AS TotalMember
FROM vw_UHC_ActiveMembers
WHERE SUBGRP_NAME like '%Adult%'
GROUP BY SUBGRP_NAME,SUBGRP_ID*/

)  ss
group by ss.plan_name


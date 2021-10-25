create view vw_UHC_LOB_PLAN
as
select distinct p.product_code as PRODUCT_CODE,p.subgrp_id AS SUBGRP_ID,destination_value as BENEFIT_PLAN 
,s.line_of_business AS LOB
from uhc_membersbyPCP p
inner join alt_mapping_tables a on a.source_value=p.subgrp_id
INNER join  (select distinct line_of_business,plan_code,plan_desc from uhc_membership ) s on s.plan_Code= a.source_value


CREATE VIEW [dbo].[vw_Ace_Validation_Chk_UHC_AltMapping_SubGrp]
AS 

select count(distinct uhc_subscriber_id) as MbrCnt , subgrp_id from acecaredw.dbo.uhc_membersbyPcp
where SUBGRP_ID in (
Select distinct SUBGRP_ID  from ACECAREDW.dbo.uhc_membersbyPCP where A_LAST_UPDATE_FLAG = 'Y'
except
select distinct Source_Value as SUBGRP_ID from acecaredw.dbo.alt_mapping_tables
  )  and A_last_update_flag = 'Y'
  group by subgrp_id  

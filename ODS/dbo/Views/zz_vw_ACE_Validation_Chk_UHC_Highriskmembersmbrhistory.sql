CREATE VIEW [dbo].[zz_vw_ACE_Validation_Chk_UHC_Highriskmembersmbrhistory]
AS  -- Altered by RA to only result High Risk Members if still active 
     SELECT DISTINCT 
            p.uhc_subscriber_id, 
            hp.stopdate
     FROM uhc_membersbypcp p
          LEFT JOIN [adw].[A_ALT_MemberPlanHistory] hp ON hp.Client_Member_ID = p.uhc_subscriber_id
     WHERE p.SUBGRP_ID IN('TX99', '1001', '1002', '1003', '0603', '0601', '0602', '0600', '0606', '0604', '0605')
   --       AND p.a_last_update_date = '2018-10-11'
          AND stopDate = '12-31-2099';

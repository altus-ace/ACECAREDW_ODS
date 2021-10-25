create view vw_UHC_SecondLoadPrenatal
As
Select * from [UHC_MembersByPCP_temp] where uhc_subscriber_id in (
select p.UHC_SUBSCRIBER_ID
from [dbo].[UHC_MembersByPCP_temp] p
WHERE        (p.SUBGRP_NAME IN ('TX STAR Pregnant Woman', 'TX CHIP Perinate Perinatal <= 198 FPL before birth', 'TX CHIP Perinate Perinatal >198 & <=202 FPL <birth', 'TX STAR Pregnant Women - Qualified Alien')) AND 
                         (YEAR(p.MEMBER_CUR_EFF_DATE) = '2017')
    and  MONTH(MEMBER_CUR_EFF_DATE) = 10

EXCEPT

SELECT p.member_id
FROM cc.dbo.P6 p
WHERE MONTH(p.CREATE_DATE) >=  10
GROUP BY p.member_id)
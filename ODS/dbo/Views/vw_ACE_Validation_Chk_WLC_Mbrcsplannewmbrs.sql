
CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_Mbrcsplannewmbrs]
AS
select distinct  curr_mbr as WLCSubscriberID,
adiloaddate,
cur_effdate,
old_mbr,
old_loaddate,
mp.mbrMemberKey,
mp.effectiveDate,
mp.expirationDate 
from (
    SELECT DISTINCT
           p.Sub_ID curr_mbr,
		 p2.Sub_ID as old_mbr,
           p.LoadDate AS adiloaddate,
           p.EffDate AS cur_effdate,
         
           P.loaddate AS cur_loaddate,
        
           p2.EffDate AS old_effdate,
           p2.loaddate AS old_loaddate
    FROM ACECAREDW.adi.[MbrWlcMbrByPcp] p
       left  JOIN
(
    SELECT *
    FROM ACECAREDW.adi.MbrWlcMbrByPcp
    WHERE MONTH(loaddate) = MONTH(GETDATE()) - 1
          AND YEAR(loaddate) = YEAR(GETDATE())
) AS p2 ON p2.Sub_ID = p.Sub_ID
    WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
          AND YEAR(p.loaddate) = YEAR(GETDATE())
) AS ss
inner join ACECAREDW.adw.MbrWlcProviderLookup pl on pl.Prov_id=pl.Prov_id
LEFT JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = ss.curr_mbr
left JOIN ACECAREDW.adw.mbrCsPlanHistory mp ON mp.mbrMemberKey = m.mbrMemberKey 
WHERE ss.old_mbr is null and mp.mbrMemberKey is null 
and YEAR(ss.cur_effdate) <>'2019'

--and mp.ExpirationDate<>'2099-12-31'



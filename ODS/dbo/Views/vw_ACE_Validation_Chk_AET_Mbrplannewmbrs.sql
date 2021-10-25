



CREATE VIEW [dbo].[vw_ACE_Validation_Chk_AET_Mbrplannewmbrs]
AS
select curr_mbr as AetsubsriberId,cur_loaddate,old_mbr,old_loaddate,mp.mbrMemberKey,mp.effectiveDate,mp.expirationDate 
from (
    SELECT DISTINCT
           p.AetSubscriberID curr_mbr,
		 p2.AetSubscriberID as old_mbr,
           p.LoadDate AS cur_loaddate,
        --   p.EffectiveDate AS cur_effdate,
           --p.Product AS cur_plan,
		-- p.GroupIndicator,
        --   P.TIN AS cur_tin,
		--  p2.EffectiveDate AS old_effdate,
         --  p2.Product AS cur_plan,
		-- p2.GroupIndicator,
         --  P2.TIN AS cur_tin,
           p2.loaddate AS old_loaddate
    FROM ACECAREDW.adi.[MbrAetMbrByPcp] p
       left  JOIN
(
    SELECT distinct c.AetSubscriberID,c.EffectiveDate,c.Product,c.GroupIndicator,c.TIN,c.loaddate
    FROM ACECAREDW.adi.[MbrAetMbrByPcp] c
    INNER JOIN vw_Aetna_ProviderRoster p  ON convert(int,p.[TAX ID])=convert(int,c.TIN)
    WHERE MONTH(loaddate) = MONTH(GETDATE()) - 1
          AND YEAR(loaddate) = YEAR(GETDATE())
) AS p2 ON p2.AetSubscriberID = p.AetSubscriberID
INNER JOIN vw_Aetna_ProviderRoster P1 ON convert(int,P1.[TAX ID])=convert(int,p.TIN)
    WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
          AND YEAR(p.loaddate) = YEAR(GETDATE())
) AS ss
LEFT JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = ss.curr_mbr
left JOIN ACECAREDW.adw.MbrPlan mp ON mp.mbrMemberKey = m.mbrMemberKey 
WHERE old_mbr is null and 
mp.MbrMemberKey is null and
 GETDATE()  between mp.EffectiveDate and mp.ExpirationDate



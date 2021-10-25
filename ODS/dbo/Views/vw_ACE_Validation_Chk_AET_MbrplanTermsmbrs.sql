



CREATE VIEW [dbo].[vw_ACE_Validation_Chk_AET_MbrplanTermsmbrs]
AS
SELECT old_mbr ,
      old_loaddate,
       cur_effdate,
      cur_mbr,
       cur_loaddate,
	  m.ClientmemberKey,
       mp.mbrMemberKey,
       mp.effectiveDate,
       mp.expirationDate
FROM
(
    SELECT DISTINCT
           p.AetSubscriberID old_mbr,
           p2.AetSubscriberID AS cur_mbr,
           p.LoadDate AS old_loaddate,
           p.EffectiveDate AS old_effdate,
           concat(p.Product,'-',p.GroupIndicator) AS old_plan,
           P.tin AS old_provid,
           P.tinname AS old_provname,
           p2.tinname AS cur_provName,
           p2.tin AS cur_provid,
          -- P.loaddate AS cur_loaddate,
           concat(p2.Product,'-',p2.GroupIndicator) AS cur_plan,
           p2.EffectiveDate AS cur_effdate,
           p2.loaddate AS cur_loaddate
    FROM ACECAREDW.adi.MbrAetMbrByPcp p
         LEFT JOIN
(
    SELECT *
    FROM ACECAREDW.adi.MbrAetMbrByPcp
    WHERE MONTH(loaddate) = MONTH(GETDATE())
          AND YEAR(loaddate) = YEAR(GETDATE())
) AS p2 ON p2.AetSubscriberID = p.AetSubscriberID
    WHERE MONTH(p.LoadDate) = MONTH(GETDATE()) - 1
          AND YEAR(p.loaddate) = YEAR(GETDATE())
) AS ss
LEFT JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = ss.old_mbr
LEFT JOIN ACECAREDW.adw.mbrplan mp ON mp.mbrMemberKey = m.mbrMemberKey
WHERE ss.cur_mbr IS NULL
      AND 
	   getdate() between mp.effectivedate and mp.ExpirationDate 



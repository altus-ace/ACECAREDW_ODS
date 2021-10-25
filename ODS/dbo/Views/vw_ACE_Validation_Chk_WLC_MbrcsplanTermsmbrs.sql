


CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_MbrcsplanTermsmbrs]
AS
SELECT old_mbr AS Sub_id,
      old_loaddate,
       cur_effdate,
       old_mbr,
       cur_loaddate,
       mp.mbrMemberKey,
       mp.effectiveDate,
       mp.expirationDate
FROM
(
    SELECT DISTINCT
           p.Sub_id old_mbr,
           p2.Sub_id AS cur_mbr,
           p.LoadDate AS old_loaddate,
           p.EffDate AS old_effdate,
           p.BenePLAN AS old_plan,
           P.Prov_id AS old_provid,
           P.Prov_Name AS old_provname,
           p2.Prov_Name AS cur_provName,
           p2.Prov_id AS cur_provid,
          -- P.loaddate AS cur_loaddate,
           p2.BenePLAN AS cur_plan,
           p2.EffDate AS cur_effdate,
           p2.loaddate AS cur_loaddate
    FROM ACECAREDW.adi.[MbrWlcMbrByPcp] p
         LEFT JOIN
(
    SELECT *
    FROM ACECAREDW.adi.MbrWlcMbrByPcp
    WHERE MONTH(loaddate) = MONTH(GETDATE())
          AND YEAR(loaddate) = YEAR(GETDATE())
) AS p2 ON p2.Sub_id = p.Sub_id
    WHERE MONTH(p.LoadDate) = MONTH(GETDATE()) - 1
          AND YEAR(p.loaddate) = YEAR(GETDATE())
) AS ss
LEFT JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = ss.old_mbr
LEFT JOIN ACECAREDW.adw.mbrCsPlanHistory mp ON mp.mbrMemberKey = m.mbrMemberKey
WHERE ss.cur_mbr IS NULL
    AND getdate() between mp.effectivedate and mp.ExpirationDate 



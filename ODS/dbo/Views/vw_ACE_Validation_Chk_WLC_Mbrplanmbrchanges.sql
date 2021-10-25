

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_Mbrplanmbrchanges]
AS

select * from (
SELECT Sub_id,
       change,
       cur_plan,
       cur_effDate,
       old_effDate,
       old_plan,
       mp.productsubplan,
       mp.EffectiveDate,
       mp.ExpirationDate,
	  case when cur_plan <> mp.ProductSubPlan then 1 else 0 end as mpcpchangeerror  
       
FROM
(
    SELECT Sub_id,
           CASE
               WHEN cur_plan <> old_plan
               THEN '1'
               ELSE 0
           END AS change,
           cur_plan,
           old_plan,
           cur_effdate,
           old_effdate,
           old_provName,
           cur_provname
    FROM
(
    SELECT DISTINCT
           p.Sub_id,
           p.LoadDate AS adiloaddate,
           p.EffDate AS cur_effdate,
           p.BenePLAN AS cur_plan,
           P.Prov_id AS cur_provid,
           P.Prov_Name AS cur_provname,
           p2.Prov_Name AS old_provName,
           p2.Prov_id AS old_provid,
           P.loaddate AS cur_loaddate,
           p2.BenePLAN AS old_plan,
           p2.EffDate AS old_effdate,
           p2.loaddate AS old_loaddate
    FROM ACECAREDW.adi.[MbrWlcMbrByPcp] p
         JOIN
(
    SELECT *
    FROM ACECAREDW.adi.MbrWlcMbrByPcp
    WHERE MONTH(loaddate) = MONTH(GETDATE()) - 1
          AND YEAR(loaddate) = YEAR(GETDATE())
) AS p2 ON p2.Sub_id = p.Sub_id
    WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
          AND YEAR(p.loaddate) = YEAR(GETDATE())
) AS ss
) a
LEFT JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = a.Sub_id
inner JOIN ACECAREDW.adw.mbrplan mp ON mp.mbrMemberKey = m.mbrMemberKey and mp.ExpirationDate='2099-12-31'
WHERE a.change = 1) a where a.mpcpchangeerror=1


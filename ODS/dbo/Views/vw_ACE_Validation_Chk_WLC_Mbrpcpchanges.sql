


CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_Mbrpcpchanges]
AS
select * ,case when cur_tin <> mpcptin then 1 else 0 end as tinchangeerror,
case when cur_npi <> mpcpnpi then 1 else 0 end as npichangeerror from (
Select b.sub_id
,b.cur_provid
,b.cur_provname
,b.old_provid
,b.old_provName
,m.mbrMemberKey as mpcpmbr,v.TIN cur_tin,v.NPI as cur_npi,
mp.tin as mpcptin ,mp.npi as mpcpnpi from (
SELECT Sub_id,
       change,
      -- mp.EffectiveDate,
      -- mp.ExpirationDate,
       cur_provname,
       old_provName,
	  cur_provid,
	  --v.Prov_id as mpcpprovid,
	  old_provid
       
FROM
(
    SELECT Sub_id,
       
          CASE
               WHEN cur_provid <> old_provid
               THEN '1'
               ELSE 0
           END AS change,
		 cur_provid,
           cur_plan,
           old_plan,
           cur_effdate,
           old_effdate,
           old_provName,
           cur_provname,
		 old_provid
    FROM
(
    SELECT DISTINCT
           p.Sub_id,
		   P.loaddate AS cur_loaddate,
           p.EffDate AS cur_effdate,
           p.BenePLAN AS cur_plan,
           P.Prov_id AS cur_provid,
           P.Prov_Name AS cur_provname,
           p2.Prov_Name AS old_provName,
           p2.Prov_id AS old_provid,
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
) a WHERE a.change = 1) as b 
inner JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = b.Sub_id
inner join ACECAREDW.adw.MbrWlcProviderLookup v on v.Prov_id=b.cur_provid
inner JOIN ACECAREDW.adw.mbrpcp mp ON mp.mbrMemberKey = m.mbrMemberKey and getdate() between mp.effectivedate and mp.expirationdate
) as s



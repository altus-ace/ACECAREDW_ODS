


create VIEW [dbo].[vw_ACE_Validation_Chk_AET_Mbrpcpchanges]
AS
select * ,case when cur_provtin <> mpcptin then 1 else 0 end as tinchangeerror,
case when cur_provnpi <> mpcpnpi then 1 else 0 end as npichangeerror from (
Select b.AetSubscriberID
,b.cur_provtin
,b.cur_provnpi
,b.old_Provtin,
 b.old_provNpi
,m.mbrMemberKey as mpcpmbr,
mp.tin as mpcptin ,mp.npi as mpcpnpi from (
SELECT *
       
FROM
(
    SELECT AetSubscriberID,
       cur_loaddate,
          CASE
               WHEN cur_provtin <> old_Provtin
               THEN '1'
               ELSE 0
           END AS change,
		 cur_provtin,
		 cur_provnpi,
          old_Provtin,
           old_provNpi
		
    FROM
(
    SELECT DISTINCT
           p.AetSubscriberID,
		   P.loaddate AS cur_loaddate,
               p.Product AS cur_plan,
           P.tin AS cur_provtin,
           P.npi as cur_provnpi,
           p2.npi AS old_provNpi,
           p2.tin AS old_Provtin,
           p2.Product AS old_plan,        
           p2.loaddate AS old_loaddate
    FROM ACECAREDW.adi.[MbrAetMbrByPcp] p
         JOIN
(
    SELECT *
    FROM ACECAREDW.adi.MbrAetMbrByPcp
    WHERE MONTH(loaddate) = MONTH(GETDATE()) - 1
          AND YEAR(loaddate) = YEAR(GETDATE())
) AS p2 ON p2.AetSubscriberID = p.AetSubscriberID
    WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
          AND YEAR(p.loaddate) = YEAR(GETDATE())
) AS ss
) a WHERE a.change = 1) as b 
inner JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = b.AetSubscriberID
inner join ACECAREDW.dbo.vw_Aetna_ProviderRoster v on v.[tax Id]=b.cur_provtin
inner JOIN ACECAREDW.adw.mbrpcp mp ON mp.mbrMemberKey = m.mbrMemberKey and getdate() between mp.effectivedate and mp.expirationdate
) as s



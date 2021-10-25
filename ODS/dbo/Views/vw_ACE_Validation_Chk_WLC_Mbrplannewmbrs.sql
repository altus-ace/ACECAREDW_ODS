CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_Mbrplannewmbrs]
AS
     SELECT DISTINCT 
            curr_mbr AS WLCSubscriberID, 
            adiloaddate, 
            cur_effdate, 
            old_mbr, 
            old_loaddate, 
            mp.mbrMemberKey, 
            mp.effectiveDate, 
            mp.expirationDate
     FROM
     (
         SELECT DISTINCT 
                p.Sub_ID curr_mbr, 
                p2.Sub_ID AS old_mbr, 
                p.LoadDate AS adiloaddate, 
                p.EffDate AS cur_effdate, 
                P.loaddate AS cur_loaddate, 
                p2.EffDate AS old_effdate, 
                p2.loaddate AS old_loaddate
         FROM ACECAREDW.adi.[MbrWlcMbrByPcp] p
              LEFT JOIN
         (
             SELECT *
             FROM ACECAREDW.adi.MbrWlcMbrByPcp
             WHERE MONTH(loaddate) = MONTH(GETDATE()) - 1
                   AND YEAR(loaddate) = YEAR(GETDATE())
         ) AS p2 ON p2.Sub_ID = p.Sub_ID
         WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
               AND YEAR(p.loaddate) = YEAR(GETDATE())
     ) AS ss
     INNER JOIN ACECAREDW.adw.MbrWlcProviderLookup pl ON pl.Prov_id = pl.Prov_id
     LEFT JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = ss.curr_mbr
     LEFT JOIN ACECAREDW.adw.mbrplan mp ON mp.mbrMemberKey = m.mbrMemberKey
     WHERE ss.old_mbr IS NULL
           AND mp.mbrMemberKey IS NULL
           AND YEAR(ss.cur_effdate) <> '2019'
		 AND DATEDIFF(day, mp.effectivedate, mp.expirationdate) > 0
    ;

--and mp.ExpirationDate<>'2099-12-31'


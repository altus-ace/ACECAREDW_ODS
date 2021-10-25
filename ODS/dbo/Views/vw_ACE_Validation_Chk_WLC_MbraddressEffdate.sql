

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_MbraddressEffdate]
AS
     SELECT DISTINCT
            m.mbrmemberkey AS mbrmembermbrkey,
            m.ClientMemberKey,
            p.LoadDate AS adiloaddate,
            ma.mbrmemberkey AS mbraddrmbrmemberkey,
		  ma.EffectiveDate as mbraddrffectivdate,
		  p.EffDate as adimbreffdate
     FROM ACECAREDW.adi.[MbrWlcMbrByPcp] p
          LEFT JOIN acecaredw.[adw].[MbrMember] m ON m.ClientMemberKey = p.Sub_ID
          INNER JOIN [ACECAREDW].[lst].[List_Client] lc ON lc.Clientkey = m.clientkey
           left join [ACECAREDW].[adw].[MbrAddress]  ma on ma.mbrmemberkey=m.mbrmemberkey                                         
     WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
           AND YEAR(p.loaddate) = YEAR(GETDATE())
           AND lc.ClientKey = 2
	 and ma.mbrMemberKey is null

	 
        

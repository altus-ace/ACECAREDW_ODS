

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_Mbrphonecheck]
AS
     SELECT DISTINCT
            m.mbrmemberkey AS mbrmembermbrkey,
            m.ClientMemberKey,
            p.LoadDate AS adiloaddate,
            mpp.mbrmemberkey AS mbrphonembrmemberkey,
		  ---mpp.EffectiveDate as mbrphoneffectivdate,
		 -- p.EffDate as adimbreffdate,
		  p.phonenumber as adiphone,
		  P.MOBILE_PHONE,
		  P.ALT_PHONE,
		 mpp.phonenumber
     FROM ACECAREDW.adi.[MbrWlcMbrByPcp] p
          LEFT JOIN acecaredw.[adw].[MbrMember] m ON m.ClientMemberKey = p.Sub_ID
          INNER JOIN [ACECAREDW].[lst].[List_Client] lc ON lc.Clientkey = m.clientkey
           left join [ACECAREDW].[adw].[MbrPhone]  mpp on mpp.mbrmemberkey=m.mbrmemberkey-- and mpp.PhoneNumber=p.phonenumber                               
     WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
           AND YEAR(p.loaddate) = YEAR(GETDATE())
           AND lc.ClientKey = 2
	 and mpp.mbrMemberKey is null and p.PhoneNumber <> ''
	



       

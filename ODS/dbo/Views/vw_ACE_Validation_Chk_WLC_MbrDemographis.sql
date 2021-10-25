
CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_MbrDemographis]
AS
     SELECT DISTINCT
            m.mbrmemberkey AS mbrmembermbrkey,
            m.ClientMemberKey,
            p.LoadDate AS adiloaddate,
            md.mbrmemberkey AS mbrdemombrmemberkey,
		  md.EffectiveDate as mbrdemoeffectivdate,
		  p.EffDate as adimbreffdate
		  --case when md.mbrmemberkey is null then '1' end as MbrnotfoundinMbrdemographic
		--  case when p.effdate> getdate() 
     FROM ACECAREDW.adi.[MbrWlcMbrByPcp] p
          LEFT JOIN acecaredw.[adw].[MbrMember] m ON m.ClientMemberKey = p.Sub_id
          INNER JOIN [ACECAREDW].[lst].[List_Client] lc ON lc.Clientkey = m.clientkey
          LEFT JOIN [ACECAREDW].[adw].[MbrDemographic] md ON md.[mbrMemberKey] = m.[mbrMemberKey] 
     WHERE MONTH(p.LoadDate) = MONTH(GETDATE())
           AND YEAR(p.loaddate) = YEAR(GETDATE())
           AND lc.ClientKey = 2
		 and md.mbrMemberKey is null
	

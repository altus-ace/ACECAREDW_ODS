

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_MbrCsPlanNoPcp]
AS
     SELECT DISTINCT 
            p.sub_id, 
            mp.mbrmemberkey AS mpcpmbr, 
            mcp.mbrmemberkey AS csplanmbr, 
            mcp.effectivedate
     FROM [adi].[MbrWlcMbrByPcp] p
          INNER JOIN adw.mbrmember m ON m.clientmemberkey = p.Sub_id
          LEFT JOIN adw.mbrpcp mp ON mp.mbrmemberkey = m.mbrmemberkey
          LEFT JOIN adw.mbrcsplanhistory mcp ON mcp.mbrmemberkey = m.mbrmemberkey
          INNER JOIN [dbo].[vw_ACE_Validation_Chk_WLC_ProviderIDNotinSF] prp ON prp.Prov_id = p.Prov_id
                                                                                AND mcp.mbrmemberkey IS NOT NULL
    --WHERE --p.loaddate = '12/06/2018' AND  
	--   DATEDIFF(day, mcp.effectivedate, mcp.expirationdate) > 0 -- makes sure the cs plan is effective.
    --ORDER BY p.Sub_ID, p.loaddate asc
;


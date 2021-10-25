CREATE VIEW [dbo].[vw_ACE_Validation_Chk_WLC_Mbrplannopcp]
AS
     SELECT DISTINCT 
            p.sub_id, 
            mp.mbrmemberkey AS mpcpmbr, 
            mcp.mbrmemberkey AS csplanmbr, 
            mcp.effectivedate
     FROM [adi].[MbrWlcMbrByPcp] p
          INNER JOIN adw.mbrmember m ON m.clientmemberkey = p.Sub_id
          LEFT JOIN adw.mbrpcp mp ON mp.mbrmemberkey = m.mbrmemberkey
          LEFT JOIN adw.MbrPlan mcp ON mcp.mbrmemberkey = m.mbrmemberkey
          INNER JOIN [dbo].[vw_ACE_Validation_Chk_WLC_ProviderIDNotinSF] prp ON prp.Prov_id = p.Prov_id
                                                                                AND mcp.mbrmemberkey IS NOT NULL;

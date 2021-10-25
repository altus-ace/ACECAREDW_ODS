create view [dbo].[vw_ACE_Validation_Chk_AET_Mbrcsplannopcp]
AS
select Distinct p.AetSubscriberID,mp.mbrmemberkey as mpcpmbr,mcp.mbrmemberkey as csplanmbr,mcp.effectivedate from [adi].MbrAetMbrByPcp p
inner join adw.mbrmember m on m.clientmemberkey=p.AetSubscriberID
left join adw.mbrpcp mp on mp.mbrmemberkey=m.mbrmemberkey
left join adw.mbrcsplanhistory mcp on mcp.mbrmemberkey=m.mbrmemberkey
inner join [dbo].[vw_ACE_Validation_Chk_AET_ProviderNotinSF] prp on prp.tin=p.tin
and mcp.mbrmemberkey is not null

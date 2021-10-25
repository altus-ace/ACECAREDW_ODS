
create view vw_RP_AetCurrentmonthnewmembers
as
select  Tin, AetSubscriberID,
 npi,
    loaddate from (
SELECT DISTINCT 
   p.tin, p.AetSubscriberID,
 p.npi,
    p.loaddate,p.EffectiveDate,pp.AetSubscriberID as oldid
FROM adi.MbrAetMbrByPcp p
inner join vw_Aetna_ProviderRoster ap on convert(int,ap.[TAX ID])=convert(int,p.TIN)

left join (
SELECT DISTINCT 
   p.tin, p.AetSubscriberID,
 p.npi,
    p.loaddate
FROM adi.MbrAetMbrByPcp p
inner join vw_Aetna_ProviderRoster ap on convert(int,ap.[TAX ID])=convert(int,p.TIN)
where month(loaddate)=month(getdate())-1 and year(LoadDate)=YEAR(getdate()))
 pp on pp.AetSubscriberID=p.AetSubscriberId

 where month(p.loaddate)=month(getdate()) and year(p.LoadDate)=YEAR(getdate())) as s where s.oldid is null


CREATE view [dbo].[vw_ACE_Validation_Chk_AET_NewProviderMembersadded]
AS
select * from (
SELECT DISTINCT 
   p.tin curtin,p.tinname curtinname,pp.tin as pevtin,pp.tinname as pevtinname
 
FROM adi.MbrAetMbrByPcp p
inner join vw_Aetna_ProviderRoster ap on convert(int,ap.[TAX ID])=convert(int,p.TIN)

left join (
SELECT DISTINCT 
   p.tin,
 p.npi,p.tinname,
    p.loaddate
FROM adi.MbrAetMbrByPcp p
inner join vw_Aetna_ProviderRoster ap on convert(int,ap.[TAX ID])=convert(int,p.TIN)
where month(loaddate)=month(getdate())-1 and year(LoadDate)=YEAR(getdate()))
 pp on pp.tin=p.tin

 where month(p.loaddate)=month(getdate()) and year(p.LoadDate)=YEAR(getdate()) and ap.LOB in ('Medicare Advantage') and ap.term_date__C is null) as s where s.pevtinname is null

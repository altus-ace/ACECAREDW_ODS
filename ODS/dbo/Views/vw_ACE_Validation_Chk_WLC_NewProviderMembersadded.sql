create view vw_ACE_Validation_Chk_WLC_NewProviderMembersadded
AS
select * from (
SELECT DISTINCT 
   ap.tin curtin,ap.PracticeName curtinname,pp.tin as pevtin,pp.tinname as pevtinname
 
FROM adi.MbrWlcMbrByPcp p
inner join [adw].[MbrWlcProviderLookup] ap on convert(int,ap.Prov_id)=convert(int,p.Prov_id)

left join (
SELECT DISTINCT 
   ap.tin,
 ap.npi,ap.PracticeName as tinname,
    p.loaddate
FROM adi.mbrWlcMbrBypcp p
inner join [adw].[MbrWlcProviderLookup] ap on convert(int,ap.Prov_id)=convert(int,p.Prov_id)
where month(loaddate)=month(getdate())-1 and year(LoadDate)=YEAR(getdate()))
 pp on pp.tin=ap.tin

 where month(p.loaddate)=month(getdate()) and year(p.LoadDate)=YEAR(getdate())) as s where s.pevtinname is null


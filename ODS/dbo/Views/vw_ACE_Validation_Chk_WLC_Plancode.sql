create view [dbo].[vw_ACE_Validation_Chk_WLC_Plancode]
As
select * from (
SELECT distinct p.beneplan adiPlancode,lpm.SourceValue as map_plancode,p.EffDate as adieffectivedate
FROM            adi.MbrWlcMbrByPcp p
left join lst.lstPlanMapping lpm on lpm.SourceValue=p.BenePLAN and TargetSystem='CS_AHS'
WHERE       month(loaddate)=month(getdate()) and year(loaddate) =year(getdate())
)s where map_plancode is null
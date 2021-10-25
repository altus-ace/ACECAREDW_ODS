
create view [dbo].[vw_ACE_Validation_Chk_AET_Plancode]
As
select * from (
SELECT distinct p.product adiPlan,lpm.SourceValue as map_plancode  from   [adi].[MbrAetMbrByPcp] p
left join lst.lstPlanMapping lpm on lpm.SourceValue=p.product and TargetSystem='CS_AHS'
WHERE       month(loaddate)=month(getdate()) and year(loaddate) =year(getdate())
)s where map_plancode is null

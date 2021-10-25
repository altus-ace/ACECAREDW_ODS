



create VIEW [dbo].[vw_ACE_Validation_Chk_AET_MbrcsplanChangembrs]
AS
select distinct  ss.cur_mbr,ss.cur_plan,ss.old_plan,m.ClientMemberKey,mp.EffectiveDate,mp.ExpirationDate,mp.MbrCsSubPlan,mp.MbrCsSubPlanName from (
select * ,case when cur_plan <> old_plan then 1 else 0 end as change from (
   SELECT DISTINCT
           p.AetSubscriberID cur_mbr,
         
           p.LoadDate AS cur_loaddate,
           p.EffectiveDate AS cur_effdate,
          p.Product AS cur_plan,
           P.tin AS cur_provid,
           P.tinname AS cur_provname
          
    FROM ACECAREDW.adi.MbrAetMbrByPcp p
   inner join vw_Aetna_ProviderRoster pr on pr.[tax id]=p.tin
    WHERE MONTH(p.LoadDate) = MONTH(GETDATE()) 
          AND YEAR(p.loaddate) = YEAR(GETDATE())
		) as c 
		inner join 
		(SELECT DISTINCT
           p.AetSubscriberID old_mbr,
         
           p.LoadDate AS old_loaddate,
           p.EffectiveDate AS old_effdate,
          p.Product AS old_plan,
           P.tin AS old_provid,
           P.tinname AS old_provname
          
    FROM ACECAREDW.adi.MbrAetMbrByPcp p
   inner join vw_Aetna_ProviderRoster pr on pr.[tax id]=p.tin
    WHERE --p.AetSubscriberID='231512142701052801' and 
     MONTH(p.LoadDate) = MONTH(GETDATE()) -1
          AND YEAR(p.loaddate) = YEAR(GETDATE())) o on o.old_provid=c.cur_provid  
		where  o.old_mbr is not null
		) as ss 
LEFT JOIN ACECAREDW.adw.mbrmember m ON m.Clientmemberkey = ss.cur_mbr
LEFT JOIN ACECAREDW.adw.mbrCsPlanHistory mp ON mp.mbrMemberKey = m.mbrMemberKey and GETDATE() between mp.EffectiveDate and mp.ExpirationDate
where change=1 and convert(date,mp.EffectiveDate) <> convert(date,DATEADD( day, - day(getdate())+1,getdate()))


    --  AND 
	-- mp.ExpirationDate = '2099-12-31';










CREATE VIEW [dbo].[vw_ACE_Validation_Chk_AET_ProviderinSFNotinMembership]
AS

 
 
 SELECT distinct
      p.[TAX ID],
	 p.[GROUP NAME],p.effective_date__C AS SF_EFFETIVE_DATE
	
	   FROM acecaredw.[dbo].vw_Aetna_ProviderRoster p
		
		  left join ( 
SELECT DISTINCT 
   tin, 
 npi,
    loaddate
FROM adi.MbrAetMbrByPcp
where month(loaddate)=month(getdate()) and year(LoadDate)=YEAR(getdate())) m
  
		  ON convert(int,m.TIN) = convert(int,p.[TAX ID])
		  
		  WHERE m.TIN IS NULL and p.LOB in ('Medicare Advantage') and p.term_date__C is null






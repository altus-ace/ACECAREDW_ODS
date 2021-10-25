

CREATE view [dbo].[vw_ACE_Validation_Chk_AET_Non_Contracted_Members]
AS
SELECT DISTINCT 
    m.tin,
    m.tinName,provlookup.[tax id]
	,m.AetSubscriberID
FROM adi.MbrAetMbrByPcp m
    left JOIN (SELECT * FROM ACECAREDW.DBO.vw_Aetna_ProviderRoster where lob in ('Medicare Advantage') and term_date__C is null ) provLookup ON convert(int,m.tin) = convert(int,provLookup.[tax id])
		  where month(m.loaddate)=month(getdate()) and year(m.LoadDate)=YEAR(getdate())
  and 
  provLookup.[tax id] is null



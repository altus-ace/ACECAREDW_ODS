



CREATE VIEW [adw].[vw_Dashboard_AttribMembership_NPI]
AS

-- By Client, AcctType
SELECT ClientKey, ClientName, AttribNPI, AttribAcctType, EffYr, EffMth
	,CONCAT(EffYr, CASE WHEN cast(EffMth as varchar(2)) in ('10','11','12') THEN cast(EffMth as varchar(2)) ELSE CONCAT('0',cast(EffMth as varchar(2))) END) as EffYYYYMM
	,CONCAT(EffYr, '-', CASE WHEN cast(EffMth as varchar(2)) in ('10','11','12') THEN cast(EffMth as varchar(2)) ELSE CONCAT('0',cast(EffMth as varchar(2))) END,'-01') as EffDate
	,COUNT(distinct CONCAT(ClientKey,ClientMemberKey)) as CntRec
	FROM dbo.z_tmp_AttribMembers_FINAL
	WHERE EffectiveAsOfDate = (SELECT MAX(EffectiveAsOfDate) FROM dbo.z_tmp_AttribMembers_FINAL)
GROUP BY ClientKey, ClientName, AttribNPI, AttribAcctType,EffYr, EffMth



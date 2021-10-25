



CREATE VIEW [adw].[vw_Dashboard_AttribMembership]
AS

-- By Client, AcctType
SELECT ClientKey, ClientName, AttribAcctType, EffYr, EffMth
	,CONCAT(EffYr, CASE WHEN cast(EffMth as varchar(2)) in ('10','11','12') THEN cast(EffMth as varchar(2)) ELSE CONCAT('0',cast(EffMth as varchar(2))) END) as EffYYYYMM
	,CONCAT(EffYr, '-', CASE WHEN cast(EffMth as varchar(2)) in ('10','11','12') THEN cast(EffMth as varchar(2)) ELSE CONCAT('0',cast(EffMth as varchar(2))) END,'-01') as EffDate
	,COUNT(distinct CONCAT(ClientKey,ClientMemberKey)) as CntRec
	FROM dbo.z_tmp_AttribMembers_FINAL
	WHERE EffectiveAsOfDate = (SELECT MAX(EffectiveAsOfDate) FROM dbo.z_tmp_AttribMembers_FINAL)
GROUP BY ClientKey, ClientName, AttribAcctType,EffYr, EffMth
--ORDER BY ClientKey, ClientName, AttribAcctType,EffYr, EffMth

-- By Client, AcctType, NPI
--SELECT ClientKey, ClientName, AttribAcctType, AttribNPI, NPIName, EffYr, EffMth, COUNT(distinct CONCAT(ClientKey,ClientMemberKey)) as CntRec
--	FROM dbo.z_tmp_AttribMembers_FINAL
--	WHERE EffectiveAsOfDate = @EffectiveAsOfDate1
--GROUP BY ClientKey, ClientName, AttribAcctType, AttribNPI,NPIName, EffYr, EffMth
--ORDER BY ClientKey, ClientName, AttribAcctType, AttribNPI,NPIName, EffYr, EffMth



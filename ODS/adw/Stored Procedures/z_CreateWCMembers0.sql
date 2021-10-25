
create PROCEDURE adw.z_CreateWCMembers0
AS

WITH CTEu AS (
SELECT * FROM (
SELECT p.mbrWlcMbrByPcpKey as AdiKey, p.Sub_Id as ClientMemberKey, 2 as ClientKey, p.EffDate
	,convert(date,p.LoadDate) as LoadDate, ROW_NUMBER() OVER (PARTITION BY p.Sub_Id, 2, p.EffDate ORDER BY p.mbrWlcMbrByPcpKey DESC) as rn
FROM [ACECAREDW].[adi].[MbrWlcMbrByPcp] p 
JOIN lst.lstPlanMapping l 
	ON p.BenePLAN = l.SourceValue
JOIN adw.MbrWlcProviderLookup plu
	ON p.Prov_ID  = plu.Prov_ID
WHERE [Sub_ID] IS NOT NULL 
AND convert(date,p.LoadDate) = '2020-01-23'
AND l.clientkey = 2
AND getdate() BETWEEN l.EffectiveDate AND l.ExpirationDate
AND L.TargetSystem = 'ACDW'
AND p.IPA IN ('ALTUS ACE NETWORK IN','TX22')
) m WHERE rn = 1 )
,CTEi AS (
SELECT * FROM (
SELECT p.mbrWlcMbrByPcpKey as AdiKey, p.Sub_Id as ClientMemberKey, 2 as ClientKey, p.EffDate, convert(date,p.LoadDate) as LoadDate, ROW_NUMBER() OVER (PARTITION BY p.Sub_Id, 2, p.EffDate ORDER BY p.mbrWlcMbrByPcpKey DESC) as rn
	FROM [ACECAREDW].[adi].[MbrWlcMbrByPcp] p 
	JOIN lst.lstPlanMapping l 
		ON p.BenePLAN = l.SourceValue
	JOIN adw.MbrWlcProviderLookup plu
		ON p.Prov_ID  = plu.Prov_ID
	WHERE [Sub_ID] IS NOT NULL 
	AND convert(date,p.LoadDate) = '2020-01-23'
	AND l.clientkey = 2
	AND getdate() BETWEEN l.EffectiveDate AND l.ExpirationDate
	AND L.TargetSystem = 'ACDW'
	AND p.IPA IN ('ALTUS ACE NETWORK IN','TX22')
) n WHERE rn = 1 )
--SELECT * FROM CTEu
--SELECT * FROM CTEi


UPDATE dbo.z_CreateWCMembers 
SET ActiveFlg = 0,
	UpdateRunID = 'U1'
FROM dbo.z_CreateWCMembers m
JOIN CTEu j
ON		m.ClientMemberKey = j.ClientMemberKey
AND	m.ClientKey			= j.ClientKey
AND	m.EffDate			= j.EffDate 

INSERT INTO dbo.z_CreateWCMembers (adiKey,ClientMemberKey,ClientKey,EffDate,LoadDate,InsertRunID)
SELECT p.adiKey, p.ClientMemberKey, ClientKey, p.EffDate, p.LoadDate, 'I2'
FROM CTEi p

--select * from dbo.z_CreateWCMembers where ActiveFlg = 1
--truncate table dbo.z_CreateWCMembers
/***
EXEC adw.z_CreateWCMembers0
***/
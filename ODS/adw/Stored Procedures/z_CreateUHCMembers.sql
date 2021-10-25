/***
V4		2021-04-28	Added new table (dbo.z_tmp_AttribMembers_Failed) to store all Failed NPI/Plan Match
		2021-04-28	Changed tvf for Provider Roster
		2021-09-01  Added AND AttribNPI IS NOT NULL & OR AttribNPI IS NULL to insert statement to acct for changes to dbo. Prior to 8/23, loaded all mbrs into dbo.
						After 8/23, loaded on mbrs with matching NPI into dbo
'
***/
CREATE PROCEDURE adw.z_CreateUHCMembers
(@YEStartDate			VARCHAR(20),
 @YEEndDate				VARCHAR(20),
 @EffectiveAsOfDate	VARCHAR(20)
)
AS

DECLARE @MELoadDateTable	TABLE(
	 URN					INT	IDENTITY NOT NULL
	,MELoadDate			DATE	 
	,NumOfRecs			INT)
INSERT INTO @MELoadDateTable
	(MELoadDate,NumOfRecs)
SELECT DISTINCT CONVERT(date,p.A_LAST_UPDATE_DATE), COUNT(*) FROM ACECAREDW.dbo.Uhc_MembersByPcp p 
WHERE p.A_LAST_UPDATE_DATE BETWEEN @YEStartDate AND @YEEndDate
GROUP BY CONVERT(date,p.A_LAST_UPDATE_DATE) ORDER BY CONVERT(date,p.A_LAST_UPDATE_DATE) 

--SELECT * FROM @MELoadDateTable
DECLARE @CodeVer				VARCHAR(5)	= '4'
DECLARE @SQL					NVARCHAR(4000)
DECLARE @i						INT			= 1
DECLARE @rTotal				BIGINT		= 0
DECLARE @RowCnt				BIGINT		= 0
DECLARE @TgtTblName			VARCHAR(50)	= 'dbo.z_tmp_AttribMembers'
DECLARE @TgtTblNameFailed	VARCHAR(50)	= 'dbo.z_tmp_AttribMembers_Failed'
DECLARE @AdiMbrTable			VARCHAR(50) = 'ACECAREDW.dbo.Uhc_MembersByPcp'
DECLARE @DataDate				VARCHAR(50) = 'A_LAST_UPDATE_DATE'
DECLARE @ClientKey			VARCHAR(5)	= '1'
DECLARE @AdiKey				VARCHAR(50) = 'URN'
DECLARE @ClientMemberKey	VARCHAR(50) = 'UHC_SUBSCRIBER_ID'
DECLARE @AttribNPI			VARCHAR(50) = 'PCP_NPI'
DECLARE @EffDate				VARCHAR(50) = 'MEMBER_ORG_EFF_DATE'			-- Original Effective Date   MEMBER_CONT_EFF_DATE
DECLARE @CurEffDate			VARCHAR(50) = 'MEMBER_CUR_EFF_DATE'
DECLARE @TermDate				VARCHAR(50) = 'MEMBER_CUR_TERM_DATE'
DECLARE @adiPlan				VARCHAR(50) = 'SUBGRP_ID'
DECLARE @StartDate			VARCHAR(20) = char(39) +@YEStartDate+ char(39)
DECLARE @EndDate				VARCHAR(20) = char(39) +@YEEndDate+ char(39)
DECLARE @RunDate				VARCHAR(20) = char(39) +@EffectiveAsOfDate+ char(39)

SELECT @RowCnt = count(0) FROM @MELoadDateTable
WHILE @i <= @RowCnt
BEGIN
DECLARE @MELoadDate		VARCHAR(20)	= (SELECT MELoadDate FROM @MELoadDateTable WHERE URN = @i)
DECLARE @InsertRunID		VARCHAR(10)	= (SELECT CONCAT('I',URN) FROM @MELoadDateTable WHERE URN = @i)
DECLARE @UpdateRunID		VARCHAR(10)	= (SELECT CONCAT('U',URN) FROM @MELoadDateTable WHERE URN = @i)
--IF CONVERT(' + char(39) + 'DATE,' + char(39) + @MELoadDate + char(39) + ') <= '  + char(39) + '2021-08-01' + char(39) + ' THEN '
SET NOCOUNT ON;
SET @SQL='
IF OBJECT_ID(N'+ char(39) + 'tempdb..#tmpTable' + char(39) + ') IS NOT NULL
DROP TABLE #tmpTable
SELECT * INTO #tmpTable FROM (
SELECT p.' + @AdiKey + ' as AdiKey, CONVERT(VARCHAR(50),p.' + @ClientMemberKey + ') as ClientMemberKey, ' + @ClientKey + ' as ClientKey, p.' + @AttribNPI + ' as AttribNPI
	,CONVERT(date,p.' + @EffDate + ') as EffDate
	,CONVERT(date,p.' + @TermDate + ') as TermDate
	,CONVERT(date,p.' + @CurEffDate + ') as CurEffDate
	,CASE WHEN l.SourceValue IS NULL THEN 0 ELSE 1 END	as PlanMatchFlg
	,CASE WHEN plu.NPI IS NULL THEN 0 ELSE 1 END	as NPIMatchFlg
	,CONVERT(date,p.' + @DataDate + ') as LoadDate, ROW_NUMBER() OVER (PARTITION BY p.' + @ClientMemberKey + ' ORDER BY p.' + @AdiKey + ' DESC) as rn
FROM ' + @AdiMbrTable + ' p 
LEFT JOIN lst.lstPlanMapping l ON p.' + @adiPlan + ' = l.SourceValue
LEFT JOIN (SELECT DISTINCT NPI,NPIHpEffectiveDate,NPIHpExpirationDate,TinHpEffectiveDate,TinHpExpirationDate 
FROM ACECAREDW.adw.tvf_AllClient_ProviderRoster (' + @ClientKey + ',' + char(39) +  @MELoadDate + char(39) + ',1)) plu ON p.' +  @AttribNPI + '  = plu.NPI
AND p.' + @DataDate + ' BETWEEN TinHpEffectiveDate	AND TinHpExpirationDate
AND p.' + @DataDate + ' BETWEEN NPIHpEffectiveDate	AND NPIHpExpirationDate
WHERE p.' + @ClientMemberKey + ' IS NOT NULL 
AND p.' + @AttribNPI + ' IS NOT NULL AND convert(date,p.' + @DataDate + ') = ' + char(39) + @MELoadDate + char(39) + '
AND l.clientkey = ' + @ClientKey + ' AND p.' + @DataDate + ' BETWEEN l.EffectiveDate AND l.ExpirationDate AND L.TargetSystem = ' + char(39) + 'ACDW' + char(39) + '
UNION
SELECT p.' + @AdiKey + ' as AdiKey, CONVERT(VARCHAR(50),p.' + @ClientMemberKey + ') as ClientMemberKey, ' + @ClientKey + ' as ClientKey, p.' + @AttribNPI + ' as AttribNPI
	,CONVERT(date,p.' + @EffDate + ') as EffDate
	,CONVERT(date,p.' + @TermDate + ') as TermDate
	,CONVERT(date,p.' + @CurEffDate + ') as CurEffDate
	,CASE WHEN l.SourceValue IS NULL THEN 0 ELSE 1 END	as PlanMatchFlg
	,1	as NPIMatchFlg
	,CONVERT(date,p.' + @DataDate + ') as LoadDate, ROW_NUMBER() OVER (PARTITION BY p.' + @ClientMemberKey + ' ORDER BY p.' + @AdiKey + ' DESC) as rn
FROM ' + @AdiMbrTable + ' p 
LEFT JOIN lst.lstPlanMapping l ON p.' + @adiPlan + ' = l.SourceValue
LEFT JOIN (SELECT DISTINCT NPI,NPIHpEffectiveDate,NPIHpExpirationDate,TinHpEffectiveDate,TinHpExpirationDate 
FROM ACECAREDW.adw.tvf_AllClient_ProviderRoster (' + @ClientKey + ',' + char(39) +  @MELoadDate + char(39) + ',1)) plu ON p.' +  @AttribNPI + '  = plu.NPI
AND p.' + @DataDate + ' BETWEEN TinHpEffectiveDate	AND TinHpExpirationDate
AND p.' + @DataDate + ' BETWEEN NPIHpEffectiveDate	AND NPIHpExpirationDate
WHERE p.' + @ClientMemberKey + ' IS NOT NULL 
AND p.' + @AttribNPI + ' IS NULL AND convert(date,p.' + @DataDate + ') = ' + char(39) + @MELoadDate + char(39) + '
AND l.clientkey = ' + @ClientKey + ' AND p.' + @DataDate + ' BETWEEN l.EffectiveDate AND l.ExpirationDate AND L.TargetSystem = ' + char(39) + 'ACDW' + char(39) + '
) m WHERE rn = 1 
UPDATE ' + @TgtTblName + '
SET ActiveFlg = 0, RecStatus = '+ char(39) + 'U' + char(39) +', RecStatusDate = (sysdatetime()), UpdateRunID = ' + char(39) + @UpdateRunID + char(39) + ' ' + '
	FROM ' + @TgtTblName + ' m 
JOIN #tmpTable j ON m.ClientMemberKey = j.ClientMemberKey AND m.ClientKey = j.ClientKey AND m.EffDate	= j.EffDate
WHERE EffectiveAsOfDate = ' + char(39) + @EffectiveAsOfDate + char(39) + ' ' + '
INSERT INTO ' + @TgtTblName + ' (EffectiveAsOfDate,CodeVer,adiKey,ClientMemberKey,ClientKey,AttribNPI, EffDate, TermDate, CurEffDate, LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg, RecStatus, MaxDateFlg)
SELECT ' + @RunDate + ',' + char(39) + @CodeVer + char(39) + ',p.adiKey, p.ClientMemberKey, p.ClientKey, p.AttribNPI, p.EffDate, p.TermDate, p.CurEffDate, convert(date,p.LoadDate), ' + char(39) +  @InsertRunID + char(39) + ',PlanMatchFlg,NPIMatchFlg,' + char(39) +  'N' + char(39) + ',0 
FROM #tmpTable p WHERE p.PlanMatchFlg = 1 AND NPIMatchFlg = 1 AND AttribNPI IS NOT NULL
INSERT INTO ' + @TgtTblNameFailed + ' (EffectiveAsOfDate,CodeVer,adiKey,ClientMemberKey,ClientKey,AttribNPI, EffDate, TermDate, CurEffDate, LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg, RecStatus)
SELECT ' + @RunDate + ',' + char(39) + @CodeVer + char(39) + ',p.adiKey, p.ClientMemberKey, p.ClientKey, p.AttribNPI, p.EffDate, p.TermDate, p.CurEffDate, convert(date,p.LoadDate), ' + char(39) +  @InsertRunID + char(39) + ',PlanMatchFlg,NPIMatchFlg,' + char(39) +  'N' + char(39) + ' 
FROM #tmpTable p WHERE p.PlanMatchFlg = 0 OR NPIMatchFlg = 0 OR AttribNPI IS NULL
'

--PRINT @SQL
EXEC dbo.sp_executesql @SQL

SET @rTotal	+= @i
SET @i= @i + 1
END
/***
EXEC adw.z_CreateUHCMembers '2020-1-01','2021-08-30','2021-09-02'

SELECT * FROM dbo.z_tmp_AttribMembers				WHERE	ClientKey IN (1) AND EffectiveAsOfDate		= '2021-09-02' 
SELECT * FROM dbo.z_tmp_AttribMembers_Failed		WHERE	ClientKey IN (1) AND EffectiveAsOfDate		= '2021-09-02' 

SELECT ClientKey, LoadDate, count(distinct adikey) as CntRec FROM dbo.z_tmp_AttribMembers  GROUP BY ClientKey, LoadDate ORDER BY ClientKey, LoadDate
------------------


/*** INTO dbo.z_tmp_AttribMembers_FINAL ***/
DECLARE @EffectiveAsOfDate DATE = '2021-09-02'
INSERT INTO dbo.z_tmp_AttribMembers_FINAL 
	(EffectiveAsOfDate,SourceJob,adiKey,ClientMemberKey,ClientKey,AttribNPI,EffYr,EffMth,EffYYYYMM)			
SELECT @EffectiveAsOfDate as EffectiveDate,CONCAT('sp_CalcUHCMembers V',CodeVer)
	,adiKey
	,ClientMemberKey
	,ClientKey
	,AttribNPI
	,FORMAT(LoadDate,'yyyy') as EffYr
	,FORMAT(LoadDate,'MM') as EffMth
	,CONCAT(FORMAT(LoadDate,'yyyy'),FORMAT(LoadDate,'MM'))
FROM dbo.z_tmp_AttribMembers WHERE ClientKey = 1
	AND EffectiveAsOfDate = @EffectiveAsOfDate
	AND PlanMatchFlg = 1 AND NPIMatchFlg = 1
***/

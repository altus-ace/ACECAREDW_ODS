/***
V1		2021-05-25	Copy from sp_CalcBCBSMembers
***/
CREATE PROCEDURE adw.z_CreateAMGMAMembers
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
SELECT DISTINCT CONVERT(date,p.DataDate), COUNT(*) FROM ACDW_CLMS_AMGTX_MA.[adi].[Amerigroup_Member] p 
WHERE p.DataDate BETWEEN @YEStartDate AND @YEEndDate
AND	CONVERT(date,p.DataDate) <> '2021-03-10'													-- Do not use, dummy data
GROUP BY CONVERT(date,p.DataDate) ORDER BY CONVERT(date,p.DataDate) 

--SELECT * FROM @MELoadDateTable
DECLARE @CodeVer				VARCHAR(5)	= '4'
DECLARE @SQL					NVARCHAR(4000)
DECLARE @i						INT			= 1
DECLARE @rTotal				BIGINT		= 0
DECLARE @RowCnt				BIGINT		= 0
DECLARE @TgtTblName			VARCHAR(50)	= 'dbo.z_tmp_AttribMembers'
DECLARE @TgtTblNameFailed	VARCHAR(50)	= 'dbo.z_tmp_AttribMembers_Failed'
DECLARE @AdiMbrTable			VARCHAR(50) = 'ACDW_CLMS_AMGTX_MA.[adi].[Amerigroup_Member]'
DECLARE @DataDate				VARCHAR(50) = 'DataDate'
DECLARE @ClientKey			VARCHAR(5)	= '21'
DECLARE @AdiKey				VARCHAR(50) = '[AmerigroupMemberKey]'
DECLARE @ClientMemberKey	VARCHAR(50) = '[MasterConsumerID]'
DECLARE @AttribNPI			VARCHAR(50) = '[Responsible_NPI]'
DECLARE @EffDate				VARCHAR(50) = '[EligibilityEffectiveDate]'									-- Original Effective Date
DECLARE @CurEffDate			VARCHAR(50) = '[EligibilityEffectiveDate]'	
DECLARE @TermDate				VARCHAR(50) = '[EligibilityEndDate]'
DECLARE @adiPlan				VARCHAR(50) = '[BNFTPKGID]'
DECLARE @StartDate			VARCHAR(20) = char(39) +@YEStartDate+ char(39)
DECLARE @EndDate				VARCHAR(20) = char(39) +@YEEndDate+ char(39)
DECLARE @RunDate				VARCHAR(20) = char(39) +@EffectiveAsOfDate+ char(39)

SELECT @RowCnt = count(0) FROM @MELoadDateTable
WHILE @i <= @RowCnt
BEGIN
DECLARE @MELoadDate		VARCHAR(20)	= (SELECT MELoadDate FROM @MELoadDateTable WHERE URN = @i)
DECLARE @InsertRunID		VARCHAR(10)	= (SELECT CONCAT('I',URN) FROM @MELoadDateTable WHERE URN = @i)
DECLARE @UpdateRunID		VARCHAR(10)	= (SELECT CONCAT('U',URN) FROM @MELoadDateTable WHERE URN = @i)

SET NOCOUNT ON;
SET @SQL='
IF OBJECT_ID(N'+ char(39) + 'tempdb..#tmpTable' + char(39) + ') IS NOT NULL
DROP TABLE #tmpTable
SELECT * INTO #tmpTable FROM (
SELECT p.' + @AdiKey + ' as AdiKey,  CONVERT(VARCHAR(50),p.' + @ClientMemberKey + ') as ClientMemberKey, ' + @ClientKey + ' as ClientKey, p.' + @AttribNPI + ' as AttribNPI
	,CONVERT(date,c.' + @EffDate + ') as EffDate
	,CONVERT(date,c.' + @TermDate + ') as TermDate
	,CONVERT(date,c.' + @CurEffDate + ') as CurEffDate
	,CONVERT(date,' + @StartDate + ') as YrStartDate
	,CONVERT(date,' + @EndDate + ') as YrEndDate
	,CASE WHEN l.SourceValue IS NULL THEN 0 ELSE 1 END		as PlanMatchFlg
	,CASE WHEN plu.NPI IS NULL THEN 0 ELSE 1 END				as NPIMatchFlg
	,CASE WHEN CONVERT(date,p.' + @DataDate + ') = (SELECT MAX(' + @DataDate + ') FROM ' + @AdiMbrTable + ') THEN 1 ELSE 0 END as MaxDateFlg
	,1 as YrEndFlg
	,CONVERT(date,p.' + @DataDate + ') as LoadDate, ROW_NUMBER() OVER (PARTITION BY p.' + @ClientMemberKey + ', ' + @AttribNPI + ' ORDER BY p.' + @AdiKey + ' DESC) as rn
FROM ' + @AdiMbrTable + ' p 
LEFT JOIN ACDW_CLMS_AMGTX_MA.adi.[Amerigroup_MemberEligibility] c
		ON		p.DataDate				=	c.DataDate
		AND	p.MasterConsumerID	=	c.[MASTER_CONSUMER_ID]
		AND	p.PG_ID					=	c.PG_ID
LEFT JOIN lst.lstPlanMapping l ON p.' + @adiPlan + ' = l.SourceValue
LEFT JOIN (SELECT DISTINCT NPI,NPIHpEffectiveDate,NPIHpExpirationDate,TinHpEffectiveDate,TinHpExpirationDate 
	FROM ACECAREDW.adw.tvf_AllClient_ProviderRoster (' + @ClientKey + ',' + char(39) +  @MELoadDate + char(39) + ',1)) plu ON p.' +  @AttribNPI + '  = plu.NPI
	AND p.' + @DataDate + ' BETWEEN TinHpEffectiveDate	AND TinHpExpirationDate
	AND p.' + @DataDate + ' BETWEEN NPIHpEffectiveDate	AND NPIHpExpirationDate
WHERE p.' + @ClientMemberKey + ' IS NOT NULL 
	AND convert(date,p.' + @DataDate + ') = ' + char(39) + @MELoadDate + char(39) + '
	AND l.clientkey = ' + @ClientKey + '
	AND p.' + @DataDate + ' BETWEEN l.EffectiveDate AND l.ExpirationDate
	AND l.TargetSystem = ' + char(39) + 'ACDW' + char(39) + '
   AND c.' + @DataDate + '	BETWEEN c.EligibilityEffectiveDate AND c.EligibilityEndDate   
   AND p.' + @DataDate + ' BETWEEN p.EffectiveDate              AND p.TerminationDate
	AND c.PG_ID = ' + char(39) + 'TX000425' + char(39) + ' AND c.PRDCTSL = ' + char(39) + 'HMO' + char(39) + '
) m WHERE rn = 1
UPDATE ' + @TgtTblName + '
SET ActiveFlg = 0, RecStatus = '+ char(39) + 'U' + char(39) +', RecStatusDate = (sysdatetime()), UpdateRunID = ' + char(39) + @UpdateRunID + char(39) + ' ' + '
	FROM ' + @TgtTblName + ' m  
JOIN #tmpTable j
	ON		m.ClientMemberKey = j.ClientMemberKey
	AND	m.ClientKey			= j.ClientKey
	AND	m.EffDate			= j.EffDate
INSERT INTO ' + @TgtTblName + ' (EffectiveAsOfDate,CodeVer,adiKey,ClientMemberKey,ClientKey,AttribNPI, EffDate, TermDate, CurEffDate, LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg, RecStatus, MaxDateFlg, YEDateFlg, YEStartDate, YEEndDate)
SELECT ' + @RunDate + ',' + char(39) + @CodeVer + char(39) + ',p.adiKey, p.ClientMemberKey, p.ClientKey, p.AttribNPI, p.EffDate, p.TermDate, p.CurEffDate, convert(date,p.LoadDate), ' + char(39) +  @InsertRunID + char(39) + ',PlanMatchFlg,NPIMatchFlg,' + char(39) +  'N' + char(39) + ',p.MaxDateFlg, p.yrEndFlg, p.YrStartDate, p.YrEndDate  
FROM #tmpTable p
WHERE p.PlanMatchFlg = 1 AND NPIMatchFlg = 1
INSERT INTO ' + @TgtTblNameFailed + ' (EffectiveAsOfDate,CodeVer,adiKey,ClientMemberKey,ClientKey,AttribNPI, EffDate, TermDate, CurEffDate, LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg, RecStatus, MaxDateFlg, YEDateFlg, YEStartDate, YEEndDate)
SELECT ' + @RunDate + ',' + char(39) + @CodeVer + char(39) + ',p.adiKey, p.ClientMemberKey, p.ClientKey, p.AttribNPI, p.EffDate, p.TermDate, p.CurEffDate, convert(date,p.LoadDate), ' + char(39) +  @InsertRunID + char(39) + ',PlanMatchFlg,NPIMatchFlg,' + char(39) +  'N' + char(39) + ',p.MaxDateFlg, p.yrEndFlg, p.YrStartDate, p.YrEndDate  
FROM #tmpTable p
WHERE p.PlanMatchFlg = 0 OR NPIMatchFlg = 0
'

--PRINT @SQL
EXEC dbo.sp_executesql @SQL
SET @rTotal	+= @i
SET @i= @i + 1
END
/***
EXEC adw.z_CreateAMGMAMembers '2020-1-01','2021-05-31','2021-06-03'

SELECT * FROM dbo.z_tmp_AttribMembers			WHERE	ClientKey IN (21) AND EffectiveAsOfDate			= '2021-06-03'
SELECT * FROM dbo.z_tmp_AttribMembers_Failed WHERE	ClientKey IN (21)	AND EffectiveAsOfDate			= '2021-06-03'

SELECT * FROM ACECAREDW.adw.tvf_AllClient_ProviderRoster (21,'2021-04-01',1) WHERE NPI IN (
SELECT DISTINCT AttribNPI FROM dbo.z_tmp_AttribMembers_Failed WHERE	ClientKey IN (21)	AND EffectiveAsOfDate			= '2021-05-03')

***/




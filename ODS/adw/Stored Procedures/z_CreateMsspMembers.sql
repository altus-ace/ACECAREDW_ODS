CREATE PROCEDURE adw.z_CreateMsspMembers
(@YEStartDate		VARCHAR(20),
 @YEEndDate			VARCHAR(20),
 @EffectiveAsOfDate	VARCHAR(20)
)
AS

DECLARE @MELoadDateTable	TABLE(
	 URN					INT	IDENTITY NOT NULL
	,MELoadDate			DATE	 
	,NumOfRecs			INT)
INSERT INTO @MELoadDateTable
	(MELoadDate,NumOfRecs)
SELECT DISTINCT CONVERT(date,p.DataDate), COUNT(*) FROM dbo.z_tmp_AttribMembersMSSP  p 
--WHERE p.DataDate BETWEEN @YEStartDate AND @YEEndDate
GROUP BY CONVERT(date,p.DataDate) ORDER BY CONVERT(date,p.DataDate) 

--SELECT * FROM @MELoadDateTable
DECLARE @CodeVer				VARCHAR(5)	= '4'
DECLARE @SQL					NVARCHAR(4000)
DECLARE @i						INT			= 1
DECLARE @rTotal				BIGINT		= 0
DECLARE @RowCnt				BIGINT		= 0
DECLARE @TgtTblName			VARCHAR(50)	= 'dbo.z_tmp_AttribMembers'
DECLARE @TgtTblNameFailed	VARCHAR(50)	= 'dbo.z_tmp_AttribMembers_Failed'
DECLARE @AdiMbrTable			VARCHAR(60) = 'ACECAREDW.dbo.z_tmp_AttribMembersMSSP'
DECLARE @DataDate				VARCHAR(50) = 'DataDate'
DECLARE @ClientKey			VARCHAR(5)	= '16'
DECLARE @AdiKey				VARCHAR(50) = 'URN'
DECLARE @ClientMemberKey	VARCHAR(50) = 'ClientMemberKey'
DECLARE @AttribNPI			VARCHAR(50) = 'NPI'
DECLARE @EffDate				VARCHAR(50) = 'C_EffectiveDate'			-- Original Effective Date
DECLARE @CurEffDate			VARCHAR(50) = 'C_EffectiveDate'
DECLARE @TermDate				VARCHAR(50) = 'C_TerminateDate'
DECLARE @adiPlan				VARCHAR(50) = 'adiPlan'
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
SELECT p.' + @AdiKey + ' as AdiKey, CONVERT(VARCHAR(50),p.' + @ClientMemberKey + ') as ClientMemberKey, ' + @ClientKey + ' as ClientKey, p.' + @AttribNPI + ' as AttribNPI
	,CONVERT(date,' + @EffDate + ') as EffDate
	,CONVERT(date,' + @TermDate + ') as TermDate
	,CONVERT(date,' + @CurEffDate + ') as CurEffDate
	,CONVERT(date,' + @StartDate + ') as YrStartDate
	,CONVERT(date,' + @EndDate + ') as YrEndDate
	,1		as PlanMatchFlg
	,CASE WHEN plu.NPI IS NULL THEN 0 ELSE 1 END				as NPIMatchFlg
	,CASE WHEN CONVERT(date,p.' + @DataDate + ') = (SELECT MAX(' + @DataDate + ') FROM ' + @AdiMbrTable + ') THEN 1 ELSE 0 END as MaxDateFlg
	,1 as YrEndFlg
	,CONVERT(date,p.' + @DataDate + ') as LoadDate, ROW_NUMBER() OVER (PARTITION BY p.' + @ClientMemberKey + ' ORDER BY p.' + @AdiKey + ' DESC) as rn
FROM ' + @AdiMbrTable + ' p 
	--LEFT JOIN lst.lstPlanMapping l ON p.Line_of_Business = l.SourceValue
	LEFT JOIN (SELECT DISTINCT NPI,NPIHpEffectiveDate,NPIHpExpirationDate,TinHpEffectiveDate,TinHpExpirationDate 
		FROM ACECAREDW.adw.tvf_AllClient_ProviderRoster (' + @ClientKey + ',' + char(39) +  @MELoadDate + char(39) + ',1)) plu ON p.' +  @AttribNPI + '  = plu.NPI
	AND p.DataDate BETWEEN TinHpEffectiveDate	AND TinHpExpirationDate
	AND p.DataDate BETWEEN NPIHpEffectiveDate	AND NPIHpExpirationDate
WHERE p.' + @ClientMemberKey + ' IS NOT NULL 
	AND convert(date,p.' + @DataDate + ') = ' + char(39) + @MELoadDate + char(39) + '
) m WHERE rn = 1 
UPDATE ' + @TgtTblName + '
SET ActiveFlg = 0, RecStatus = '+ char(39) + 'U' + char(39) +', RecStatusDate = (sysdatetime()), UpdateRunID = ' + char(39) + @UpdateRunID + char(39) + ' ' + '
	FROM ' + @TgtTblName + ' m  
JOIN #tmpTable j
	ON		m.ClientMemberKey = j.ClientMemberKey
	AND	m.ClientKey			= j.ClientKey
	AND	m.EffDate			= j.EffDate
INSERT INTO ' + @TgtTblName + ' (EffectiveAsOfDate,CodeVer, adiKey,ClientMemberKey,ClientKey,AttribNPI, EffDate, TermDate, LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg, RecStatus, MaxDateFlg, YEDateFlg, YEStartDate, YEEndDate)
SELECT ' + @RunDate + ',' + char(39) + @CodeVer + char(39) + ',p.adiKey, p.ClientMemberKey, p.ClientKey, p.AttribNPI, p.EffDate, p.TermDate, convert(date,p.LoadDate), ' + char(39) +  @InsertRunID + char(39) + ',PlanMatchFlg,NPIMatchFlg,' + char(39) +  'N' + char(39) + ',p.MaxDateFlg, p.yrEndFlg, p.YrStartDate, p.YrEndDate  
FROM #tmpTable p
WHERE p.PlanMatchFlg = 1 AND NPIMatchFlg = 1
INSERT INTO ' + @TgtTblNameFailed + ' (EffectiveAsOfDate,CodeVer, adiKey,ClientMemberKey,ClientKey,AttribNPI, EffDate, TermDate, CurEffDate, LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg, RecStatus, MaxDateFlg, YEDateFlg, YEStartDate, YEEndDate)
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
EXEC adw.z_CreateMsspMembers '2020-01-01','2020-12-14','2021-06-03'

SELECT * FROM dbo.z_tmp_AttribMembers			WHERE	ClientKey IN (16) AND EffectiveAsOfDate			= '2021-06-03'
SELECT * FROM dbo.z_tmp_AttribMembers_Failed WHERE	ClientKey IN (16)	AND EffectiveAsOfDate			= '2021-06-03'

--select * from ACDW_CLMS_SHCN_MSSP.[adi].[Steward_MSSPAnnualmembership_HALRBASE]
--select * from ACDW_CLMS_SHCN_MSSP.[adi].[tmp_MemberListValidation]
--select * from ACDW_CLMS_SHCN_MSSP.[adi].[Steward_MSSPMembership_2021]
--CREATE TABLE dbo.z_tmp_AttribMembersMSSP (
--	 URN									INT IDENTITY
--	,DataDate							DATE
--	,EffectiveDate						DATE
--	,C_EffectiveDate					DATE
--	,C_TerminateDate					DATE
--	,MbrCnt								INT
--	,NPI									VARCHAR(50)
--	,ClientKey							INT
--	,ClientMemberKey					VARCHAR(50)
--	,DOD									VARCHAR(20)
--	,RwEffectiveDate					DATE
--	,RwExpirationDate					DATE
--	,Active								INT
--	,adiPlan								VARCHAR(5)
--	,CreateDate							DATE DEFAULT getdate()
--	,CreateBy							VARCHAR(50) DEFAULT suser_sname())	 

-- Get all transactions within time frame
--TRUNCATE TABLE dbo.z_tmp_AttribMembersMSSP
***/

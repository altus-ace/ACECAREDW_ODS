
/*** Aetna MA - Komal ***/
--SELECT * FROM (																																			-- Get the last record 
--	SELECT 																																					-- Details
--		 p.mbrAetMaTxKey																								as AdiKey					-- adi MemberKey
--		,p.MEMBER_ID																									as ClientMemberKey		-- 
--		,p.[Attribution_Original_Effective_Date]																		as MbrEffectiveDate		-- Member Effective Date.  
--		,[Attribution_Cancel_Date]																						as MbrTermDate				-- Member Term Date. Default if NULL  
--		,p.Attributed_Provider_NPI_Number																				as AttribNPI				-- must match the provider roster
--		,p.line_of_business																								as PlanCode					-- must match the plan mapping
--		,CONVERT(DATE,p.DataDate)																						as DataDate					-- Load Date of Recordset
--		,CONVERT(DATE,p.DataDate)																						as LoadDate					-- Load Date of Recordset
--		,CONVERT(DATE,p.CreatedDate) 																					as CreateDate				-- Create Date of Recordset
--		,CASE WHEN l.SourceValue IS NULL THEN 0 ELSE 1 END																as PlanMatchFlg			-- Match? 1=yes, 0=no
--		,CASE WHEN plu.AttribNPI IS NULL THEN 0 ELSE 1 END																as NPIMatchFlg				-- Match? 1=yes, 0=no
--		,DATEDIFF(mm,p.[Attribution_Original_Effective_Date],CAST(DATEADD(YEAR,DATEDIFF(YEAR, -1, p.[Attribution_Original_Effective_Date] ), -1) AS DATE))+1 as MbrMths	-- Calc, MbrMths for Load Year
--		,EffectiveMonth																									as LoadYYYYMM 				-- 
--		,ROW_NUMBER() OVER (PARTITION BY p.member_id, 2, p.DataDate ORDER BY p.mbrAetMaTxKey DESC)						as rn									-- Get the latest set
--	FROM ACECAREDW.[adi].[MbrAetMaTx] p 
--	LEFT JOIN lst.lstPlanMapping l ON p.Line_of_Business = l.SourceValue																			-- Plan Mapping
--	LEFT JOIN adw.tvf_GetFromProviderRoster (3) plu ON p.Attributed_Provider_Tax_ID_Number_TIN  = plu.AttribTIN														-- Provider Mapping
--	WHERE p.member_id IS NOT NULL 
--		AND YEAR(p.DataDate) >= 2020																													-- Membership after 2020
--		AND l.clientkey = 3																																-- Plan Filter	
--		AND p.DataDate BETWEEN l.EffectiveDate AND l.ExpirationDate																			-- Plan Filter																
--		AND p.DataDate BETWEEN plu.EffectiveDate AND plu.ExpirationDate																	-- Provider Filter
--		AND l.TargetSystem = 'ACDW'																													-- Plan Filter
--) n WHERE n.rn = 1
--and PlanMatchFlg = 1
--and NPIMatchFlg = 1
--and CreateDate = '2020-02-24'

--DROP TABLE dbo.z_tmp_AttribMembers
--CREATE TABLE dbo.z_tmp_AttribMembers (
--	 URN					INT	IDENTITY NOT NULL
--	,adiKey				INT
--	,ClientMemberKey	VARCHAR(50)
--	,ClientKey			INT
--	,AttribNPI			VARCHAR(20)
--	,EffDate				DATE
--	,TermDate			DATE
--	,CurEffDate			DATE
--	,LoadDate			DATE
--	,RecStatus			VARCHAR(1)
--	,RecStatusDate		DATE
--	,MaxDateFlg			INT
--	,ActiveFlg			INT DEFAULT 1
--	,PlanMatchFlg		INT
--	,NPIMatchFlg		INT
--	,InsertRunId		VARCHAR(10)
--	,UpdateRunId		VARCHAR(10)
--	,CreateDate			DATE DEFAULT getdate()
--	,CreateBy			VARCHAR(50) DEFAULT suser_sname())	 

CREATE PROCEDURE adw.z_CreateAetnaMAMembers
AS

DECLARE @MELoadDateTable	TABLE(
	 URN					INT	IDENTITY NOT NULL
	,MELoadDate			DATE	 
	,NumOfRecs			INT)
INSERT INTO @MELoadDateTable
	(MELoadDate,NumOfRecs)
SELECT DISTINCT CONVERT(date,p.DataDate), COUNT(*) FROM ACECAREDW.[adi].MbrAetCom p 
	JOIN lst.lstPlanMapping l ON p.line_of_business = l.SourceValue
	JOIN adw.tvf_AllClient_ProviderRoster_DevPR_ByClient (9) plu ON p.Attributed_Provider_NPI_Number  = plu.NPI
	--JOIN adw.tvf_AllClient_ProviderRoster_DevPR (9, getdate()) plu ON p.Attributed_Provider_NPI_Number  = plu.NPI --JOIN adw.tvf_GetFromProviderRoster (9, dataDate) plu ON p.Attributed_Provider_NPI_Number  = plu.AttribNPI
WHERE YEAR(p.DataDate) >= 2020 
	AND l.clientkey = 9
	AND DataDate BETWEEN l.EffectiveDate AND l.ExpirationDate
	AND DataDate BETWEEN TinHpEffectiveDate	AND TinHpExpirationDate
	AND DataDate BETWEEN NPIHpEffectiveDate	AND NPIHpExpirationDate
	--AND DataDate BETWEEN plu.EffectiveDate AND plu.ExpirationDate
	AND L.TargetSystem = 'ACDW'
GROUP BY CONVERT(date,p.DataDate) ORDER BY CONVERT(date,p.DataDate) 

--SELECT * FROM @MELoadDateTable
DECLARE @SQL					NVARCHAR(3000)
DECLARE @i						INT	= 1
DECLARE @rTotal				BIGINT = 0
DECLARE @RowCnt				BIGINT = 0
DECLARE @TgtTblName			VARCHAR(50)	= 'dbo.z_tmp_AttribMembers'
DECLARE @AdiMbrTable			VARCHAR(50) = 'ACECAREDW.adi.MbrAetMaTx'
DECLARE @DataDate				VARCHAR(50) = 'DataDate'
DECLARE @ClientKey			VARCHAR(5)	= '3'
DECLARE @AdiKey				VARCHAR(50) = 'mbrAetMaTxKey'
DECLARE @ClientMemberKey	VARCHAR(50) = 'MEMBER_ID'
DECLARE @AttribNPI			VARCHAR(50) = 'Attributed_Provider_NPI_Number'
DECLARE @EffDate				VARCHAR(50) = 'Attribution_Original_Effective_Date'			-- Original Effective Date
DECLARE @CurEffDate			VARCHAR(50) = 'Attribution_Original_Effective_Date'
DECLARE @TermDate				VARCHAR(50) = 'Attribution_Cancel_Date'
DECLARE @adiPlan				VARCHAR(50) = 'Line_of_Business'

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
	,CONVERT(date,p.' + @EffDate + ') as EffDate
	,CONVERT(date,p.' + @TermDate + ') as TermDate
	,CONVERT(date,p.' + @CurEffDate + ') as CurEffDate
	,CASE WHEN l.SourceValue IS NULL THEN 0 ELSE 1 END		as PlanMatchFlg
	,CASE WHEN plu.NPI IS NULL THEN 0 ELSE 1 END				as NPIMatchFlg
	,CASE WHEN CONVERT(date,p.' + @DataDate + ') = (SELECT MAX(' + @DataDate + ') FROM ' + @AdiMbrTable + ') THEN 1 ELSE 0 END as MaxDateFlg
	,CONVERT(date,p.' + @DataDate + ') as LoadDate, ROW_NUMBER() OVER (PARTITION BY p.' + @ClientMemberKey + ' ORDER BY p.' + @AdiKey + ' DESC) as rn
FROM ' + @AdiMbrTable + ' p 
	LEFT JOIN lst.lstPlanMapping l ON p.Line_of_Business = l.SourceValue
LEFT JOIN ACECAREDW.adw.tvf_AllClient_ProviderRoster_DevPR (' + @ClientKey + ',' + char(39) + '02-19-2021' + char(39) + ') plu ON p.' +  @AttribNPI + '  = plu.NPI
WHERE p.' + @ClientMemberKey + ' IS NOT NULL 
	AND convert(date,p.' + @DataDate + ') = ' + char(39) + @MELoadDate + char(39) + '
	AND l.clientkey = ' + @ClientKey + '
	AND p.' + @DataDate + ' BETWEEN l.EffectiveDate AND l.ExpirationDate
	AND L.TargetSystem = ' + char(39) + 'ACDW' + char(39) + '
	AND p.DataDate BETWEEN TinHpEffectiveDate	AND TinHpExpirationDate
	AND p.DataDate BETWEEN NPIHpEffectiveDate	AND NPIHpExpirationDate
) m WHERE rn = 1 
UPDATE ' + @TgtTblName + '
SET ActiveFlg = 0, RecStatus = '+ char(39) + 'U' + char(39) +', RecStatusDate = (sysdatetime()), UpdateRunID = ' + char(39) + @UpdateRunID + char(39) + ' ' + '
	FROM ' + @TgtTblName + ' m  
JOIN #tmpTable j
	ON		m.ClientMemberKey = j.ClientMemberKey
	AND	m.ClientKey			= j.ClientKey
	AND	m.EffDate			= j.EffDate
INSERT INTO ' + @TgtTblName + ' (adiKey,ClientMemberKey,ClientKey,AttribNPI, EffDate, TermDate, CurEffDate, LoadDate,InsertRunID,PlanMatchFlg,NPIMatchFlg, RecStatus, MaxDateFlg)
SELECT p.adiKey, p.ClientMemberKey, p.ClientKey, p.AttribNPI, p.EffDate, p.TermDate, p.CurEffDate, convert(date,p.LoadDate), ' + char(39) +  @InsertRunID + char(39) + ',PlanMatchFlg,NPIMatchFlg,' + char(39) +  'N' + char(39) + ',p.MaxDateFlg
FROM #tmpTable p
WHERE p.PlanMatchFlg = 1 AND NPIMatchFlg = 1
'

--PRINT @SQL
EXEC dbo.sp_executesql @SQL
SET @rTotal	+= @i
SET @i= @i + 1
END
/***
EXEC adw.z_CreateAetnaMAMembers

TRUNCATE TABLE dbo.z_tmp_AttribMembers
SELECT * FROM dbo.z_tmp_AttribMembers WHERE ClientKey = 3 ClientMemberKey = '00000018738415538225'  and ActiveFlg = 1
SELECT * FROM #tmpTbl where ClientMemberKey = '00000026512101804625' 
SELECT LoadDate, count(adiKey) as CntRec FROM dbo.z_tmp_AttribMembers WHERE ActiveFlg = 1 AND YEAR(EffDate) = 2020 GROUP BY LoadDate ORDER BY LoadDate
------------------
***/



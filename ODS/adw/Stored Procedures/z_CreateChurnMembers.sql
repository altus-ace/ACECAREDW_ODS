

CREATE PROCEDURE adw.z_CreateChurnMembers
--(@YEStartDate			VARCHAR(20),
-- @YEEndDate				VARCHAR(20),
-- @EffectiveAsOfDate	VARCHAR(20)
--)
AS



--SELECT * 
--FROM dbo.z_tmp_AttribMembers			
--WHERE	ClientKey IN (1) AND EffectiveAsOfDate		= '2021-07-02' 

DECLARE @EffectiveAsOfDate		DATE	= '2021-07-02'
DECLARE @EffDatesTable	TABLE(
	 URN					INT	IDENTITY NOT NULL
	,AttribDate			VARCHAR(10)	 
	,NumOfRecs			INT)
INSERT INTO @EffDatesTable
	(AttribDate,NumOfRecs)
SELECT DISTINCT EffYYYYMM, COUNT(*) 
FROM dbo.z_tmp_AttribMembers_FINAL p
WHERE	ClientKey IN (1) AND EffectiveAsOfDate		=   @EffectiveAsOfDate
GROUP BY EffYYYYMM ORDER BY EffYYYYMM

DECLARE @CodeVer				VARCHAR(5)	= '4'
DECLARE @SQL					NVARCHAR(4000)
DECLARE @i						INT			= 1
DECLARE @rTotal				BIGINT		= 0
DECLARE @RowCnt				BIGINT		= 0
DECLARE @TgtTblName			VARCHAR(50)	= 'dbo.z_tmp_ChurnMembers'
DECLARE @TgtTblNameFailed	VARCHAR(50)	= 'dbo.z_tmp_ChurnMembers_Failed'
DECLARE @AdiMbrTable			VARCHAR(50) = 'ACECAREDW.dbo.z_tmp_AttribMembers_FINAL'
--DECLARE @DataDate				VARCHAR(50) = 'A_LAST_UPDATE_DATE'
DECLARE @ClientKey			VARCHAR(5)	= '1'
--DECLARE @AdiKey				VARCHAR(50) = 'URN'
--DECLARE @ClientMemberKey	VARCHAR(50) = 'UHC_SUBSCRIBER_ID'
--DECLARE @AttribNPI			VARCHAR(50) = 'PCP_NPI'
--DECLARE @EffDate				VARCHAR(50) = 'MEMBER_ORG_EFF_DATE'			-- Original Effective Date   MEMBER_CONT_EFF_DATE
--DECLARE @CurEffDate			VARCHAR(50) = 'MEMBER_CUR_EFF_DATE'
--DECLARE @TermDate				VARCHAR(50) = 'MEMBER_CUR_TERM_DATE'
--DECLARE @adiPlan				VARCHAR(50) = 'SUBGRP_ID'
--DECLARE @StartDate			VARCHAR(20) = char(39) +@YEStartDate+ char(39)
--DECLARE @EndDate				VARCHAR(20) = char(39) +@YEEndDate+ char(39)
DECLARE @RunDate				VARCHAR(20) = @EffectiveAsOfDate

SELECT @RowCnt = count(0) FROM @EffDatesTable
WHILE @i <= @RowCnt
BEGIN
DECLARE @j						INT			= @i + 1
DECLARE @PrvAttribDate		VARCHAR(10)	= (SELECT AttribDate			FROM @EffDatesTable WHERE URN = @i)
DECLARE @CurAttribDate		VARCHAR(10)	= (SELECT AttribDate			FROM @EffDatesTable WHERE URN = @j)

SET NOCOUNT ON;
SET @SQL='
IF OBJECT_ID(N'+ char(39) + 'tempdb..#tmpTable' + char(39) + ') IS NOT NULL
DROP TABLE #tmpTable
SELECT ' + char(39) + @CurAttribDate + char(39) + ' as ChurnDate, ClientMemberKey INTO #tmpTable FROM (
	SELECT ClientMemberKey FROM ' + @AdiMbrTable + ' WHERE	ClientKey = ' + char(39) + '1'+ char(39) + ' AND EffectiveAsOfDate = ' + char(39) + '2021-07-02' + char(39) + '
		AND EffYYYYMM = ' + char(39) + @PrvAttribDate + char(39) + '
	EXCEPT
	SELECT ClientMemberKey FROM ' + @AdiMbrTable + ' WHERE	ClientKey = ' + char(39) + '1'+ char(39) + ' AND EffectiveAsOfDate = ' + char(39) + '2021-07-02' + char(39) + '
		AND EffYYYYMM = ' + char(39) + @CurAttribDate + char(39) + '
) m 
INSERT INTO ' + @TgtTblName + ' (ChurnDate, ClientMemberKey)
SELECT p.ChurnDate, p.ClientMemberKey FROM #tmpTable p 
'
--PRINT @SQL
EXEC dbo.sp_executesql @SQL

SET @rTotal	+= @i
SET @i= @i + 1
END
/***
EXEC adw.z_CreateChurnMembers

SELECT * FROM dbo.z_tmp_ChurnMembers
WHERE ChurnDate = '202002'
AND ClientMemberKey = '107337671'

SELECT ChurnDate, count(ClientmemberKey) as CntMbr FROM dbo.z_tmp_ChurnMembers GROUP BY ChurnDate ORDER BY ChurnDate

TRUNCATE TABLE dbo.z_tmp_ChurnMembers
***/


--SELECT DISTINCT EffYYYYMM
--FROM dbo.z_tmp_AttribMembers_FINAL
--WHERE	ClientKey IN (1) AND EffectiveAsOfDate		= '2021-07-02' 
--AND ClientMemberKey = '117503670'

--CREATE TABLE dbo.z_tmp_ChurnMembers (
--	 URN					INT	IDENTITY
--	,ChurnDate			VARCHAR(10)
--	,ClientMemberKey	VARCHAR(50)
--	,CreateDate			DATETIME DEFAULT	getdate()
--	,CreateBy			VARCHAR(50) DEFAULT (suser_sname()))


--IF OBJECT_ID(N'tempdb..#tmpTable') IS NOT NULL
--DROP TABLE #tmpTable
--SELECT '202002' as ChurnDate, ClientMemberKey INTO #tmpTable FROM (
--	SELECT ClientMemberKey FROM ACECAREDW.dbo.z_tmp_AttribMembers_FINAL WHERE	ClientKey = '1' AND EffectiveAsOfDate = '2021-07-02'
--		AND EffYYYYMM = '202001'
--	EXCEPT
--	SELECT ClientMemberKey FROM ACECAREDW.dbo.z_tmp_AttribMembers_FINAL WHERE	ClientKey = '1' AND EffectiveAsOfDate = '2021-07-02'
--		AND EffYYYYMM = '202002'
--) m 
--INSERT INTO dbo.z_tmp_ChurnMembers (ChurnDate, ClientMemberKey)
--SELECT p.ChurnDate, p.ClientMemberKey FROM #tmpTable p 



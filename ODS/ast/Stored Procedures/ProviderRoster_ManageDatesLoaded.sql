
CREATE PROCEDURE [ast].[ProviderRoster_ManageDatesLoaded]

AS

	---for old roster
   
	--STEP 1: START PROCESS : Process before start
	-- rename to expected name 
	EXEC sp_RENAME 'dbo.yy_vw_AllClient_ProviderRoster', 'vw_AllClient_ProviderRoster'  

	-- rename to trap name 
	EXEC sp_RENAME 'dbo.vw_AllClient_ProviderRoster', 'yy_vw_AllClient_ProviderRoster'

	

-- 1) Validate Counts
SELECT (SELECT COUNT(*) validateNewRoster FROM dbo.vw_AllClient_ProviderRoster_LoadFctSource) cntIncomingRoster
    , (SELECT count(*) validateCurrROster FROM dbo.vw_AllClient_ProviderRoster) cntCurrentLatestRoster;

-- 2) Load provider roster
if 1 = 2 
    begin
    -- load the ProviderRoster
    EXEC adw.p_LoadPdwFctProviderRosterFromView;
    END;

	--Check load
--- SELECT MAX(DATADATE) FROM adw.fctProviderRoster



/* every thing below here is a data main


/* Get load dates, and change if needed  */
SELECT pr.LoadDate
FROM adw.fctProviderRoster pr
GROUP BY pr.Loaddate 
ORDER BY pr.LoadDate desc

DECLARE @LoadDateToChange DATE;
    SELECT TOP 1 @LoadDateToChange = MAX(pr.LoadDate) -- added top 1 to make it get the max load date
	   FROM adw.fctProviderRoster pr
	   GROUP BY pr.Loaddate 
	   ORDER BY pr.LoadDate desc
SELECT @LoadDateToChange

DECLARE @NewLoadDate DATE = '2020-10-26' -- this should be a monday?

/*  select rows to see if value need updating */

SELECT DATEADD(day, -1, @NewLoadDate)AS New_RowExpirationDate,  pr.fctProviderRosterSkey, pr.SourceJobName, pr.LoadDate, pr.DataDate,pr.RowEffectiveDate, pr.RowExpirationDate
--  update PR set pr.RowExpirationDate =  DATEADD(day, -1, @NewLoadDate)
FROM adw.fctProviderRoster pr
/* use this filter when you start */
--WHERE Dateadd(day, -1, @LoadDateToChange) between pr.rowEffectiveDate and pr.rowExpirationDate
/* USe this filter when you check your results */
WHERE Dateadd(day, -1, @NewLoadDate) between pr.rowEffectiveDate and pr.rowExpirationDate

SELECT @NewLoadDate AS New_RowEffectiveDate,  pr.fctProviderRosterSkey, pr.SourceJobName, pr.LoadDate, pr.DataDate,pr.RowEffectiveDate, pr.RowExpirationDate
--  update pr set pr.loaddate = @NewLoadDate, pr.dataDate = @NewLoadDate, pr.RowEffectiveDate = @NewLoadDate
FROM adw.fctProviderRoster pr
/* use this filter when you start */
--where pr.LoadDate = @LoadDateToChange
/* USe this filter when you check your results */
WHERE Dateadd(day, -1, @LoadDateToChange) between pr.rowEffectiveDate and pr.rowExpirationDate




SELECT pr.rowEffectiveDate, pr.RowExpirationDate, min(loadDate) ld
FROM adw.fctproviderRoster pr
GROUP BY pr.rowEffectivedate, pr.RowExpirationDate
ORDER BY pr.RowEffectiveDate desc

SELECT *
FROM dbo.vw_AllClient_ProviderRoster pr

SELECT tin, GroupName, npi, count(*) cntServiceLines
FROM dbo.vw_AllClient_ProviderRoster pr
group by tin, GroupName, npi

/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
/* TO REMOVE A ROW *? */
/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */

/* to remove and reload a provider roster data set */

/* use this to get the dates to act on */
SELECT top 2 pr.RowEffectiveDate
FROm adw.fctProviderRoster pr
GROUP BY pr.RowEffectiveDate
ORDER BY pr.RowEffectiveDate desc

DECLARE @PriorRowEffectiveDate DATE = '2021-01-04';
DECLARE @ToRemoveEffectiveDate DATE = '2021-01-11';
Declare @Delete int = 1;

-- delete these rows 
IF @delete = 2435 
begin
    --SELECT count(*)
    DELETE pr
    FROm adw.fctProviderRoster pr
    WHERE @ToRemoveEffectiveDate between pr.RowEffectiveDate and pr.RowExpirationDate

    -- Set the rwExp date on these rows
    --SELECT count(*)
    UPDATE pr SET pr.RowExpirationDate = '12/31/2099'
    FROm adw.fctProviderRoster pr
    WHERE @PriorRowEffectiveDate between pr.RowEffectiveDate and pr.RowExpirationDate
END
-- delete these rows 
SELECT count(*)
FROm adw.fctProviderRoster pr
WHERE @ToRemoveEffectiveDate between pr.RowEffectiveDate and pr.RowExpirationDate

-- Set the rwExp date on these rows
SELECT count(*)
FROm adw.fctProviderRoster pr
WHERE @PriorRowEffectiveDate between pr.RowEffectiveDate and pr.RowExpirationDate



/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
/* END */
/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */

/*
DECLARE @d2 DATE = '2020-06-03'
SELECT fctProviderRosterSkey, pr.RowEffectiveDate, pr.RowExpirationDate, pr.LoadDate, '05/31/2020' newExD
--update pr set RowEffectiveDate = pr.LoadDate--, pr.RowExpirationDate = '05/31/2020'
FROM adw.fctProviderRoster pr
WHERE pr.RowEffectiveDate = @d2
--Need adi tables for all for all of these
-- requirements:
--table, with metadata for each table? or only the tables we export?
*/
/* 

How do we load this fact, load to tmp staging table.
    --    we shoul build as boomi job to formalize (Y)
   first, get files in staging folder.
   Then load to tmp tables with SSIS etl job.
   Then load to adw fact with adw SP
   Then if correct date, load to shcn mssp

1. BA downloads table dump from SF. Can only be done ever 3 days.
2.run the import package job: 
    Project ACE-ITS-DT01 Integration
    Job:AA_Master_ImpTsfToACDW.dstx
3. Load to fct with [adw].[Load_Pdw_FctProviderRosterFromView]

*/

--if ready.
-- Exec [adw].[Load_Pdw_FctProviderRosterFromView];


*/
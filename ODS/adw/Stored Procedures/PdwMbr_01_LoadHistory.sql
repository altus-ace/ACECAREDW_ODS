CREATE PROCEDURE [adw].[PdwMbr_01_LoadHistory]
    @loadDate DATE ,
    @loadType CHAR(1),
    @ClientKey INT,
    @InsertCount INT OUTPUT
AS
    /* Purpose: Load rows being loaded into load history
	   This History row is specific to this load batch 
	   Meaning if you re run this you get a new row set for each staging row.
	   */

    DECLARE @OutputTbl TABLE (ID INT);

    INSERT INTO [adw].[MbrLoadHistory]
           (AdiTableName,AdiKey		 
           ,[LoadDate],[DataDate],LoadType
           )     
    OUTPUT inserted.mbrLoadHistoryKey INTO @OutputTbl(ID)
    SELECT m.AdiTableName,m.AdiKey
	   , m.loadDate, m.DataDate, @loadType    	   
    FROM ast.MbrStg2_MbrData m
    /*    LEFT JOIN adw.MbrLoadHistory lh ON m.AdiKey = lh.AdiKey
		  AND m.AdiTableName = lh.AdiTableName
		  */
    --WHERE lh.mbrLoadHistoryKey is null
    WHERE m.stgRowStatus = 'Valid'
	   AND m.LoadDate = @LoadDate
	   AND m.CLientKey = @ClientKey;

    SELECT @InsertCount  = COUNT(*) 
    FROM @OutputTbl o;
    RETURN;

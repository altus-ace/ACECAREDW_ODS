
CREATE PROCEDURE ast.AceValidate_GetStagingInProcessCounts
AS 
    /* purpose: get data for checking count of records by SubSetName 
	   TotalStagedMembers = StagedNewMembers + StagedExistingMembers + StagedTermMembers
	   */
    
    SELECT s.LoadDate, s.ClientKey, s.stgRowStatus, COUNT(*) CNT, 'TotalStagedMembers' SubSetName
    FROM ast.MbrStg2_MbrData s
    where s.stgRowStatus IN ('Loaded', 'Valid')
    GROUP BY s.ClientKey, s.stgRowStatus, s.LoadDate
    UNION
    SELECT s.LoadDate, s.ClientKey, s.stgRowStatus, COUNT(*) CNT, 'StagedNewMembers' SubSetName
    FROM ast.MbrStg2_MbrData s
    where s.stgRowStatus = 'Loaded'
        and mbrmemberkey is null
    GROUP BY s.ClientKey, s.stgRowStatus, s.LoadDate
    UNION    
    SELECT s.LoadDate, s.ClientKey, s.stgRowStatus, COUNT(*) CNT,  'StagedExistingMembers' SubSetName
    FROM ast.MbrStg2_MbrData s
    where s.stgRowStatus = 'Loaded'
        and NOT mbrmemberkey is null AND NOT s.mbrLastName is null
    GROUP BY s.ClientKey, s.stgRowStatus, s.LoadDate
    UNION
    SELECT s.LoadDate, s.ClientKey, s.stgRowStatus, COUNT(*) CNT, 'StagedTermMembers' SubSetName
    FROM ast.MbrStg2_MbrData s
    where s.stgRowStatus = 'Loaded'
        and (NOT mbrmemberkey is null AND NOT s.MbrPcpKey is null )
    GROUP BY s.ClientKey, s.stgRowStatus, s.LoadDate;

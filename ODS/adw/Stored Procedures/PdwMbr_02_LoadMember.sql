CREATE PROCEDURE [adw].[PdwMbr_02_LoadMember]
	@loadDate DATE ,
	@ClientKey INT,
	@InsertCount INT OUTPUT
AS
   /* Purpose: Create MbrMember row for every row that doesn't already exist.
		  Already exists means has same clientkey and ClientMemberKey 
		  */
   DECLARE @OutputTbl TABLE (ID INT);	

   INSERT INTO [adw].[MbrMember]
           ([ClientMemberKey]
           ,[ClientKey]
           ,[MstrMrnKey]
           ,[mbrLoadKey]
           ,[LoadDate]
           ,[DataDate]
	   )
    OUTPUT inserted.MbrMemberKey INTO @OutputTbl(ID)
    SELECT m.ClientSubscriberId
        , m.ClientKey 
	   , m.MstrMrnKey
        , lh.mbrLoadHistoryKey
        , m.LoadDate
        , m.DataDate        	   
    FROM ast.MbrStg2_MbrData m
	   JOIN adw.MbrLoadHistory lh ON m.AdiKey = lh.adiKey
		  AND m.AdiTableName = lh.AdiTableName
	   LEFT JOIN adw.MbrMember mbr ON m.ClientSubscriberId = mbr.ClientMemberKey        
	   --JOIN adw.MstrMrn mrn ON m.AdiKey = mrn.srcUrn AND mrn.srcTableName = m.AdiTableName					   
    WHERE mbr.MbrMemberKey is null /* is new member */
	   and m.ClientKey = @CLientKey
	   AND m.LoadDate = @LoadDate
	   AND m.StgRowStatus = 'Valid'
	   ;
    SELECT @InsertCount = COUNT(*)
    FROM @OutputTbl ;
    
    RETURN;

    /*PRior version: for AETMA
	   SELECT m.ClientSubscriberId
        , c.ClientKey 
	   , mrn.MstrMrnKey         
        , lh.mbrLoadHistoryKey
        , CONVERT(DATE, GETDATE()) AS LoadDate
        , m.DataDate        	   
    FROM ast.MbrStg2_MbrData m
        JOIN adw.MbrLoadHistory lh ON m.AdiKey = lh.adiKey
		  AND m.AdiTableName = lh.AdiTableName
	   LEFT JOIN adw.MbrMember mbr ON m.ClientSubscriberId = mbr.ClientMemberKey
        JOIN (SELECT * FROM lst.List_Client ) c ON m.ClientKey = c.ClientKey        
	   JOIN adw.MstrMrn mrn ON m.AdiKey = mrn.srcUrn
    					   AND mrn.srcTableName = m.AdiTableName					   
    WHERE mbr.MbrMemberKey is null;
    */

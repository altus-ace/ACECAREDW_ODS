
CREATE PROCEDURE ast.PstUhcUpdateDboMemberStatus 
AS 

/* build temp storage for calculating availablity */
/*
IF 1 = 2 
BEGIN
	/* do not run this, this is the code for the log table, it is here because I have not created a model yet: GK */
	CREATE TABLE sysLog_MemberStatusSummaryByETL_Import
		(id INT PRIMARY KEY IDENTITY(1,1) 
			, tableName VARCHAR(100)
			, ExistingCnt INT
			, NewCnt INT
			, TermedCnt INT
			, ETL_batchDateTIME DATETIME2(3)
			, CREATED_BY VARCHAR(20)
			);
END;

*/
BEGIN 
    if object_id('tempdb..#newOld') is not null 
    	drop table tempdb..#newOld;
    
    if object_id('tempdb..#MemStatusUpdates') is not null 
    	drop table tempdb..#MemStatusUpdates;
	CREATE table #newOld 
	   (id INT IDENTITY(1,1) PRIMARY KEY, 
	   	MemberID INT,  		
	   	OldURN INT,
	   	NewURN INT, 
	   	aStatus CHAR(1)
	   	);
	   
    CREATE TABLE #MemStatusUpdates
	   (memID INT 
	   	, NewStatus nchar(1)
	   	, NewTermDate datetime
	   	, ActionTaken nvarchar(10)     
	   );  
END

BEGIN
/* Load NEW FILE Set records AND Immediate previous set of records: 
    So we have records for all New, Existing and Termed members 
    related to this file event*/
INSERT INTO #newOld (MemberID)
SELECT DISTINCT mp.UHC_SUBSCRIBER_ID
FROM dbo.UHC_MembersByPCP mp
WHERE mp.A_LAST_UPDATE_FLAG = 'Y' OR mp.A_LAST_UPDATE_FLAG = 'L' ;



/* Merge in details about New records for member 
    These are  Existing  and New Records.*/
MERGE #NewOLD AS trgt
USING (SELECT mp.UHC_SUBSCRIBER_ID
				, mp.URN				
				FROM dbo.UHC_MembersByPCP mp
				WHERE mp.A_LAST_UPDATE_FLAG = 'Y'
				) as SRC (MemberID, NewURN)			
ON (trgt.MemberID = SRC.MemberID)
WHEN MATCHED THEN 
	UPDATE SET trgt.NewUrn = SRC.NewURN
		;
	
/* Merge in detail about old records, the immediately prior record for the member 
    These are Existing and Termed members */
MERGE #NewOLD AS trgt
USING (SELECT mp.UHC_SUBSCRIBER_ID 
			 , mp.URN				
		  FROM dbo.UHC_MembersByPCP mp
		  WHERE mp.A_LAST_UPDATE_FLAG = 'L'
		) AS SRC (MemberID, OldUrn)			
ON (trgt.MemberID = SRC.MemberID)
WHEN MATCHED THEN 
	UPDATE SET trgt.OldURN = SRC.OldUrn
		;

/* if a member has:
    E: Old URN and New Urn they are an existing record, They were active on the previous file and the new file
    N: New Urn and a null Old URN: They are a new member in the perspective of these two files
    T: Old URN and a null New URN: The are a termed member. 
   */

/* ASSIGN EXISTING  */
MERGE #NewOld AS trgt
USING (SELECT no.MemberID, 'E' as updateStatus
		FROM #newOld no
		WHERE (NOT no.OldUrn IS NULL) AND (NOT no.NewUrn IS NULL)
		) AS SRC (aMemID, aStatus)
ON (trgt.MemberID = SRC.aMemID)
WHEN MATCHED THEN 
	UPDATE SET trgt.aStatus = SRC.aStatus
	;

/* Update the termed records */
MERGE #NewOld AS trgt
USING (SELECT no.MemberID, 'T' as updateStatus
		FROM #newOld no
		WHERE (NOT no.OldUrn IS NULL) AND (no.NewUrn IS NULL)
		) AS SRC (aMemID, aStatus)
ON (trgt.MEMBERID = SRC.aMemID)
WHEN MATCHED THEN 
	UPDATE SET trgt.aStatus = SRC.aStatus
	;

/* update the New records */
MERGE #newOld AS trgt
USING (SELECT no.MemberID, 'N' as updateStatus
		FROM #newOld no
		WHERE (no.OldUrn IS NULL) AND (NOT no.NewUrn IS NULL)
		) AS SRC (aMemID, aStatus)
ON (trgt.MemberID = SRC.aMemID)
WHEN MATCHED THEN 
	UPDATE SET trgt.aStatus = SRC.aStatus
;


/* 11/22/2017: 
    GK: changed date processing to term to the end of the load month, 
		  instead of the end of the prior month as done before.
    capture the update date and term date for this process 
	   ** Update is load date.
	   ** Termdate is the last day  load month 
	   */
DECLARE @mUpdateDate DATE;
DECLARE @TermDate DATE;

SELECT @mUpdateDate = MAX(mp.A_LAST_UPDATE_DATE)  
    FROM dbo.UHC_MembersByPCP mp
    WHERE mp.A_LAST_UPDATE_FLAG = 'Y';
SELECT @TermDate = DATEADD(month,1, DATEADD(DAY,-(Day(@mUpdateDate) ), @mUpdateDate)) ;


/* Merge the changes back to MemberByPCP: For existing with E */
MERGE dbo.UHC_MembersByPCP  AS trgt
USING (SELECT no.MemberID, no.aStatus as updateStatus
		FROM #newOld no
		WHERE aStatus = 'E'
		) AS SRC (aMemID, aStatus)
ON (trgt.UHC_SUBSCRIBER_ID = SRC.aMemID)
WHEN MATCHED THEN 
	UPDATE SET trgt.MEMBER_STATUS = SRC.aStatus	
    ;

/* Merge the changes back to MemberByPCP: the Termed Members */
MERGE dbo.UHC_MembersByPCP  AS trgt
USING (SELECT no.MemberID, no.aStatus as updateStatus
		FROM #newOld no
		WHERE aStatus = 'T'
		) AS SRC (aMemID, aStatus)
ON (trgt.UHC_SUBSCRIBER_ID = SRC.aMemID)
WHEN MATCHED THEN 
	UPDATE SET trgt.MEMBER_STATUS = SRC.aStatus
			, trgt.MEMBER_TERM_DATE = @TermDate
    ;
/* Merge the changes back to MemberByPCP: the New Members */
MERGE dbo.UHC_MembersByPCP  AS trgt
USING (SELECT no.MemberID, no.aStatus as updateStatus
		FROM #newOld no
		WHERE aStatus = 'N'
		) AS SRC (aMemID, aStatus)
ON (trgt.UHC_SUBSCRIBER_ID = SRC.aMemID)
WHEN MATCHED THEN 
	UPDATE SET trgt.MEMBER_STATUS = SRC.aStatus
;



/* Create the log values */
DECLARE @e INT, @n INT ,@t INT;
    SELECT @e = SUM(1) FROM #newOld e WHERE e.aStatus = 'E';
    SELECT @n = SUM(1) FROM #newOld n WHERE n.aStatus = 'N';
    SELECT @t = SUM(1) FROM #newOld t WHERE t.aStatus = 'T';
DECLARE @etlBatchDateTime DATETIME = GETDATE();

/* insert the output summary into the logging table */
INSERT INTO dbo.sysLog_MemberStatusSummaryByETL_Import(tableName, ExistingCnt, NewCnt,TermedCnt, ETL_batchDateTIME, CREATED_BY)
VALUES( 'dbo.UHC_MembersByPCP' , @e, @n, @t, @etlBatchDateTime, ORIGINAL_LOGIN());


/* Select out the logging results */
SELECT TOP 6
    [id]
      ,[tableName] AS entityUpdated
      ,[ExistingCnt] 
      ,[NewCnt]
      ,[TermedCnt]
      ,[ETL_batchDateTIME] updateDateTime
      ,[CREATED_BY] updateUser
	  , ExistingCnt + NewCnt AS ActiveCnt
  FROM [dbo].[sysLog_MemberStatusSummaryByETL_Import]
  ORDER BY etl_batchDateTime desc

END;  


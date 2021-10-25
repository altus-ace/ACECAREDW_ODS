CREATE PROCEDURE ast.PdwCreateExportProgram_WC15Uhc
    @LoadDate date
AS
BEGIN
    --DECLARE @LoadDate DATE = '12/18/2020'; -- what month process are we loading  Newly enrolled for
    DECLARE @ProgramID INT; 
    DECLARE @ProgramName VARCHAR(50);
    DECLARE @EnrollDate DATE = DATEFROMPARTS(YEAR(@LoadDate), Month(@loadDate), 1);
    --DEClare @EndDate DATE = DATEADD(Months, 15, @EnrollDate); must be calculated relevant to the members 15th month birthday
    DECLARE @OrigMemberDateForNewMembers date = DATEADD(month, -1, @EnrollDate );

    
    DECLARE @OutputTbl TABLE (ID INT);	       
    DECLARE @ClientKey INT	 = 1  ;
    /* Log Stag Load */    
    DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8   -- 8 dw load?        
    DECLARE @JobName VARCHAR(200);
	   SELECT @JobName = OBJECT_NAME(@@PROCID); 
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = DB_NAME() + '.dbo.vw_Uhc_ActiveMembers'	    
    DECLARE @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	   SELECT @DestinationName = DB_NAME() + '.adw.ExportAhsPrograms';    
    DECLARE @ErrorName VARCHAR(200) = 'No Error Name Provided'	
    	
    EXEC AceMetaData.amd.sp_AceEtlAudit_Open 
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @AuditStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStartTime
        , @InputSourceName = @InputSourceName
        , @DestinationName = @DestinationName
        , @ErrorName = @ErrorName
    
    /* this should be a validation: if there is not a record match fail out*/
    SELECT @ProgramID =  cp.lstAhsProgramsKey, @ProgramName =  cp.ProgramName
    --SELECT cp.lstAhsProgramsKey, cp.ProgramName
    FROM lst.lstClinicalPrograms cp
    where cp.ProgramName = 'C-Well Child visit first 15 months';
    --    SELECT  @ProgramID, @ProgramName, @LoadDate, @OrigMemberDateForNewMembers, @EnrollDate

     /* insert into */
    INSERT INTO adw.ExportAhsPrograms (LoadDate, ClientKey,ClientMemberKey, ProgramID, ExpLobName	  
		  ,ExpProgram_Name, ExpEnrollDate, ExpCreateDate, ExpMemberID
		  , ExpEnrollEndDate, ExpProgramstatus, ExpReasonDescription
		  , ExpReferalType    
		  )
    OUTPUT inserted.ExportAhsProgramsKey INTO @OutputTbl(ID)     
    SELECT @LoadDate AS LoadDate, Client.ClientKey, mbr.Uhc_subscriber_Id , @ProgramID, client.CS_Export_LobName
	   , @ProgramName as ExpProgram_Name, @EnrollDate as ExpEnrollDate,  @EnrollDate as ExpCreateDate, Mbr.UHC_SUBSCRIBER_ID AS ExpMemberID
	   , DATEADD(month, 15, mbr.DATE_OF_BIRTH) as ExpEnrollEndDate, 'ACTIVE' as ExpProgramstatus, 'Enrolled in a Program' as ExpReasonDescription
		, 'External' as ExpReferalType
    FROM --dbo.Uhc_MembersByPcp mbr
	   dbo.vw_UHC_ActiveMembers mbr
	   JOIN lst.List_Client Client on 1 = Client.ClientKey
    WHERE  mbr.MEMBER_ORG_EFF_DATE = @OrigMemberDateForNewMembers
	   AND mbr.CurMonthsOld <15;
	   
     /* close load Staging Log record */    
    DECLARE @ActionStopTime DATETIME = getdate()
    DECLARE @SourceCount int; --= 25
	   SELECT @SourceCount = COUNT(ID) FROM @OutputTbl;
    DECLARE @DestinationCount int; -- = 23
	   SELECT @SourceCount = COUNT(ID) FROM @OutputTbl;
    DECLARE @ErrorCount int = 0
    DECLARE @JobStatus tinyInt = 2

    EXEC AceMetaData.amd.sp_AceEtlAudit_Close 
        @AuditId = @AuditID
        , @ActionStopTime = @ActionStopTime
        , @SourceCount = @SourceCount		  
        , @DestinationCount = @DestinationCount
        , @ErrorCount = @ErrorCount
        , @JobStatus = @JobStatus
	   ;
END

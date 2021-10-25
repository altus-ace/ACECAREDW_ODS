
CREATE PROCEDURE [ast].[PdwCreateExportProgram_FromAceList]
    @LoadDate date    , @ProgramName VARCHAR(50), @ClientKey INT 
AS
/* IF a program is loaded into the adi.AceProgramName table
    THis sp will c opy it from there to the ADW.ExportAHsProgram Table 
    ANd then it can be exported using the Ace Exports: Ah-Exp-PE-Programs ssis package.
    WHEN Done Update the status flag and exported flag
    */


BEGIN
    --DECLARE @LoadDate DATE = '12/18/2020'; -- what month process are we loading  Newly enrolled for
    IF @LoadDate = null 
	   SET @LoadDate = GETDATE();
    DECLARE @ProgramID INT = -1;     
        
    DECLARE @OutputTbl TABLE (ID INT);	           
    /* Log Stag Load */    
    DECLARE @AuditID INT 
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8   -- 8 dw load?        
    DECLARE @JobName VARCHAR(200);
	   SELECT @JobName = OBJECT_NAME(@@PROCID); 
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = DB_NAME() + '.adi.AceProgramnName'	    
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
    SELECT @ProgramID =  cp.lstAhsProgramsKey    
    FROM lst.lstClinicalPrograms cp
    where cp.ProgramName = @ProgramName
    ;
    
    IF @ProgramID = -1  -- initial value, means program not found in clinicalPrograms list table
	   BEGIN
	   SELECT 'Configure the ad hoc program to the lst.LstClincalPrograms table, before proceding. ';
	   RETURN;
	   END
    /* exception, etc */
    --SELECT  @ProgramID, @ProgramName, @LoadDate, @OrigMemberDateForNewMembers, @EndDate, @EnrollDate

    /* insert into */
    INSERT INTO adw.ExportAhsPrograms (LoadDate, ClientKey,ClientMemberKey, ProgramID, ExpLobName	  
		  ,ExpProgram_Name, ExpEnrollDate, ExpCreateDate, ExpMemberID
		  , ExpEnrollEndDate, ExpProgramstatus, ExpReasonDescription
		  , ExpReferalType    
		  )
    OUTPUT inserted.ExportAhsProgramsKey INTO @OutputTbl(ID)     
    -- declare @loaddate 
    SELECT @LoadDate LoadDate, Client.ClientKey , Prog.MemberID , @ProgramID AS ProgramID, PROG.LOB
	   	, Prog.Program as ExpProgram_Name, prog.StartDate as ExpEnrollDate, prog.StartDate as ExpCreateDate, Prog.MemberID AS ExpMemberID
		, Prog.EndDate as ExpEnrollEndDate, 'ACTIVE' as ExpProgramstatus, 'Enrolled in a Program' as ExpReasonDescription
		, 'External' as ExpReferalType		    
    --SELECT prog.*, Client.ClientKey, clinProg.lstAhsProgramsKey
    FROM adi.ACEProgramName Prog
	   JOIN lst.List_Client Client on  prog.LOB = Client.CS_Export_LobName
	   LEFT   JOIN lst.lstClinicalPrograms ClinProg ON prog.Program = ClinProg.ProgramName
    where Prog.AceStatusCode = 0
	   and Client.ClientKey = @ClientKey
	   and ClinProg.lstAhsProgramsKey = @ProgramID;

    
    UPDATE p set p.AceStatusCode = 1
    FROM adi.ACEProgramName p	   
	   JOIN lst.List_Client c ON p.LOB = c.CS_Export_LobName
    WHERE p.AceStatusCode = 0
	   AND c.ClientKey = @CLientKey
	   AND p.Program = @ProgramName;

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

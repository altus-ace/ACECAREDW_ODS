
CREATE PROCEDURE [ast].[PdwCreateExportProgram_Imm_0913_Adol_Uhc]
    @LoadDate date    
AS

--  4.3.4.1.	This measure should be derived from MEMBERSHIP FILE for 
--    the members/Children with 9 to 13 years of age should be enrolled into the program 
--  4.3.4.2.	Enroll date should be 9th Birthday and 
--			 TermDate should be when they turn 13 years (Or members 13th Birthday Date) from the the BirthDate.
-- Immunizations for Adolescents MY 2020
BEGIN
    Declare @ProgNameFromBrd varchar(50)  = 'C- Immunizations for Adolescents';
    --DECLARE @LoadDate DATE = '06/18/2021'; -- what month process are we loading  Newly enrolled for    
    DECLARE @ProgramID INT; 
    DECLARE @ProgramName VARCHAR(50);
    DECLARE @EnrollDate DATE = DATEFROMPARTS(YEAR(@LoadDate), Month(@loadDate), 1);
    DEClare @EndDate DATE = DATEADD(day, 90, @EnrollDate);
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
    FROM lst.lstClinicalPrograms cp
    where cp.ProgramName = @ProgNameFromBrd;
    
    /* exception, etc */
    SELECT  @ProgramID, @ProgramName, @LoadDate, @OrigMemberDateForNewMembers, @EndDate, @EnrollDate

    /* create working table */    
    IF OBJECT_ID(N'ast.MbrCreateExportProgramImmAdol', 'U') IS NOT NULL  
       drop table ast.MbrCreateExportProgramImmAdol;
    CREATE TABLE [ast].[MbrCreateExportProgramImmAdol](
        SKey int not null identity(1,1) Primary Key,
	   [DateOfBirth] [date] NOT NULL,
	   [NinthBday] [date] NOT NULL,
	   [ThirteenthBday] [date] NOT NULL,
	   [FirstDayMonth] [date] nOT NULL,
	   [LoadDate] [date] NOT NULL,
	   [ClientKey] [int] NOT NULL,
	   [ClientMemberKey] [varchar](50) NOT NULL,
	   [ProgramID] [INT] NULL,
	   [CsExportLobName] [varchar](20) NOT NULL,
	   [ExpProgramName] [varchar](40) NULL,
	   [ExpEnrollDate] [date] NULL,
	   [ExpCreateDate] [date] NULL,
	   [ExpMemberID] [varchar](255) NULL,
	   [ExpEnrollEndDate] [date] NULL,
	   [ExpProgramStatus] [varchar](6) NOT NULL,
	   [ExpReasonDescription] [varchar](21) NOT NULL,
	   [ExpReferalType] [varchar](8) NOT NULL
    ) ON [PRIMARY]

    /* Load Working table */
    DECLARE @NineYearsOld   date = DateADD(Year, -1*9 , @LoadDate);
    DeClare @ThirteenYearsOld date = DateADD(Year, -1*13, @LoadDate);
    -- SELECT @LoadDate, @NineYearsOld, @ThirteenYearsOld
    /* get members in age range*/
    BEGIN
        INSERT INTO [ast].[MbrCreateExportProgramImmAdol](DateOfBirth, NinthBday, ThirteenthBday, FirstDayMonth
	   	   , LoadDate, clientKey, ClientMemberKey, ProgramID, CsExportLobName, ExpProgramName, ExpEnrollDate, ExpCreateDate
	   	   , ExpMemberID, ExpEnrollEndDate, ExpProgramStatus, ExpReasonDescription, ExpReferalType)
        SELECT mbr.DATE_OF_BIRTH, DateADD(Year, 9 , mbr.date_Of_Birth) as NthBday, DateADD(Year, 13, mbr.date_Of_Birth) AS ThirteenthBday
            , DATEAdd(DAY, (-1*DAY(@LoadDate)+1), @LoadDate ) FirstDayMonth
    		  , @LoadDate LoadDate, Client.ClientKey , Mbr.CLIENT_SUBSCRIBER_ID , @ProgramID AS ProgramID, client.CS_Export_LobName
    		  , @ProgramName as ExpProgram_Name, @LoadDate as ExpEnrollDate, @LoadDate as ExpCreateDate, Mbr.CLIENT_SUBSCRIBER_ID AS ExpMemberID
    		  , @LoadDate as ExpEnrollEndDate, 'ACTIVE' as ExpProgramstatus, 'Enrolled in a Program' as ExpReasonDescription
    		  , 'External' as ExpReferalType		
        FROM dbo.vw_ActiveMembers mbr
    		  JOIN lst.List_Client Client on mbr.clientKey = Client.ClientKey
        WHERE mbr.clientKey = 1
    		  AND mbr.DATE_OF_BIRTH between @ThirteenYearsOld  and @NineYearsOld 
	   ;    
    END
    /* --2. update dates
	   --ExpEnroll = > of NinthBday and Firstday of month 
	   --ExpEnrollEndDate = thirteenthBday
	   */
    BEGIN 
	   UPDATE e SET e.ExpEnrollDate = 	   
		  CASE WHEN (e.NinthBday > e.FirstDayMonth) THEN e.NinthBday 
			 ELSE e.FirstDayMonth END 
		  , e.ExpEnrollEndDate =  e.ThirteenthBday 
	   FROM ast.MbrCreateExportProgramImmAdol e
	   ;
    END;

    /* insert into */
    INSERT INTO adw.ExportAhsPrograms (LoadDate, ClientKey,ClientMemberKey, ProgramID, ExpLobName	  
		  ,ExpProgram_Name, ExpEnrollDate, ExpCreateDate, ExpMemberID
		  , ExpEnrollEndDate, ExpProgramstatus, ExpReasonDescription
		  , ExpReferalType    
		  )
    OUTPUT inserted.ExportAhsProgramsKey INTO @OutputTbl(ID)     
    SELECT src.LoadDate LoadDate, Client.ClientKey , src.ClientMemberKey , src.ProgramID AS ProgramID, client.CS_Export_LobName
	   	, src.ExpProgramName as ExpProgram_Name, src.ExpEnrollDate as ExpEnrollDate, src.ExpCreateDate as ExpCreateDate, src.ClientMemberKey AS ExpMemberID
		, src.ExpEnrollEndDate as ExpEnrollEndDate, 'ACTIVE' as ExpProgramstatus, 'Enrolled in a Program' as ExpReasonDescription
		, 'External' as ExpReferalType		    
    FROM ast.MbrCreateExportProgramImmAdol src
	   JOIN lst.List_Client Client ON @ClientKey = Client.ClientKey
	   LEFT JOIN adw.ExportAhsPrograms p
		  ON src.ClientMemberKey = p.ClientMemberKey
			 and src.ProgramID = p.ProgramID
			 and (src.ExpEnrollDate between p.ExpEnrollDate and p.ExpEnrollEndDate
				OR src.ExpEnrollEndDate between p.ExpEnrollDate and p.ExpEnrollEndDate)

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
--
END;

CREATE PROCEDURE [ast].[PdwCreateExportProgram_PreNatalUhc]
    @LoadDate date
AS
BEGIN
    --DECLARE @LoadDate DATE = '12/18/2020'; -- what month process are we loading  Newly enrolled for
    DECLARE @ClientKey INT = 1;
    DECLARE @ProgramID INT; 
    DECLARE @ProgramName VARCHAR(50);
    DECLARE @EnrollDate DATE = DATEFROMPARTS(YEAR(@LoadDate), Month(@loadDate), 1);
    --DEClare @EndDate DATE = DATEADD(Months, 15, @EnrollDate); must be calculated relevant to the members 15th month birthday
    DECLARE @OrigMemberDateForNewMembers date = DATEADD(month, -1, @EnrollDate );    
    DECLARE @dCurrentDate date = @loadDate;
    DECLARE @d1stOfCurMonth DATE = dateAdd(day, -1 * (DatePart(day, @dCurrentDate))+1, @dCurrentDate);
    DECLARE @d1stOfPriorMonth DATE = DateAdd(month, -1, @d1stOfCurMonth);
    DECLARE @dLastOfCurMonth DATE = dateAdd(day, -1 * (DatePart(day, @dCurrentDate)), DATEADD(MONTH, 1 ,@dCurrentDate));
    
    /* Log adw Load */ 
    DECLARE @OutputTbl TABLE (ID INT);	          
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
	   ;
	       
    /* this should be a validation: if there is not a record match fail out*/
    SELECT @ProgramID =  cp.lstAhsProgramsKey, @ProgramName =  cp.ProgramName
    --SELECT cp.lstAhsProgramsKey, cp.ProgramName
    FROM lst.lstClinicalPrograms cp
    where cp.ProgramName = 'C-Prenatal Care';
    
    --SELECT  @ProgramID, @ProgramName, @LoadDate, @OrigMemberDateForNewMembers, @EnrollDate, @dCurrentDate, @d1stOfCurMonth, @d1stOfPriorMonth, @dCurrentDate;

     /* insert into */
    INSERT INTO adw.ExportAhsPrograms (LoadDate, ClientKey,ClientMemberKey, ProgramID, ExpLobName	  
		  ,ExpProgram_Name, ExpEnrollDate, ExpCreateDate, ExpMemberID
		  , ExpEnrollEndDate, ExpProgramstatus, ExpReasonDescription
		  , ExpReferalType    
		  )
    OUTPUT inserted.ExportAhsProgramsKey INTO @OutputTbl(ID)  
    SELECT @LoadDate AS LoadDate
	   , Client.ClientKey
	   , mbr.Uhc_subscriber_Id AS ClientMemberKey
	   , @ProgramID AS ProgramID	
	   , client.CS_Export_LobName
	   , @ProgramName as ExpProgram_Name
	   , @EnrollDate as ExpEnrollDate
	   , @EnrollDate as ExpCreateDate
	   , Mbr.UHC_SUBSCRIBER_ID AS ExpMemberID
	   , DATEADD(day, 42, mbr.MEMBER_CUR_EFF_DATE) AS DateDue
	   , 'ACTIVE' as ExpProgramstatus
	   , 'Enrolled in a Program' as ExpReasonDescription
	   , 'External' as ExpReferalType	   
    FROM  dbo.vw_UHC_ActiveMembers mbr
	   JOIN lst.List_Client Client on 1 = Client.ClientKey
	   JOIN (SELECT pm.SourceValue, pm.TargetValue
		  FROM lst.lstPlanMapping pm
		  where pm.ClientKey = 1
			 and getDate() between pm.EffectiveDate and pm.ExpirationDate
			 and pm.TargetSystem = 'ACDW_PlnName'
			 and pm.TargetValue in ('TX STAR Pregnant Woman'
				,'TX CHIP Perinate Perinatal <= 198 FPL before birth'
				,'TX CHIP Perinate Perinatal >198 & <=202 FPL <birth'
				,'TX STAR Pregnant Women - Qualified Alien'
				,'TX STAR Age 19-20 Child - QA')
				) plns ON mbr.SUBGRP_ID = plns.SourceValue
	   LEFT JOIN (SELECT PreNatal.ClientMemberKey
				FROM adw.ExportAhsPrograms PreNatal
				WHERE PreNatal.LoadDate BETWEEN @d1stOfPriorMonth and @dLastOfCurMonth
				    AND PreNatal.ProgramID = @ProgramID
				GROUP BY PreNatal.ClientMemberKey
				) ExcludedEnrolled ON ExcludedEnrolled.ClientMemberKey = mbr.MEMBER_ID
    WHERE ((Month(PCP_EFFECTIVE_DATE) = MONTH(@d1stOfPriorMonth) AND YEAR(PCP_EFFECTIVE_DATE)  = YEAR(@d1stOfPriorMonth))
		or (MONTH(PCP_EFFECTIVE_DATE)  = MONTH(@d1stOfCurMonth) and YEAR(PCP_EFFECTIVE_DATE)  = YEAR(@d1stOfCurMonth)))
	AND ExcludedEnrolled.ClientMemberKey IS NULL
	;
	
	/* close adw Log record */    
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


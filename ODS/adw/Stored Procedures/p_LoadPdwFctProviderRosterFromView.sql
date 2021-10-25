
CREATE PROCEDURE [adw].[p_LoadPdwFctProviderRosterFromView]
AS

BEGIN    
    /* Purpose: queries all records for Providers, includeding terminated providers, to load the current state into FctProviderRoster */

    /* 1 get dates */      
    DECLARE @d DATE = CONVERT(DATE, getdate());        
    
    /* 2 Log FACT LOAD */        
     /* Log Stag Load */    
    DECLARE @AuditID INT ;    
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	   -- 1 adi load, 2 dw load????
    DECLARE @ClientKey INT	=   14 -- ACE as in ace data for any client
    DECLARE @JobName VARCHAR(200) = OBJECT_NAME(@@PROCID)  -- if it is the procedure name
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = DB_NAME() + '.dbo.vw_AllClient_ProviderRoster_LoadFctSource'    
    DECLARE @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	   SELECT @DestinationName = DB_NAME() + '.ast.fctProviderRoster';    
    DECLARE @ErrorName VARCHAR(200) = 'No Error Name Provided'	;
    DECLARE @SourceCount int;     
    DECLARE @DestinationCount int;	     
    DECLARE @ErrorCount int = 0
    /* close load Staging Log record */    
    DECLARE @ActionStopTime DATETIME;
    Declare @Output table (ID INT PRIMARY KEY NOT NULL) ;
    SELECT @SourceCount	  = COUNT(*) FROM adw.fctProviderRoster PR WHERE @d BETWEEN PR.RowEffectiveDate and PR.RowExpirationDate;      
            
    EXEC amd.sp_AceEtlAudit_Open
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
    
    /* 3 update old records setting the RowExpirationdate  */      
    -- add error handling       
    BEGIN TRAN LoadFctProviderRoster      
	   -- update tran?      
	   
	   UPDATE PR      
		  SET PR.RowExpirationDate = DATEADD(day, -1, @d)      
	   OUTPUT inserted.fctProviderRosterSkey INTO @Output(ID)
	   FROM adw.fctProviderRoster PR      	   
	   WHERE @d BETWEEN PR.RowEffectiveDate and PR.RowExpirationDate;      
	   	   
	   /* close load Staging Log record */    
	   SET @ActionStopTime = getdate();	   
	   SET @AuditStatus = 2;
	   SELECT @DestinationCount = COUNT(id) from @Output;
	   DECLARE @JobStatus tinyInt = 2

	   EXEC amd.sp_AceEtlAudit_Close 
		  @Audit_Id = @AuditID
		  , @ActionStopTime = @ActionStopTime
		  , @SourceCount = @SourceCount		  
		  , @DestinationCount = @DestinationCount
		  , @ErrorCount = @ErrorCount
		  , @JobStatus = @JobStatus
		  ;

	   /* Insert New PR Rows from View into AST table*/      
	   -- add error handling      
	   DELETE FROM @Output;
	   TRUNCATE TABLE ast.fctProviderRoster;
	   /* log */
	   
	   SELECT @SourceCount   = COUNT(*) FROM dbo.[vw_AllClient_ProviderRoster_LoadFctSource] AS ProviderRoster   	   ;
	   SET @ActionStartTime = getdate();	   
	   SET @AuditStatus = 1;
	   SET @JobType = 9 -- staging load;
	   SELECT @DestinationCount = @SourceCount;
	   SET @JobStatus = 1;

	   EXEC amd.sp_AceEtlAudit_Open
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

	   INSERT INTO ast.fctProviderRoster(             
		  [SourceJobName]        
		  , [LoadDate]        
		  , [DataDate]        
		  , IsActive        
		  , RowEffectiveDate              
		  , [ClientKey]        
		  , [LOB]        
		  , [ClientProviderID]        
		  , [NPI]        
		  , [LastName]        
		  , [FirstName]        
		  , [Degree]        
		  , [TIN]        
		  , [PrimarySpeciality]        
		  , [Sub_Speciality]        
		  , [GroupName]        
		  , [EffectiveDate]        
		  , [ExpirationDate]        
		  , [PrimaryAddress]        
		  , [PrimaryCity]        
		  , [PrimaryState]        
		  , [PrimaryZipcode]        
		  , [PrimaryCounty]
		  , [PrimaryPOD]        
		  , [PrimaryQuadrant]        
		  , [PrimaryAddressPhoneNum]        
		  , [BillingAddress]        
		  , [BillingCity]        
		  , [BillingState]        
		  , [BillingZipcode]        
		  , [BillingPOD]        
		  , [BillingAddressPhoneNum]        
		  , [NetworkContact]        
		  , [Comments]        
		  , HealthPlan        
		  , AccountType              
		  , Chapter
		  , ProviderType
		  , AceProviderID	
		  , AceAccountID	
		  , Ethnicity		
		  , LanguagesSpoken	
		  , Provider_DOB
		  , Provider_Gender	
		  )  
	   OUTPUT inserted.fctProviderRosterSkey INTO @Output(id)     
	   SELECT   
		  'ACECAREDW.dbo.vw_AllClient_ProviderRoster' AS SrcJobName											    
		  ,GETDATE() AS LoadDate        
		  --,DATEADD(WK,0,DATEADD(DAY,1-DATEPART(WEEKDAY,GETDATE()),DATEDIFF(DD,0,GETDATE()))) AS DataDate        
		  , GETDATE() AS DataDate -- this value should be the date the data was extracted from SF
		  , CASE WHEN (NOT GETDATE() BETWEEN ProviderRoster.EffectiveDate and ProviderRoster.ExpirationDate) THEN 0
				ELSE 1 
				END AS IsActive        
		  ,@d AS RowEffectiveDate              
		  ,ProviderRoster.CalcClientKey        
		  ,ProviderRoster.LOB LOB
		  ,ProviderRoster.ClientProviderID ClientProviderID
		  ,ProviderRoster.NPI        
		  ,ProviderRoster.LastName LastName
		  ,ProviderRoster.FirstName FirstName        
		  ,ProviderRoster.Degree Degree
		  ,ProviderRoster.TIN        
		  ,ProviderRoster.PrimarySpeciality PrimarySpeciality
		  ,ProviderRoster.Sub_Speciality Sub_Speciality
		  ,ProviderRoster.GroupName GroupName
		  ,ProviderRoster.EffectiveDate
		  ,ProviderRoster.ExpirationDate
		  ,ProviderRoster.PrimaryAddress
		  ,ProviderRoster.PrimaryCity        
		  ,ProviderRoster.PrimaryState        
		  ,ProviderRoster.PrimaryZipcode
		  ,ProviderRoster.PrimaryCounty      
		  ,ProviderRoster.PrimaryPOD
		  ,ProviderRoster.PrimaryQuadrant        
		  ,ProviderRoster.PrimaryAddressPhoneNumber
		  ,ProviderRoster.BillingAddress
		  ,ProviderRoster.BillingCity       
		  ,ProviderRoster.BillingState        
		  ,ProviderRoster.BillingZipcode        
		  ,ProviderRoster.BillingPOD
		  ,ProviderRoster.BillingAddressPhoneNumber        
		  ,ProviderRoster.NetworkContact
		  ,ProviderRoster.Comments
		  ,ProviderRoster.HealthPlan        
		  ,ProviderRoster.AccountType
		  ,ProviderRoster.Chapter
		  ,ProviderRoster.ProviderType
		  ,ProviderRoster.[AceProviderId]	
		  ,ProviderRoster.AceAccountID	
		  ,ProviderRoster.Ethnicity		
		  ,ProviderRoster.LanguagesSpoken	
		  ,TRY_CONVERT(DATE, ProviderRoster.DateOfBirth) DateOfBirth
		  ,ProviderRoster.Gender	
	   FROM dbo.[vw_AllClient_ProviderRoster_LoadFctSource] AS ProviderRoster   	   
	   /* -- remove because require full state of SF data every refresh
	   WHERE @d BETWEEN ProviderRoster.EffectiveDate and ProviderRoster.ExpirationDate
	   */
	   SET @ActionStopTime = getdate();	   
	   SET @AuditStatus = 2;
	   SELECT @DestinationCount = COUNT(id) from @Output;
	   SET @JobStatus = 2

	   EXEC amd.sp_AceEtlAudit_Close 
		  @Audit_Id = @AuditID
		  , @ActionStopTime = @ActionStopTime
		  , @SourceCount = @SourceCount		  
		  , @DestinationCount = @DestinationCount
		  , @ErrorCount = @ErrorCount
		  , @JobStatus = @JobStatus
		  ;

    COMMIT TRAN LoadFctProviderRoster      
	 
	
	/* update varchar data case settings */
--	select * from ast.fctProviderRoster
	/* transLOB				*/
	BEGIN tran LFPR_tranLOB;
		--SELECT pr.fctProviderRosterSkey, src.LOB, adi.udf_ConvertToCamelCase(pr.LOB) AS transLob
		UPDATE pr SET pr.transLOB = adi.udf_ConvertToCamelCase(pr.LOB) 
		FROM (SELECT DISTINCT p.LOB 
				FROM ast.fctProviderRoster p
				WHERE not p.LOB is null) src
				JOIN ast.fctProviderRoster pr ON pr.LOB = src.LOB;
	COMMIT tran LFPR_tranLOB;
	/* transClientProviderID	*/
	BEGIN tran LFPR_transClientProviderID;
		--SELECT pr.fctProviderRosterSkey, src.LOB, adi.udf_ConvertToCamelCase(pr.LOB) AS transLob
		UPDATE pr SET pr.transClientProviderID = adi.udf_ConvertToCamelCase(pr.ClientProviderID) 
		FROM (SELECT DISTINCT p.ClientProviderID 
				FROM ast.fctProviderRoster p
				WHERE not p.ClientProviderID is null) src
				JOIN ast.fctProviderRoster pr ON pr.ClientProviderID = src.ClientProviderID;
	COMMIT tran LFPR__transClientProviderID
	/*	transLastName				*/
	BEGIN tran LFPR_transLastName;
		--SELECT pr.fctProviderRosterSkey, src.LastName, adi.udf_ConvertToCamelCase(pr.LastName) AS transLob
		UPDATE pr SET pr.transLastName = adi.udf_ConvertToCamelCase(pr.LastName) 
		FROM (SELECT DISTINCT p.LastName 
				FROM ast.fctProviderRoster p
				WHERE not p.LastName is null) src
				JOIN ast.fctProviderRoster pr ON pr.LastName = src.LastName;
	COMMIT tran LFPR_transLastName
	/*	transFirstName				*/
	BEGIN tran LFPR_transFirstName;
		--SELECT pr.fctProviderRosterSkey, src.FirstName, adi.udf_ConvertToCamelCase(pr.FirstName) AS transLob
		UPDATE pr SET pr.transFirstName = adi.udf_ConvertToCamelCase(pr.FirstName) 
		FROM (SELECT DISTINCT p.FirstName 
				FROM ast.fctProviderRoster p
				WHERE not p.FirstName is null) src
				JOIN ast.fctProviderRoster pr ON pr.FirstName = src.FirstName;
	COMMIT tran LFPR_transFirstName
	/*	transDegree					*/
	BEGIN tran LFPR_transDegree;
		--SELECT pr.fctProviderRosterSkey, src.Degree, adi.udf_ConvertToCamelCase(pr.Degree) AS transLob
		UPDATE pr SET pr.transDegree = adi.udf_ConvertToCamelCase(pr.Degree) 
		FROM (SELECT DISTINCT p.Degree 
				FROM ast.fctProviderRoster p
				WHERE not p.Degree is null) src
				JOIN ast.fctProviderRoster pr ON pr.Degree = src.Degree;
	COMMIT tran LFPR_transDegree
	/*	transPrimarySpeciality		*/
	BEGIN tran LFPR_transPrimarySpeciality;
		--SELECT pr.fctProviderRosterSkey, src.PrimarySpeciality, adi.udf_ConvertToCamelCase(pr.PrimarySpeciality) AS transLob
		UPDATE pr SET pr.transPrimarySpeciality = adi.udf_ConvertToCamelCase(pr.PrimarySpeciality) 
		FROM (SELECT DISTINCT p.PrimarySpeciality 
				FROM ast.fctProviderRoster p
				WHERE not p.PrimarySpeciality is null) src
				JOIN ast.fctProviderRoster pr ON pr.PrimarySpeciality = src.PrimarySpeciality;
	COMMIT tran LFPR_transPrimarySpeciality
	/*	transSub_Speciality			*/
	BEGIN tran LFPR_transSub_Speciality ;
		--SELECT pr.fctProviderRosterSkey, src.Sub_Speciality, adi.udf_ConvertToCamelCase(pr.Sub_Speciality) AS transLob
		UPDATE pr SET pr.transSub_Speciality = adi.udf_ConvertToCamelCase(pr.Sub_Speciality) 
		FROM (SELECT DISTINCT p.Sub_Speciality 
				FROM ast.fctProviderRoster p
				WHERE not p.Sub_Speciality is null) src
				JOIN ast.fctProviderRoster pr ON pr.Sub_Speciality = src.Sub_Speciality;
	COMMIT tran LFPR_transSub_Speciality ;
	/*	transGroupName				*/
	BEGIN tran LFPR_transGroupName ;
		--SELECT pr.fctProviderRosterSkey, src.GroupName, adi.udf_ConvertToCamelCase(pr.GroupName) AS transLob
		UPDATE pr SET pr.transGroupName = adi.udf_ConvertToCamelCase(pr.GroupName) 
		FROM (SELECT DISTINCT p.GroupName 
				FROM ast.fctProviderRoster p
				WHERE not p.GroupName is null) src
				JOIN ast.fctProviderRoster pr ON pr.GroupName = src.GroupName;
	COMMIT tran LFPR_transGroupName ;
	/*	transPrimaryAddress			*/
	BEGIN tran LFPR_transPrimaryAddress ;
		--SELECT pr.fctProviderRosterSkey, src.GroupName, adi.udf_ConvertToCamelCase(pr.GroupName) AS transLob
		UPDATE pr SET pr.transPrimaryAddress = adi.udf_ConvertToCamelCase(pr.PrimaryAddress) 
		FROM (SELECT DISTINCT p.PrimaryAddress 
				FROM ast.fctProviderRoster p
				WHERE not p.PrimaryAddress is null) src
				JOIN ast.fctProviderRoster pr ON pr.PrimaryAddress = src.PrimaryAddress;
	COMMIT tran LFPR_transPrimaryAddress ;
	/*	transPrimaryCity			*/
	BEGIN tran LFPR_transPrimaryCity ;
		--SELECT pr.fctProviderRosterSkey, src.PrimaryCity, adi.udf_ConvertToCamelCase(pr.PrimaryCity) AS transLob
		UPDATE pr SET pr.transPrimaryCity = adi.udf_ConvertToCamelCase(pr.PrimaryCity) 
		FROM (SELECT DISTINCT p.PrimaryCity 
				FROM ast.fctProviderRoster p
				WHERE not p.PrimaryCity is null) src
				JOIN ast.fctProviderRoster pr ON pr.PrimaryCity = src.PrimaryCity;
	COMMIT tran LFPR_transPrimaryCity ;
	/*	transPrimaryState			*/
	BEGIN tran LFPR_transPrimaryState ;
		--SELECT pr.fctProviderRosterSkey, src.PrimaryState, adi.udf_ConvertToCamelCase(pr.PrimaryState) AS transLob
		UPDATE pr SET pr.transPrimaryState = adi.udf_ConvertToCamelCase(pr.PrimaryState) 
		FROM (SELECT DISTINCT p.PrimaryState 
				FROM ast.fctProviderRoster p
				WHERE not p.PrimaryState is null) src
				JOIN ast.fctProviderRoster pr ON pr.PrimaryState = src.PrimaryState;
	COMMIT tran LFPR_transPrimaryState ;
	/*	transPrimaryPOD				*/
	BEGIN tran LFPR_transPrimaryPOD ;
		--SELECT pr.fctProviderRosterSkey, src.PrimaryPOD, adi.udf_ConvertToCamelCase(pr.PrimaryPOD) AS transLob
		UPDATE pr SET pr.transPrimaryPOD = adi.udf_ConvertToCamelCase(pr.PrimaryPOD) 
		FROM (SELECT DISTINCT p.PrimaryPOD 
				FROM ast.fctProviderRoster p
				WHERE not p.PrimaryPOD is null) src
				JOIN ast.fctProviderRoster pr ON pr.PrimaryPOD = src.PrimaryPOD;
	COMMIT tran LFPR_transPrimaryPOD ;
	/*	transPrimaryQuadrant		*/
	BEGIN tran LFPR_transPrimaryQuadrant ;
		--SELECT pr.fctProviderRosterSkey, src.PrimaryQuadrant, adi.udf_ConvertToCamelCase(pr.PrimaryQuadrant) AS transLob
		UPDATE pr SET pr.transPrimaryQuadrant = adi.udf_ConvertToCamelCase(pr.PrimaryQuadrant) 
		FROM (SELECT DISTINCT p.PrimaryQuadrant 
				FROM ast.fctProviderRoster p
				WHERE not p.PrimaryQuadrant is null) src
				JOIN ast.fctProviderRoster pr ON pr.PrimaryQuadrant = src.PrimaryQuadrant;
	COMMIT tran LFPR_transPrimaryQuadrant ;
	/*	transBillingAddress			*/
	BEGIN tran LFPR_transBillingAddress ;
		--SELECT pr.fctProviderRosterSkey, src.BillingAddress, adi.udf_ConvertToCamelCase(pr.BillingAddress) AS transLob
		UPDATE pr SET pr.transBillingAddress = adi.udf_ConvertToCamelCase(pr.BillingAddress) 
		FROM (SELECT DISTINCT p.BillingAddress 
				FROM ast.fctProviderRoster p
				WHERE not p.BillingAddress is null) src
				JOIN ast.fctProviderRoster pr ON pr.BillingAddress = src.BillingAddress;
	COMMIT tran LFPR_transBillingAddress ;
	/*	transBillingCity			*/
	BEGIN tran LFPR_transBillingCity ;
		--SELECT pr.fctProviderRosterSkey, src.BillingCity, adi.udf_ConvertToCamelCase(pr.BillingCity) AS transLob
		UPDATE pr SET pr.transBillingCity = adi.udf_ConvertToCamelCase(pr.BillingCity) 
		FROM (SELECT DISTINCT p.BillingCity 
				FROM ast.fctProviderRoster p
				WHERE not p.BillingCity is null) src
				JOIN ast.fctProviderRoster pr ON pr.BillingCity = src.BillingCity;
	COMMIT tran LFPR_transBillingCity ;
	/*	transBillingState			*/
	BEGIN tran LFPR_transBillingState ;
		--SELECT pr.fctProviderRosterSkey, src.BillingState, adi.udf_ConvertToCamelCase(pr.BillingState) AS transLob
		UPDATE pr SET pr.transBillingState = adi.udf_ConvertToCamelCase(pr.BillingState) 
		FROM (SELECT DISTINCT p.BillingState 
				FROM ast.fctProviderRoster p
				WHERE not p.BillingState is null) src
				JOIN ast.fctProviderRoster pr ON pr.BillingState = src.BillingState;
	COMMIT tran LFPR_transBillingState ;
	/*	transBillingPOD				*/
	BEGIN tran LFPR_transBillingPOD ;
		--SELECT pr.fctProviderRosterSkey, src.BillingPOD, adi.udf_ConvertToCamelCase(pr.BillingPOD) AS transLob
		UPDATE pr SET pr.transBillingPOD = adi.udf_ConvertToCamelCase(pr.BillingPOD) 
		FROM (SELECT DISTINCT p.BillingPOD 
				FROM ast.fctProviderRoster p
				WHERE not p.BillingPOD is null) src
				JOIN ast.fctProviderRoster pr ON pr.BillingPOD = src.BillingPOD;
	COMMIT tran LFPR_transBillingPOD ;
	/*	transComments			    */
	BEGIN tran LFPR_transComments ;
		--SELECT pr.fctProviderRosterSkey, src.Comments, adi.udf_ConvertToCamelCase(pr.Comments) AS transLob
		UPDATE pr SET pr.transComments = adi.udf_ConvertToCamelCase(pr.Comments) 
		FROM (SELECT DISTINCT p.Comments 
				FROM ast.fctProviderRoster p
				WHERE not p.Comments is null) src
				JOIN ast.fctProviderRoster pr ON pr.Comments = src.Comments;
	COMMIT tran LFPR_transBillingPOD ;
	/*	transHealthPlan				*/
	BEGIN tran LFPR_transHealthPlans ;
		--SELECT pr.fctProviderRosterSkey, src.HealthPlan, adi.udf_ConvertToCamelCase(pr.HealthPlan) AS transLob
		UPDATE pr SET pr.transHealthPlan = adi.udf_ConvertToCamelCase(pr.HealthPlan) 
		FROM (SELECT DISTINCT p.HealthPlan 
				FROM ast.fctProviderRoster p
				WHERE not p.HealthPlan is null) src
				JOIN ast.fctProviderRoster pr ON pr.HealthPlan = src.HealthPlan;
	COMMIT tran LFPR_transHealthPlan ;
	/*	transNetworkContact			*/
	BEGIN tran LFPR_transNetworkContact ;
		--SELECT pr.fctProviderRosterSkey, src.NetworkContact, adi.udf_ConvertToCamelCase(pr.NetworkContact) AS transLob
		UPDATE pr SET pr.transNetworkContact = adi.udf_ConvertToCamelCase(pr.NetworkContact) 
		FROM (SELECT DISTINCT p.NetworkContact 
				FROM ast.fctProviderRoster p
				WHERE not p.NetworkContact is null) src
				JOIN ast.fctProviderRoster pr ON pr.NetworkContact = src.NetworkContact;
	COMMIT tran LFPR_transNetworkContact ;
	/*	transChapter				*/
	BEGIN tran LFPR_transChapter ;
		--SELECT pr.fctProviderRosterSkey, src.Chapter, adi.udf_ConvertToCamelCase(pr.Chapter) AS transLob
		UPDATE pr SET pr.transChapter = adi.udf_ConvertToCamelCase(pr.Chapter) 
		FROM (SELECT DISTINCT p.Chapter 
				FROM ast.fctProviderRoster p
				WHERE not p.Chapter is null) src
				JOIN ast.fctProviderRoster pr ON pr.Chapter = src.Chapter;
	COMMIT tran LFPR_transChapter ;
	/*	Ace Provider ID	*/
	BEGIN tran LFPR_transAceProvId ;
		--SELECT pr.fctProviderRosterSkey, src.Chapter, adi.udf_ConvertToCamelCase(pr.Chapter) AS transLob
		UPDATE pr SET pr.TransAceProviderID = adi.udf_ConvertToCamelCase(pr.AceProviderID) 
		FROM (SELECT DISTINCT p.AceProviderID				
				FROM ast.fctProviderRoster p
				WHERE not p.AceProviderID is null) src
				JOIN ast.fctProviderRoster pr ON pr.AceProviderID = src.AceProviderID;
	COMMIT tran LFPR_transAceProvId ;
	/*	ProviderRoster.AceAccountID	*/
	BEGIN tran LFPR_transAceAccountID ;
		--SELECT pr.fctProviderRosterSkey, src.Chapter, adi.udf_ConvertToCamelCase(pr.Chapter) AS transLob
		UPDATE pr SET pr.TransAceAccountID = adi.udf_ConvertToCamelCase(pr.AceAccountID) 
		FROM (SELECT DISTINCT p.AceAccountID
				FROM ast.fctProviderRoster p
				WHERE not p.AceAccountID is null) src
				JOIN ast.fctProviderRoster pr ON pr.AceAccountID= src.AceAccountID;
	COMMIT tran LFPR_transAceAccountID ;
	/*	ProviderRoster.Ethnicity		*/
	BEGIN tran LFPR_transEthnicity ;
		--SELECT pr.fctProviderRosterSkey, src.Chapter, adi.udf_ConvertToCamelCase(pr.Chapter) AS transLob
		UPDATE pr SET pr.TransEthnicity = adi.udf_ConvertToCamelCase(pr.Ethnicity) 
		FROM (SELECT DISTINCT p.Ethnicity
				FROM ast.fctProviderRoster p
				WHERE not p.Ethnicity is null) src
				JOIN ast.fctProviderRoster pr ON pr.Ethnicity = src.Ethnicity;
	COMMIT tran LFPR_transEthnicity ;
	/*	ProviderRoster.LanguagesSpoken	 */
	BEGIN tran LFPR_transLanguagesSpoken ;
		--SELECT pr.fctProviderRosterSkey, src.Chapter, adi.udf_ConvertToCamelCase(pr.Chapter) AS transLob
		UPDATE pr SET pr.TransLanguagesSpoken = adi.udf_ConvertToCamelCase(pr.LanguagesSpoken) 
		FROM (SELECT DISTINCT p.LanguagesSpoken
				FROM ast.fctProviderRoster p
				WHERE not p.LanguagesSpoken is null) src
				JOIN ast.fctProviderRoster pr ON pr.LanguagesSpoken= src.LanguagesSpoken;
	COMMIT tran LFPR_transLanguagesSpoken ;
	/*	ProviderRoster.PrimaryCounty	 */
	BEGIN tran LFPR_transPrimaryCounty ;
		--SELECT ast.fctProviderRosterSkey, CASE WHEN (am.Destination  is null) then 'UnknownCounty' ELSE am.Destination END AS Market
		UPDATE ast SET ast.Chapter = CASE WHEN (am.Destination  is null) then 'Unknown' ELSE am.Destination END 
		FROM ast.fctProviderRoster ast
		  LEFT JOIN acdw_clms_shcn_bcbs.lst.ListAceMapping am 
			 ON ast.PrimaryCounty = am.Source
				and am.MappingTypeKey = 17
	     WHERE ast.ClientKey = 20;				
	COMMIT tran LFPR_transPrimaryCounty;
	

	   SELECT @SourceCount   = COUNT(*) FROM ast.fctProviderRoster ;
	   SET @ActionStartTime = getdate();	   
	   SET @AuditStatus = 1;
	   SET @JobType = 8 -- adw load;
	   SELECT @InputSourceName = DB_NAME() + '.ast.fctProviderRoster'     
	   SELECT @DestinationName = DB_NAME() + '.adw.fctProviderRoster';    
	   SELECT @DestinationCount = @SourceCount;
	   SET @JobStatus = 1;

	   EXEC amd.sp_AceEtlAudit_Open
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
	   
    /*Reset output table to empty*/
    DELETE FROM @output;

	/* export to adw.FctProviderRoster */
    INSERT INTO adw.fctProviderRoster(             
		  [SourceJobName]        
		  , [LoadDate]        
		  , [DataDate]        
		  , IsActive        
		  , RowEffectiveDate              
		  , [ClientKey]        
		  , [LOB]        
		  , [ClientProviderID]        
		  , [NPI]        
		  , [LastName]        
		  , [FirstName]        
		  , [Degree]        
		  , [TIN]        
		  , [PrimarySpeciality]        
		  , [Sub_Speciality]        
		  , [GroupName]        
		  , [EffectiveDate]        
		  , [ExpirationDate]        
		  , [PrimaryAddress]        
		  , [PrimaryCity]        
		  , [PrimaryState]        
		  , [PrimaryZipcode] 
		  , PrimaryCounty       
		  , [PrimaryPOD]        
		  , [PrimaryQuadrant]        
		  , [PrimaryAddressPhoneNum]        
		  , [BillingAddress]        
		  , [BillingCity]        
		  , [BillingState]        
		  , [BillingZipcode]        
		  , [BillingPOD]        
		  , [BillingAddressPhoneNum]        
		  , [NetworkContact]        
		  , [Comments]        
		  , HealthPlan        
		  , AccountType              
		  , Chapter
		  , ProviderType
		  , AceProviderID
		  , AceAccountID
		  , Ethnicity
		  , LanguagesSpoken
		  , Provider_DOB
		  , Provider_Gender
		  )     
	   OUTPUT inserted.fctProviderRosterSkey INTO @Output(id)   
	   SELECT   
		  ProviderRoster.SourceJobName
		  ,ProviderRoster.LoadDate        	  
		  ,ProviderRoster.DataDate 
		  ,ProviderRoster.IsActive        
		  ,ProviderRoster.RowEffectiveDate              
		  ,ProviderRoster.ClientKey        
		  ,ProviderRoster.transLOB LOB
		  ,ProviderRoster.transClientProviderID ClientProviderID
		  ,ProviderRoster.NPI        
		  ,ProviderRoster.TransLastName LastName
		  ,ProviderRoster.TransFirstName FirstName        
		  ,ProviderRoster.TransDegree Degree
		  ,ProviderRoster.TIN        
		  ,ProviderRoster.TransPrimarySpeciality PrimarySpeciality
		  ,ProviderRoster.TransSub_Speciality Sub_Speciality
		  ,ProviderRoster.TransGroupName GroupName
		  ,ProviderRoster.EffectiveDate
		  ,ProviderRoster.ExpirationDate
		  ,ProviderRoster.TransPrimaryAddress
		  ,ProviderRoster.TransPrimaryCity        
		  ,ProviderRoster.TransPrimaryState        
		  ,ProviderRoster.PrimaryZipcode        
		  ,providerRoster.PrimaryCounty
		  ,ProviderRoster.TransPrimaryPOD
		  ,ProviderRoster.TransPrimaryQuadrant        
		  ,ProviderRoster.PrimaryAddressPhoneNum
		  ,ProviderRoster.TransBillingAddress
		  ,ProviderRoster.TransBillingCity       
		  ,ProviderRoster.TransBillingState        
		  ,ProviderRoster.BillingZipcode        
		  ,ProviderRoster.TransBillingPOD
		  ,ProviderRoster.BillingAddressPhoneNum
		  ,ProviderRoster.TransNetworkContact
		  ,ProviderRoster.TransComments
		  ,ProviderRoster.TransHealthPlan        
		  ,ProviderRoster.AccountType
		  ,ProviderRoster.TransChapter
		  ,ProviderRoster.ProviderType				  
		  ,ProviderRoster.TransAceProviderID
		  ,ProviderRoster.TransAceAccountID
		  ,ProviderRoster.TransEthnicity
		  ,ProviderRoster.TransLanguagesSpoken
		  ,ProviderRoster.Provider_DOB
		  ,ProviderRoster.Provider_Gender		  
	   FROM ast.fctProviderRoster AS ProviderRoster   	   
    /* Log load */
    SET @ActionStopTime = getdate();	   
    SET @AuditStatus = 2;
    SELECT @DestinationCount = COUNT(id) from @Output;
    SET @JobStatus = 2

    EXEC amd.sp_AceEtlAudit_Close 
	   @Audit_Id = @AuditID
		  , @ActionStopTime = @ActionStopTime
		  , @SourceCount = @SourceCount		  
		  , @DestinationCount = @DestinationCount
		  , @ErrorCount = @ErrorCount
		  , @JobStatus = @JobStatus
		  ;

END;


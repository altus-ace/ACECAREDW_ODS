CREATE PROCEDURE [adw].[Load_Pdw_MbrProgramEnrollments_ToShcnMssp_FromAceCare]
 
AS 
BEGIN  
	/* DECLARE @Count INT = 1
		DECLARE @CLientKey int = 16;
			 DECLARE @SourceCount int;  	 
			 Select  @SourceCount = COUNT(*)
			 FROM dbo.Tmp_AHS_ProgramEnrollments APE
			 JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
    		  JOIN (SELECT APE.tmpAhsPatientAppointmentsSKey--,  APE.ClientMemberKey, APE.ProgramName, APE.LoadDate              
				, ROW_NUMBER() OVER (partition BY APE.ClientMemberKey, APE.ProgramName, APE.StartDate ORDER BY APE.LoadDate DESC) aRowNum
				FROM dbo.Tmp_AHS_ProgramEnrollments APE
			 	JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
				WHERE APE.ShcnMsspLoadStatus = 0 AND Client.ClientKey = @CLientKey) LatestProgEnr
			 ON APE.tmpAhsPatientAppointmentsSKey = LatestProgEnr.tmpAhsPatientAppointmentsSKey
			 and LatestProgEnr.aRowNum = 1 
			WHERE APE.ShcnMsspLoadStatus = 0 AND Client.ClientKey = @CLientKey
			SET @Count = @SourceCount;

			IF @Count > 0 
	*/
	  --Processing for SHCN MSSP
	   -- truncate the table
	  -- TRUNCATE TABLE ACDW_CLMS_SHCN_MSSP.[adw].[MbrProgramEnrollments] ;

    /* XXXXXXXXXX Move Program ENrollments to SHCN_MSSP catelog XXXXXXXX*/
    INSERT INTO ACDW_CLMS_SHCN_MSSP.[adw].[MbrProgramEnrollments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[ProgramName]
               ,[EnrollmentStartDate]
               ,[EnrollmentStopDate]
               ,[PlanStartDate]
               ,[PlanStopDate]
               ,[ProgramStatus]
               ,UpdateOnDate
               ,[SrcFileName]
               ,[LoadDate]
               )
    SELECT -- APE.tmpAhsPatientAppointmentsSKey, 
                  APE.ClientMemberKey, 
                  Client.ClientKey,
                  APE.ProgramName, 
                  APE.StartDate, 
                  APE.EndDate, 
                  APE.PlanStartDate, 
                  APE.PlanEndDate, 
                  APE.ProgramStatusName, 
                  APE.UpdatedOnDate, 
                  APE.srcFileName, 
                  APE.LoadDate              			   
    FROM dbo.Tmp_AHS_ProgramEnrollments APE
        JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
    	   JOIN (SELECT APE.tmpAhsPatientAppointmentsSKey--,  APE.ClientMemberKey, APE.ProgramName, APE.LoadDate              
			 , ROW_NUMBER() OVER (partition BY APE.ClientMemberKey, APE.ProgramName, APE.StartDate ORDER BY APE.LoadDate DESC) aRowNum
			 FROM dbo.Tmp_AHS_ProgramEnrollments APE
				JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
			 WHERE APE.ShcnMsspLoadStatus = 0 AND Client.ClientKey = 16) LatestProgEnr
		  ON APE.tmpAhsPatientAppointmentsSKey = LatestProgEnr.tmpAhsPatientAppointmentsSKey
			 and LatestProgEnr.aRowNum = 1 
    WHERE LOB LIKE (SELECT ClientShortName
					 FROM lst.List_Client
					 WHERE	ClientKey = 16
					 ) 
	--AND APE.ShcnMsspLoadStatus = 0 
	    ;
	/*    
     update APE set APE.ShcnMsspLoadStatus = 1	
	FROM dbo.Tmp_AHS_ProgramEnrollments APE	
	where APE.ShcnMsspLoadStatus = 0;*/

END;

 /*2. Processing for BCBS*/
BEGIN
	
	--TRUNCATE TABLE ACDW_CLMS_SHCN_BCBS.[adw].[MbrProgramEnrollments] ;

   INSERT INTO[ACDW_CLMS_SHCN_BCBS].[adw].[MbrProgramEnrollments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[ProgramName]
               ,[EnrollmentStartDate]
               ,[EnrollmentStopDate]
               ,[PlanStartDate]
               ,[PlanStopDate]
               ,[ProgramStatus]
               ,UpdateOnDate
               ,[SrcFileName]
               ,[LoadDate]
               ) --  DECLARE @CLientKey INT = 20
    SELECT -- APE.tmpAhsPatientAppointmentsSKey, 
                  APE.ClientMemberKey, 
                  Client.ClientKey,
                  APE.ProgramName, 
                  APE.StartDate, 
                  APE.EndDate, 
                  APE.PlanStartDate, 
                  APE.PlanEndDate, 
                  APE.ProgramStatusName, 
                  APE.UpdatedOnDate, 
                  APE.srcFileName, 
                  APE.LoadDate             			   
    FROM dbo.Tmp_AHS_ProgramEnrollments APE
        JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
    	   JOIN (SELECT APE.tmpAhsPatientAppointmentsSKey--,  APE.ClientMemberKey, APE.ProgramName, APE.LoadDate              
			 , ROW_NUMBER() OVER (partition BY APE.ClientMemberKey, APE.ProgramName, APE.StartDate ORDER BY APE.LoadDate DESC) aRowNum
			 FROM dbo.Tmp_AHS_ProgramEnrollments APE
				JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
			 WHERE APE.ShcnBcbsLoadStatus = 0 AND Client.ClientKey = 20) LatestProgEnr
		  ON APE.tmpAhsPatientAppointmentsSKey = LatestProgEnr.tmpAhsPatientAppointmentsSKey
			 and LatestProgEnr.aRowNum = 1 
     WHERE LOB LIKE (SELECT ClientShortName
					 FROM lst.List_Client
					 WHERE	ClientKey = 20
					 ) 
	--AND APE.ShcnBcbsLoadStatus = 0 AND Client.ClientKey = 20
	    ;
	   /* 
     UPDATE APE set APE.ShcnBcbsLoadStatus = 1		
	FROM dbo.Tmp_AHS_ProgramEnrollments APE		
	where APE.ShcnBcbsLoadStatus = 0;*/

END

 /*3. Processing for UHC*/
 BEGIN
   -- TRUNCATE TABLE ACDW_CLMS_UHC.[adw].[MbrProgramEnrollments] ;

    /* XXXXXXXXXX Move Program ENrollments to SHCN_MSSP catelog XXXXXXXX*/
    INSERT INTO ACDW_CLMS_UHC.[adw].[MbrProgramEnrollments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[ProgramName]
               ,[EnrollmentStartDate]
               ,[EnrollmentStopDate]
               ,[PlanStartDate]
               ,[PlanStopDate]
               ,[ProgramStatus]
               ,UpdateOnDate
               ,[SrcFileName]
               ,[LoadDate]
               )
    SELECT -- APE.tmpAhsPatientAppointmentsSKey, 
                  APE.ClientMemberKey, 
                  Client.ClientKey,
                  APE.ProgramName, 
                  APE.StartDate, 
                  APE.EndDate, 
                  APE.PlanStartDate, 
                  APE.PlanEndDate, 
                  APE.ProgramStatusName, 
                  APE.UpdatedOnDate, 
                  APE.srcFileName, 
                  APE.LoadDate   -- ,LOB          			   
    FROM dbo.Tmp_AHS_ProgramEnrollments APE
        JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
    	   JOIN (SELECT APE.tmpAhsPatientAppointmentsSKey--,  APE.ClientMemberKey, APE.ProgramName, APE.LoadDate              
			 , ROW_NUMBER() OVER (partition BY APE.ClientMemberKey, APE.ProgramName, APE.StartDate ORDER BY APE.LoadDate DESC) aRowNum
			 FROM dbo.Tmp_AHS_ProgramEnrollments APE
				JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
			 WHERE APE.LoadStatus_AcdwClmsUhc = 0 AND Client.ClientKey = 1) LatestProgEnr
		  ON APE.tmpAhsPatientAppointmentsSKey = LatestProgEnr.tmpAhsPatientAppointmentsSKey
			 and LatestProgEnr.aRowNum = 1 
      WHERE LOB LIKE (SELECT ClientShortName
					 FROM lst.List_Client
					 WHERE	ClientKey = 1
					 ) 
	--AND APE.LoadStatus_AcdwClmsUhc = 0 AND Client.ClientKey = 1
	    ;
	  /*  
     update APE set APE.LoadStatus_AcdwClmsUhc = 1	
	FROM dbo.Tmp_AHS_ProgramEnrollments APE	
	where APE.LoadStatus_AcdwClmsUhc = 0;*/

END;

	/**4. Processing for AMGTX_MA*/
BEGIN
	--TRUNCATE TABLE ACDW_CLMS_AMGTX_MA.[adw].[MbrProgramEnrollments] ;

    /* XXXXXXXXXX Move Program ENrollments to AMGTX_MA catelog XXXXXXXX*/
    INSERT INTO ACDW_CLMS_AMGTX_MA.[adw].[MbrProgramEnrollments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[ProgramName]
               ,[EnrollmentStartDate]
               ,[EnrollmentStopDate]
               ,[PlanStartDate]
               ,[PlanStopDate]
               ,[ProgramStatus]
               ,UpdateOnDate
               ,[SrcFileName]
               ,[LoadDate]
               )
    SELECT -- APE.tmpAhsPatientAppointmentsSKey, 
                  APE.ClientMemberKey, 
                  Client.ClientKey,
                  APE.ProgramName, 
                  APE.StartDate, 
                  APE.EndDate, 
                  APE.PlanStartDate, 
                  APE.PlanEndDate, 
                  APE.ProgramStatusName, 
                  APE.UpdatedOnDate, 
                  APE.srcFileName, 
                  APE.LoadDate      -- ,LOB       			   
    FROM dbo.Tmp_AHS_ProgramEnrollments APE
        JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
    	   JOIN (SELECT APE.tmpAhsPatientAppointmentsSKey--,  APE.ClientMemberKey, APE.ProgramName, APE.LoadDate              
			 , ROW_NUMBER() OVER (partition BY APE.ClientMemberKey, APE.ProgramName, APE.StartDate ORDER BY APE.LoadDate DESC) aRowNum
			 FROM dbo.Tmp_AHS_ProgramEnrollments APE
				JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
			 WHERE APE.LoadStatus_AcdwClmsAMGTX_MA = 0 AND Client.ClientKey = 21) LatestProgEnr
		  ON APE.tmpAhsPatientAppointmentsSKey = LatestProgEnr.tmpAhsPatientAppointmentsSKey
			 and LatestProgEnr.aRowNum = 1 
      WHERE LOB LIKE '%TX_MA%'/*LIKE (SELECT ClientShortName
					 FROM lst.List_Client
					 WHERE	ClientKey = 21
					 ) */
	--AND APE.LoadStatus_AcdwClmsAMGTX_MA = 0 AND Client.ClientKey = 21
	    ;
	   /* 
     update APE set APE.LoadStatus_AcdwClmsAMGTX_MA = 1	
	FROM dbo.Tmp_AHS_ProgramEnrollments APE	
	where APE.LoadStatus_AcdwClmsAMGTX_MA = 0;*/

END

  /*5. Processing for AMGTX_MCD*/
  BEGIN
   -- TRUNCATE TABLE ACDW_CLMS_AMGTX_MCD.[adw].[MbrProgramEnrollments] ;

    /* XXXXXXXXXX Move Program ENrollments to AMGTX_MCD catelog XXXXXXXX*/
    INSERT INTO ACDW_CLMS_AMGTX_MCD.[adw].[MbrProgramEnrollments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[ProgramName]
               ,[EnrollmentStartDate]
               ,[EnrollmentStopDate]
               ,[PlanStartDate]
               ,[PlanStopDate]
               ,[ProgramStatus]
               ,UpdateOnDate
               ,[SrcFileName]
               ,[LoadDate]
               )
    SELECT -- APE.tmpAhsPatientAppointmentsSKey, 
                  APE.ClientMemberKey, 
                  Client.ClientKey,
                  APE.ProgramName, 
                  APE.StartDate, 
                  APE.EndDate, 
                  APE.PlanStartDate, 
                  APE.PlanEndDate, 
                  APE.ProgramStatusName, 
                  APE.UpdatedOnDate, 
                  APE.srcFileName, 
                  APE.LoadDate           			   
    FROM dbo.Tmp_AHS_ProgramEnrollments APE
        JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
    	   JOIN (SELECT APE.tmpAhsPatientAppointmentsSKey--,  APE.ClientMemberKey, APE.ProgramName, APE.LoadDate              
			 , ROW_NUMBER() OVER (partition BY APE.ClientMemberKey, APE.ProgramName, APE.StartDate ORDER BY APE.LoadDate DESC) aRowNum
			 FROM dbo.Tmp_AHS_ProgramEnrollments APE
				JOIN lst.List_Client Client ON APE.LOB = Client.CS_Export_LobName	   
			 WHERE APE.LoadStatus_AcdwClmsAMGTX_MCD = 0 AND Client.ClientKey = 22) LatestProgEnr
		  ON APE.tmpAhsPatientAppointmentsSKey = LatestProgEnr.tmpAhsPatientAppointmentsSKey
			 and LatestProgEnr.aRowNum = 1 
    WHERE LOB LIKE '%TX_MD%'/*LIKE (SELECT ClientShortName
					 FROM lst.List_Client
					 WHERE	ClientKey = 22
					 ) */
	-- AND APE.LoadStatus_AcdwClmsAMGTX_MCD = 0 
	-- AND Client.ClientKey = 22
	    ;
	/*    
    update APE set APE.LoadStatus_AcdwClmsAMGTX_MCD = 1	
	FROM dbo.Tmp_AHS_ProgramEnrollments APE	
	where APE.LoadStatus_AcdwClmsAMGTX_MCD = 0;*/
END
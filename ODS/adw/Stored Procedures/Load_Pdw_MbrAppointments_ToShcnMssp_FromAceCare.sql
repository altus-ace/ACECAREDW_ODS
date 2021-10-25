CREATE PROCEDURE [adw].[Load_Pdw_MbrAppointments_ToShcnMssp_FromAceCare]
--@Count INT OUTPUT -- Removed by byu
AS
BEGIN   

 --   TRUNCATE TABLE ACDW_CLMS_SHCN_MSSP.[adw].[MbrAppointments]; remove by byu

	  DECLARE @SourceCount int;  	 
	  Select  @SourceCount = COUNT(*)
	    FROM dbo.tmp_AHS_PatientAppointments apa
        JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
   -- WHERE APA.RowStatus = 0 AND Client.ClientKey = 16;
	--SET @Count = @SourceCount	-- Removed by byu
	--1
    INSERT INTO ACDW_CLMS_SHCN_MSSP.[adw].[MbrAppointments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[AppointmentStatus]
               ,[AppointmentDate]
               ,[ScheduledByUser]
               ,[AppointmentNote]
               ,[AppointmentCreatedDate]
               ,[srcFileName]
               ,[LoadDate]
               ,[CreatedDate]
               ,[CreatedBy])
    SELECT --apa.tmpAhsPatientAppointmentsSKey, 
        apa.ClientMemberKey, 
        Client.ClientKey, 	 
        apa.AppointmentStatusName, 
        apa.AppointmentDate,     
        apa.AppointmentScheduledBy, 
        apa.AppointmentNote, 
        apa.AppointmentCreatedDate,     
        apa.srcFileName, 
        apa.LoadDate, 
        apa.CreatedDate, 
        apa.CreatedBy
    FROM dbo.tmp_AHS_PatientAppointments apa
        JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
        /*
	   JOIN ACDW_CLMS_SHCN_MSSP.adw.FctMembership Mbr 
    		  ON apa.ClientMemberKey = mbr.ClientMemberKey
            AND apa.LOB = 'SHCN_MSSP'*/
    --WHERE APA.RowStatus = 0 
	WHERE Client.ClientKey = 16;
   
END;



/* 2 Process for SHCN_BCBS*/
BEGIN
  INSERT INTO ACDW_CLMS_SHCN_BCBS.[adw].[MbrAppointments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[AppointmentStatus]
               ,[AppointmentDate]
               ,[ScheduledByUser]
               ,[AppointmentNote]
               ,[AppointmentCreatedDate]
               ,[srcFileName]
               ,[LoadDate]
               ,[CreatedDate]
               ,[CreatedBy])
    SELECT --apa.tmpAhsPatientAppointmentsSKey, 
        apa.ClientMemberKey, 
        Client.ClientKey, 	 
        apa.AppointmentStatusName, 
        apa.AppointmentDate,     
        apa.AppointmentScheduledBy, 
        apa.AppointmentNote, 
        apa.AppointmentCreatedDate,     
        apa.srcFileName, 
        apa.LoadDate, 
        apa.CreatedDate, 
        apa.CreatedBy
    FROM dbo.tmp_AHS_PatientAppointments apa
        JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
       WHERE Client.ClientKey = 20
	   AND LoadDate = CONVERT(DATE,GETDATE());
END

/* 3 Process for UHC*/
BEGIN
  INSERT INTO ACDW_CLMS_UHC.[adw].[MbrAppointments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[AppointmentStatus]
               ,[AppointmentDate]
               ,[ScheduledByUser]
               ,[AppointmentNote]
               ,[AppointmentCreatedDate]
               ,[srcFileName]
               ,[LoadDate]
               ,[CreatedDate]
               ,[CreatedBy])
    SELECT --apa.tmpAhsPatientAppointmentsSKey, 
        apa.ClientMemberKey, 
        Client.ClientKey, 	 
        apa.AppointmentStatusName, 
        apa.AppointmentDate,     
        apa.AppointmentScheduledBy, 
        apa.AppointmentNote, 
        apa.AppointmentCreatedDate,     
        apa.srcFileName, 
        apa.LoadDate, 
        apa.CreatedDate, 
        apa.CreatedBy
    FROM dbo.tmp_AHS_PatientAppointments apa
        JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
       WHERE Client.ClientKey = 1
	   AND LoadDate = CONVERT(DATE,GETDATE());
END


/* 4 Process for AMGTX_MA*/
BEGIN
  INSERT INTO ACDW_CLMS_AMGTX_MA.[adw].[MbrAppointments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[AppointmentStatus]
               ,[AppointmentDate]
               ,[ScheduledByUser]
               ,[AppointmentNote]
               ,[AppointmentCreatedDate]
               ,[srcFileName]
               ,[LoadDate]
               ,[CreatedDate]
               ,[CreatedBy])
    SELECT --apa.tmpAhsPatientAppointmentsSKey, 
        apa.ClientMemberKey, 
        Client.ClientKey, 	 
        apa.AppointmentStatusName, 
        apa.AppointmentDate,     
        apa.AppointmentScheduledBy, 
        apa.AppointmentNote, 
        apa.AppointmentCreatedDate,     
        apa.srcFileName, 
        apa.LoadDate, 
        apa.CreatedDate, 
        apa.CreatedBy
    FROM dbo.tmp_AHS_PatientAppointments apa
        JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
       WHERE Client.ClientKey = 21
	   AND LoadDate = CONVERT(DATE,GETDATE());
END



/* 5 Process for AMGTX_MCD*/
BEGIN
  INSERT INTO ACDW_CLMS_AMGTX_MCD.[adw].[MbrAppointments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[AppointmentStatus]
               ,[AppointmentDate]
               ,[ScheduledByUser]
               ,[AppointmentNote]
               ,[AppointmentCreatedDate]
               ,[srcFileName]
               ,[LoadDate]
               ,[CreatedDate]
               ,[CreatedBy])
    SELECT --apa.tmpAhsPatientAppointmentsSKey, 
        apa.ClientMemberKey, 
        Client.ClientKey, 	 
        apa.AppointmentStatusName, 
        apa.AppointmentDate,     
        apa.AppointmentScheduledBy, 
        apa.AppointmentNote, 
        apa.AppointmentCreatedDate,     
        apa.srcFileName, 
        apa.LoadDate, 
        apa.CreatedDate, 
        apa.CreatedBy
    FROM dbo.tmp_AHS_PatientAppointments apa
        JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
       WHERE Client.ClientKey = 22
	   AND LoadDate = CONVERT(DATE,GETDATE());
END


/* 6 Process for Devoted*/
BEGIN
  INSERT INTO ACDW_CLMS_DHTX.[adw].[MbrAppointments]
               ([ClientMemberKey]
               ,[ClientKey]
               ,[AppointmentStatus]
               ,[AppointmentDate]
               ,[ScheduledByUser]
               ,[AppointmentNote]
               ,[AppointmentCreatedDate]
               ,[srcFileName]
               ,[LoadDate]
               ,[CreatedDate]
               ,[CreatedBy])
    SELECT --apa.tmpAhsPatientAppointmentsSKey, 
        apa.ClientMemberKey, 
        Client.ClientKey, 	 
        apa.AppointmentStatusName, 
        apa.AppointmentDate,     
        apa.AppointmentScheduledBy, 
        apa.AppointmentNote, 
        apa.AppointmentCreatedDate,     
        apa.srcFileName, 
        apa.LoadDate, 
        apa.CreatedDate, 
        apa.CreatedBy
    FROM dbo.tmp_AHS_PatientAppointments apa
        JOIN lst.List_Client Client ON APA.lOB = Client.CS_Export_LobName
       WHERE Client.ClientKey = 11
	   AND LoadDate = CONVERT(DATE,GETDATE());
END
/**To kepp updating clients*/
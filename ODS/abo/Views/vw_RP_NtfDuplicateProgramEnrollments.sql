
CREATE VIEW [abo].[vw_RP_NtfDuplicateProgramEnrollments]
AS 

    SELECT DupPrograms.ClientMemberKey 
            , DupPrograms.ActualDischargeDate
    	   , DupPrograms.DischargeDisposition
    	   , DupPrograms.DiagnosisDesc
    	   , DupPrograms.AdmitHospital
    	   , DupPrograms.AceFollowUpDueDate 
    	   , DupPrograms.AdmitDatetime
    	   , DupPrograms.ntfEventType
    	   , DupPrograms.CaseType
            , DupPrograms.ProgramName
    	   , DupPrograms.ProgramStatusName
    	   , DupPrograms.StartDate
    	   , DupPrograms.EndDate
    	   , AM.PCP_NAME AS Pcp_Name
    	   , AM.PCP_PRACTICE_NAME
    	   , AM.NPI
    	   , AM.MEMBER_LAST_NAME
    	   , am.MEMBER_FIRST_NAME
    	   , am.MEMBER_HOME_PHONE, am.MEMBER_MAIL_PHONE, am.MEMBER_BUS_PHONE
    	   , am.AhsPlanName
    	   , Am.DATE_OF_BIRTH
    	   , CLIENT.ClientShortName
    	   
    --TREATMENT_TYPE  : CaseType
    --CASE_ID: ????
    
    FROM	  (
        SELECT 
            Ntf.ClientMemberKey, ntf.LoadDate NtfNotificationDate, ntf.AdmitDateTime, ntf.DischargeDisposition 
            , Ntf.ActualDischargeDate, Ntf.AceFollowUpDueDate , ntf.ntfEventType, ntf.CaseType, ntf.DiagnosisDesc, ntf.AdmitHospital
            , pe.ProgramName, pe.ProgramStatusName, pe.StartDate, pe.EndDate
            , Ntf.ntfNotificationKey    
        FROM adw.NtfNotification Ntf	  -- current NTF set
            JOIN ACECAREDW.dbo.tmp_Ahs_ProgramEnrollments PE
        	   ON pe.LoadDate = CONVERT(DATE, GETDATE())
        	   AND pe.ProgramName = 'Transitions of Care- Inpatient'
        	   and Ntf.ClientMemberKey =  pe.ClientMemberKey 
        	   and ntf.LoadDate between pe.StartDate and pe.EndDate
        	   AND pe.ProgramStatusName <> 'CLOSE'
        WHERE ISNULL(Ntf.AceFollowUpDueDate,'') <>''    
            AND Ntf.LoadDate = CONVERT(DATE, GETDATE())
            AND Ntf.CaseType = 'IP' -- ask Clinical if this is correct 
        UNION -- ER
        SELECT      Ntf.ClientMemberKey, ntf.LoadDate NtfNotificationDate, ntf.AdmitDateTime, ntf.DischargeDisposition 
            , Ntf.ActualDischargeDate, Ntf.AceFollowUpDueDate , ntf.ntfEventType, ntf.CaseType, ntf.DiagnosisDesc, ntf.AdmitHospital
            , pe.ProgramName, pe.ProgramStatusName, pe.StartDate, pe.EndDate
            , Ntf.ntfNotificationKey    
        FROM adw.NtfNotification Ntf	  -- current NTF set
            JOIN ACECAREDW.dbo.tmp_Ahs_ProgramEnrollments PE
        	   ON pe.LoadDate = CONVERT(DATE, GETDATE())
        	   AND pe.ProgramName = 'Transitions of Care-Emergency Room'
        	   and Ntf.ClientMemberKey =  pe.ClientMemberKey 
        	   and ntf.LoadDate between pe.StartDate and pe.EndDate
        	   AND pe.ProgramStatusName <> 'CLOSE'
        WHERE ISNULL(Ntf.AceFollowUpDueDate,'') <>''    
            AND Ntf.LoadDate = CONVERT(DATE, GETDATE())
            AND Ntf.CaseType = 'ER' -- ask Clinical if this is correct 
        UNION-- MH
        SELECT       Ntf.ClientMemberKey, ntf.LoadDate NtfNotificationDate, ntf.AdmitDateTime, ntf.DischargeDisposition 
            , Ntf.ActualDischargeDate, Ntf.AceFollowUpDueDate , ntf.ntfEventType, ntf.CaseType, ntf.DiagnosisDesc, ntf.AdmitHospital
            , pe.ProgramName, pe.ProgramStatusName, pe.StartDate, pe.EndDate
            , Ntf.ntfNotificationKey    
        FROM adw.NtfNotification Ntf	  -- current NTF set
            JOIN ACECAREDW.dbo.tmp_Ahs_ProgramEnrollments PE
        	   ON pe.LoadDate = CONVERT(DATE, GETDATE())
        	   AND pe.ProgramName = 'Transitions of Care-Mental Health'
        	   and Ntf.ClientMemberKey =  pe.ClientMemberKey 
        	   and ntf.LoadDate between pe.StartDate and pe.EndDate
        	   AND pe.ProgramStatusName <> 'CLOSE'
        WHERE ISNULL(Ntf.AceFollowUpDueDate,'') <>''    
            AND Ntf.LoadDate = CONVERT(DATE, GETDATE())
            AND Ntf.CaseType = 'MH' -- ask Clinical if this is correct 
    	   ) DupPrograms
        JOIN dbo.vw_ActiveMembers AM
    	   ON DupPrograms.ClientMemberKey = AM.CLIENT_SUBSCRIBER_ID    
        JOIN lst.List_Client Client
    	   ON Am.clientKey = CLient.clientKey


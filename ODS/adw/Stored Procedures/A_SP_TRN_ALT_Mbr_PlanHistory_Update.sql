

CREATE procedure [adw].[A_SP_TRN_ALT_Mbr_PlanHistory_Update]
	   @AltMbrPlanHist_URN INT 
    , @StopDate DATETIME = '12/31/2099'
    , @PlanHistoryStatus INT = 1    
    , @UpdateUser VARCHAR(50) 
AS
    IF (ISNULL(@AltMbrPlanHist_URN, 0) = 0)
	   BEGIN
		  RAISERROR('Invalid parameter: [A_SP_TRN_ALT_Mbr_PlanHistory_Update]: @@AltMbrPlanHist_URN cannot be NULL or zero', 18, 0);
		  RETURN;
	   END;     
    IF (@UpdateUser is null) OR (@UpdateUser = '') SET @UpdateUser = SYSTEM_USER;
	   
    UPDATE [adw].A_ALT_MemberPlanHistory
	   SET [stopDate] = @StopDate
	   ,[planHistoryStatus] = @PlanHistoryStatus
	   ,[A_UPDATED_DATE] = GETDATE()
	   ,[A_UPDATED_BY] = @UpdateUser
 WHERE A_ALT_MemberPlanHistory_ID = @AltMbrPlanHist_URN

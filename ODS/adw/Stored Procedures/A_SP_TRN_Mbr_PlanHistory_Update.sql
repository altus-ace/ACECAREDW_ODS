

CREATE procedure [adw].[A_SP_TRN_Mbr_PlanHistory_Update]
	   @MemPlanHist_URN INT 
    , @StopDate DATETIME = '12/31/2099'
    , @PlanHistoryStatus INT = 1    
    , @UpdateUser VARCHAR(50) 
AS
    IF (ISNULL(@memPlanHist_URN, 0) = 0)
	   BEGIN
		  RAISERROR('Invalid parameter: ACE_SP_INT_UD_MemberPlanHistory: @MemPlanHis_URN cannot be NULL or zero', 18, 0);
		  RETURN;
	   END;     
    IF (@UpdateUser is null) OR (@UpdateUser = '') SET @UpdateUser = SYSTEM_USER;
	   
    UPDATE [adw].[A_Mbr_PlanHistory]
	   SET [stopDate] = @StopDate
	   ,[planHistoryStatus] = @PlanHistoryStatus
	   ,[A_UPDATED_DATE] = GETDATE()
	   ,[A_UPDATED_BY] = @UpdateUser
 WHERE A_Member_Plan_History_ID = @MemPlanHist_URN


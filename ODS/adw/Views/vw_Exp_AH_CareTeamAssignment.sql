CREATE VIEW adw.vw_Exp_AH_CareTeamAssignment
AS 
    SELECT c.CLIENT_ID, 
       c.MEMBER_ID, 
       c.USERNAME, 
       c.CARE_STAFF_ID, 
       c.[INTERNAL/EXTERNAL INDICATOR], 
       c.START_DATE, 
       c.END_DATE
    FROM vw_AH_WC_CareTeamAssignment c;


CREATE VIEW [adw].[vw_Validation_LoadHistoryStatus]
AS
    /* Purpose:  what is the status of the Mbr load history: 
		  what has been loaded into mbr Model
		  */
    SELECT lh.AdiTableName SourceTable,lh.LoadDate, lh.DataDate, lh.CreatedDate, lh.CreatedBy
        , COUNT(lh.mbrLoadHistoryKey) loadRowCount, COUNT(lh.AdiKey) sourcekey    
        , SUM(mbrMemberLoaded.MbrLoaded) ChangedMbrMembers
        , SUM(mbrPlanLoaded.PlnLoaded) ChngdMbrPlans
        , SUM(mbrCsPlanLoaded.CsPlnLoaded) ChngdCsPlans
        , SUM(mbrPcpLoaded.PcpLoaded) ChngdPcpPlans
        , SUM(mbrDemoLoaded.DemoLoaded) ChngdDemo
        , SUM(mbrPhnLoaded.PhnLoaded) ChngdPhone
        , SUM(mbrAddLoaded.AddLoaded) ChngdAddress
    FROM adw.MbrLoadHistory lh
        LEFT JOIN (SELECT m.mbrLoadKey, 1 AS MbrLoaded FROM adw.MbrMember m) as mbrMemberLoaded 
    	   ON lh.mbrLoadHistoryKey = mbrMemberLoaded.mbrLoadKey
        LEFT JOIN (SELECT m.mbrLoadKey, 1 AS PlnLoaded FROM adw.MbrPlan m) as mbrPlanLoaded 
    	   ON lh.mbrLoadHistoryKey = mbrPlanLoaded.mbrLoadKey
        LEFT JOIN (SELECT m.mbrLoadKey, 1 AS CsPlnLoaded FROM adw.mbrCsPlanHistory m) as mbrCsPlanLoaded 
    	   ON lh.mbrLoadHistoryKey = mbrCsPlanLoaded.mbrLoadKey
        LEFT JOIN (SELECT m.mbrLoadKey, 1 AS PcpLoaded FROM adw.MbrPcp m) as mbrPcpLoaded 
    	   ON lh.mbrLoadHistoryKey = mbrPcpLoaded.mbrLoadKey
        LEFT JOIN (SELECT m.mbrLoadKey, 1 AS DemoLoaded FROM adw.MbrDemographic m) as mbrDemoLoaded 
    	   ON lh.mbrLoadHistoryKey = mbrDemoLoaded.mbrLoadKey
        LEFT JOIN (SELECT m.mbrLoadKey, 1 AS PhnLoaded FROM adw.MbrPhone m) as mbrPhnLoaded 
    	   ON lh.mbrLoadHistoryKey = mbrPhnLoaded.mbrLoadKey
        LEFT JOIN (SELECT m.mbrLoadKey, 1 AS AddLoaded FROM adw.MbrAddress m) as mbrAddLoaded 
    	   ON lh.mbrLoadHistoryKey = mbrAddLoaded.mbrLoadKey
    GROUP BY lh.AdiTableName, lh.LoadDate, lh.DataDate, lh.CreatedDate, lh.CreatedBy       
--    ORDER BY lh.AdiTableName, lh.LoadDate DESC, lh.DataDate DESC;

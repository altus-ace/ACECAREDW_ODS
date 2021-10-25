


CREATE VIEW dbo.vw_CC_P11_UhcHighRisk
AS
SELECT 
    1 AS ClientKey
    , 'TOC1' AS PROG_ID
    , 'Newly Enrolled' AS ProgramName
    , GETDATE() AS AssingDate 
    , m.[UHC_SUBSCRIBER_ID] AS MemberID
    , CONVERT(DATE, m.A_LAST_UPDATE_DATE, 101) AS Date_Appeared
    , pl.startDate AS ProgramStartdate
    , DATEADD(day, 90, pl.StartDate) AS ProgramEnddate    
FROM dbo.UHC_MembersByPCP m
    JOIN (SELECT SOURCE_VALUE AS SubGrpID
		  FROM dbo.ALT_MAPPING_TABLES m
		  where m.URN IN (61, 62,63,64,65,66,67,68,69,70, 71)) AS HighRisk ON m.SUBGRP_ID = HighRisk.SubGrpID
    JOIN [adw].[A_Mbr_Members] am ON m.Uhc_subscriber_id = am.Client_Member_ID 
    JOIN  [adw].[A_ALT_MemberPlanHistory] pl ON am.Client_Member_ID = pl.Client_Member_ID



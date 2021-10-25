
CREATE VIEW amd.vw_Get_ETL_PackageExecutionData
AS 
SELECT a.EtlAuditHeader_Pkey AS ExecID
    , a.PackageName AS ETL_Action
--    , a.EtlAudit_Status make usful 1 = completed 0 = in process -1 failded
    , a.InputSourceName AS DataFrom
    , a.DestinationName AS DataTo
    , DATEDIFF(minute, a.ActionStartTime, a.ActionStopTime) AS [ExecTime(Minutes)]
    --, a.InputCount
    , a.DestinationCount
    , CONVERT (VARCHAR(19), a.ActionStartTime) AS StartTime
    , CONVERT (VARCHAR(19), a.ActionStopTime) AS StopTime
FROM amd.ACE_ETL_Audit_Header a
--WHERE a.InputSourceName = 'UHC_CLAIMS'
--ORDER BY a.EtlAuditHeader_Pkey DESC

/*
SELECT *
FROM amd.vw_Get_ETL_PackageExecutionData AS e 
WHERE e.DataFrom = 'UHC_CLAIMS'
ORDER BY e.ExecID DESC
 */



CREATE PROCEDURE [ast].[ValidationDashboard] 


AS 

    
BEGIN    

SELECT src.*
    , CASE WHEN (src.TotalMemberCount <> src.DetailTotalCount) THEN 'Warning Mismatch in summary/detail checksum'
       else '1' END AS SummaryDetailCheckSum
    , CASE WHEN (src.DetailTotalCount <> (src.DetailFailCount + src.DetailPassCount)) THEN 'Warning Mismatch in detail total/pass/fail checksum'
       else '1' end As DetailPasFailChecksum
FROM (select distinct v.ClientKey    ,v.LoadDate    ,v.Active    ,d.TestCase
        ,v.AsOfDate    ,v.createdDate    , CASE WHEN (dfc.DetailFailCount is null) then 0 ELSE dfc.DetailFailCount END AS DetailFailCount    ,dpc.DetailPassCount
        ,dtc.DetailTotalCount    ,v.TotalMemberCount
    from amd.AceValidationrunsummary v
    join amd.AceValidationDetails d on v.skey =d.SummarySkey
    LEFT join (select count(*) DetailPassCount,pc.SummarySkey 
    		  From Amd.AceValidationDetails pc 
    		  where pc.[TestResultStatus] =1 
    		  group by SummarySkey    
         ) dpc on v.skey=dpc.SummarySkey
    LEFT join (select count(*) DetailTotalCount,tc.SummarySkey 
            From Amd.AceValidationDetails  tc group by SummarySkey
         ) dtc on v.skey=dtc.SummarySkey
    LEFT join (select count(*) DetailFailCount,fc.SummarySkey 
            From Amd.AceValidationDetails fc where fc.[TestResultStatus] =2 group by SummarySkey
         ) dfc on v.skey=dfc.SummarySkey

    ) AS src


END

 create view vw_FeeTrendAnalysisByMbrContinuous
  as 
  select a.*

      ,b.[2017-01-01]
      ,b.[2017-02-01]
      ,b.[2017-03-01]
      ,b.[2017-04-01]
      ,b.[2017-05-01]
      ,b.[2017-06-01]
      ,b.[2017-07-01]
      ,b.[2017-08-01]
      ,b.[2017-09-01]
      ,b.[2017-10-01]
      ,b.[2017-11-01]
      ,b.[2017-12-01]
      ,b.[2018-01-01]
      ,b.[2018-02-01]
      ,b.[2018-03-01]
      ,b.[2018-04-01]
      ,b.[2018-05-01]
      ,b.[2018-06-01]
      ,b.[2018-07-01]
      ,b.[2018-08-01]
      ,b.[2018-09-01]


   from [ACECAREDW].[dbo].[tmp_mbr_mth_fee] a join acecaredw_test.dbo.vw_pivotMthCost b on a.subscriber_id = b.subscriber_id  
 -- truncate table [ACECAREDW].[dbo].[tmp_mbr_mth_fee]
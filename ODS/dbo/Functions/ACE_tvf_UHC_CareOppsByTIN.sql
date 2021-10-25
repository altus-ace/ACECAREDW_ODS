

CREATE  FUNCTION [dbo].[ACE_tvf_UHC_CareOppsByTIN]
 
(	@anchor_mth int, @anchor_Year int
)
RETURNS TABLE 
As
RETURN
(	
select 
a.PCP_PRACTICE_TIN as TIN_Number,	
b.TIN_Name as Group_Name,
a.Measure_Description,
a.Sub_Meas,
a.Adherent,
a.NonAdherent,
a.Total,
a.Rate,
a.Target as Target_Goal,
a.GapsToTarget as Gaps_To_Meet_Goal,
a.Context

FROM [ACECAREDW].[dbo].[UHC_CareOppsByTIN]a
left join (
SELECT distinct [TIN_Num]
      ,[TIN_Name]
     , memberID
  FROM [ACECAREDW].[dbo].[UHC_CareOpps]) b on a.PCP_PRACTICE_TIN = b.TIN_Num
where month(A_LAST_UPDATE_DATE )= @anchor_mth and 
year(a_last_update_date)=@anchor_Year and b.memberID in (select distinct MEMBER_ID from [ACECAREDW].[dbo].[vw_UHC_ActiveMembers])
)

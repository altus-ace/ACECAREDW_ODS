
CREATE view [dbo].[yy_vw_FEEDER_STJOSEPH_NETWORK]
as
select distinct npi, max([primaryzipcode]) as zip , (LastName + ',' + FirstName) AS ProviderName,  'PCP' as typpe 
from [dbo].[vw_AllClient_ProviderRoster] 
group by npi, LastName , FirstName
union 
SELECT distinct([NPI])
      
      ,[PRIMARY ZIPCODE] as zip
	  ,[LAST NAME] + ',' + [FIRST NAME] as ProviderName
      ,'SPECIALIST' as typpe
	  FROM [ACECAREDW].[dbo].[vw_Specialist_ProviderRoster]

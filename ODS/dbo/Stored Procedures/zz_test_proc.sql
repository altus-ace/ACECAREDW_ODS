CREATE procedure [zz_test_proc]
@startdate as date 
as 
begin 
set nocount on; 
select * 
from UHC_CareOpps
where [A_LAST_UPDATE_DATE] >= @startdate




end

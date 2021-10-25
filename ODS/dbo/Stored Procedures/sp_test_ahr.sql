CREATE procedure sp_test_ahr
@npi varchar(40)
as
select distinct a.UHC_SUBSCRIBER_ID, a.pcp_npi , b.Measure_Desc, b.Sub_Meas     
 from  vw_UHC_ActiveMembers a left join UHC_CareOpps b on a.UHC_SUBSCRIBER_ID = b.MemberID
 where a.pcp_npi = @npi and b.Measure_Desc is not null
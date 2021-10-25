create view vw_freq_diag_1_and_2 as
select a.member_id, a.freq1,b.freq1code, a.freq2,b.freq2code, a.freq3,b.freq3code, a.freq4,b.freq4code, a.freq5,b.freq5code  from acecaredw_test.dbo.vw_frequent_diagcodename_pivot b
join acecaredw_test.dbo.vw_frequent_diagcode_pivot a on a.member_id = b.member_id
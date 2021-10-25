--EXEC sp_ABA 2018, 'UHC'


create procedure sp_ABA
@years int,
@LOB varchar(20)
as
declare @year int = @years
declare @QM varchar(10) = 'ABA'
declare @RUNDATE date = getdate()
declare @RUNTIME datetime = getdate()

declare @table1 as table (SUBSCRIBER_ID varchar(20))
declare @table2 as table (SUBSCRIBER_ID varchar(20))
declare @tableden as table (SUBSCRIBER_ID varchar(20))
declare @tablenumt as table (SUBSCRIBER_ID varchar(20))
declare @tablenum as table (SUBSCRIBER_ID varchar(20))
declare @tablecareop as table (SUBSCRIBER_ID varchar(20))


insert into @table1
select SUBSCRIBER_ID from 
[tvf_get_active_members2](concat('1/1/',@year-1)) 
where AGE>=18
intersect
select SUBSCRIBER_ID from 
[tvf_get_active_members2](concat('12/31/',@year)) 
where AGE<=74




insert into @table2
SELECT DISTINCT subscriber_id
	FROM [tvf_get_claims_w_dates]('Outpatient', '', '', concat('1/1/',@year-1), concat('12/31/',@year))


insert into @tableden 
select a.* from @table1 a join @table2 b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID









DELETE FROM @table1
DELETE FROM @table2





insert into @table1 
SELECT DISTINCT A.subscriber_id
FROM [tvf_get_claims_w_dates]('BMI', '', '',  concat('1/1/',@year-1), concat('12/31/',@year)) A
WHERE CASE
          WHEN A.[SUBSCRIBER_ID] IN
		  (
		      SELECT B.subscriber_id
		      FROM [tvf_get_age2](20, 74, CONVERT(VARCHAR, CONVERT(DATETIME,A.PRIMARY_SVC_DATE), 101)) B
		  )
          THEN 1
          ELSE 0
      END = 1


insert into @table2 
SELECT DISTINCT A.subscriber_id--, A.seq_claim_id, a.PRIMARY_SVC_DATE
FROM [tvf_get_claims_w_dates]('BMI Percentile', '', '',  concat('1/1/',@year-1), concat('12/31/',@year)) A
WHERE CASE
          WHEN A.[SUBSCRIBER_ID] IN
		  (
		      SELECT B.subscriber_id
		      FROM [tvf_get_age2](0, 19, CONVERT(VARCHAR, CONVERT(DATETIME,A.PRIMARY_SVC_DATE), 101)) B
		  )
          THEN 1
          ELSE 0
      END = 1



insert into @tablenumt
select * from @table1
union 
select * from @table2






insert into @tablenum
select a.* from @tablenumt a 
intersect select b.* from @tableden  b



insert into @tablecareop
select a.* from @tableden a left join @tablenum b on a.SUBSCRIBER_ID = b.SUBSCRIBER_ID where b.SUBSCRIBER_ID is null 





Insert into [QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'DEN' ,@RUNDATE ,@RUNTIME from @tableden


Insert into [QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'NUM' ,@RUNDATE,@RUNTIME from @tablenum


Insert into [QM_ResultByMember_History]([ClientMemberKey],[QmMsrId],[QmCntCat],[QMDate],[CreateDate])
select *, @QM , 'COP' ,@RUNDATE ,@RUNTIME from @tablecareop
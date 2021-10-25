  create view vw_remain_geo_location 
  as
  select distinct subscriber_id, a.Address   from (
  select distinct SUBSCRIBER_ID  ,concat(M_Address_Line1_Res,
      ' ',M_Address_Line2_Res,
      ' ',M_City_Res,
      ' ',M_State_Res,
      ' ',M_Zip_Code_Res) as Address
	 ,cast(  CONVERT(varchar(10), mbr_year) + '-' +  CONVERT(varchar(10), mbr_mth) + '-01' as date) time 
	  , dense_rank() over (partition by subscriber_id order by cast(  CONVERT(varchar(10), mbr_year) + '-' +  CONVERT(varchar(10), mbr_mth) + '-01' as date) desc ) as rank
    from acecareDW_TEST.dbo.M_MEMB_ENR
	) a  left join acecaredw.dbo.r_test2 b on a.SUBSCRIBER_ID = b.member_id  where a.rank = 1 
	and b.member_id is null
					
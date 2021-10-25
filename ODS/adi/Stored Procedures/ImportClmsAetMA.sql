-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportClmsAetMA](
    @OriginalFileName varchar(100) ,
	@SrcFileName varchar(100) ,
	--@LoadDate date NOT ,
	--CreatedDate date NOT ,
	@CreatedBy varchar(50),
	--LastUpdatedDate datetime NOT ,
	@LastUpdatedBy varchar(50),
	@ps_unique_id [varchar](16) NULL,
	@customer_nbr [varchar](8) NULL,
	@group_nbr  [varchar](8) NULL,
	@filler [char](3) NULL,
	@subgroup_nbr [varchar](8) NULL,
	@account_nbr [char](5) NULL,
	@product_ln_cd [char](2) NULL,
	@plan_id [char](5) NULL,
	@ee_id [varchar](11) NULL,
	@ee_last_name [varchar](30) NULL,
	@ee_first_name [varchar](30) NULL,
	@subs_zip_cd [varchar](5) NULL,
	@ssn_nbr [varchar](11) NULL,
	@member_id [varchar](20) NULL,
	@src_member_id [varchar](18) NULL,
	@last_name [varchar](30) NULL,
	@first_name [varchar](30) NULL,
	@src_mbr_gender_cd [char](1) NULL,
	@mbr_rpt_type_cd [char](1) NULL,
	@birth_dt varchar(10),
	@cap_cycle_dt varchar(10),
	@payment_type_cd [varchar](2) NULL,
	@spclty_grp_cd [varchar](5) NULL,
	@mbr_tot_cap_amt varchar(20),
	@cap_retro_amt varchar(20),
	@tax_id_nbr [varchar](9) NULL,
	@npi_nbr [varchar](10) NULL,
	@epdb_dw_prvdr_id [varchar](7) NULL,
	@print_nm [varchar](40) NULL,
	@address_line_1_txt [varchar](35) NULL,
	@address_line_2_txt [varchar](35) NULL,
	@city_nm [varchar](30) NULL,
	@state_postal_cd [varchar](2) NULL,
	@zip_cd [varchar](5) NULL,
    @specialty_ctg_cd [varchar](4) NULL,
	@SpaceForGrowth [varchar](89) NULL,
	@ORG_CDL [varchar](100) NULL,
	@EndofMark [char](1) NULL
   
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 EXEC [ACDW_CLMS_AET_MA].[adi].[ImportClmsAetMA]
  @OriginalFileName ,
	@SrcFileName  ,
	--@LoadDate date NOT ,
	--CreatedDate date NOT ,
	@CreatedBy ,
	--LastUpdatedDate datetime NOT ,
	@LastUpdatedBy ,
	@ps_unique_id,
	@customer_nbr,
	@group_nbr ,
	@filler ,
	@subgroup_nbr ,
	@account_nbr,
	@product_ln_cd ,
	@plan_id ,
	@ee_id ,
	@ee_last_name ,
	@ee_first_name ,
	@subs_zip_cd ,
	@ssn_nbr ,
	@member_id ,
	@src_member_id ,
	@last_name ,
	@first_name ,
	@src_mbr_gender_cd ,
	@mbr_rpt_type_cd ,
	@birth_dt ,
	@cap_cycle_dt ,
	@payment_type_cd ,
	@spclty_grp_cd ,
	@mbr_tot_cap_amt ,
	@cap_retro_amt ,
	@tax_id_nbr ,
	@npi_nbr ,
	@epdb_dw_prvdr_id ,
	@print_nm ,
	@address_line_1_txt ,
	@address_line_2_txt ,
	@city_nm ,
	@state_postal_cd ,
	@zip_cd ,
    @specialty_ctg_cd ,
	@SpaceForGrowth ,
	@ORG_CDL ,
	@EndofMark 
   
END





-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert enrollment Membership_Enrollment file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportMembershipEnrollment]
    @Devoted_Member_ID varchar(50),
	@Member_First_Name varchar(50),
	@Member_Last_Name varchar(50),
	@Member_Date_Of_Birth varchar(10) ,
	@Member_Address_Line_1 varchar(100),
	@Member_Address_Line_2 varchar(100),
	@Member_City varchar(50) ,
	@Member_State varchar(10),
	@Member_Zip varchar(10),
	@Member_County varchar(50) ,
	@Member_County_ID varchar(50) ,
	@Member_Phone varchar(20) ,
	@Member_Language varchar(50),
	@Member_Gender char(1) ,
	@Member_ESRD_Indicator varchar(10) ,
	@MBI_or_HICN varchar(50) ,
	@Member_HICNs varchar(20) ,
	@Plan_Name VARCHAR(100),
	@CMS_Contract_PBP varchar(20) ,
	@Line_Of_Business varchar(50) ,
	@Member_Dual_Eligible_Flag varchar(20) ,
	@Practice_Name varchar(100) ,
	@Devoted_PCP_ID varchar(20) ,
	@PCP_NPI varchar(20), 
	@PCP_Name varchar(100) ,
	@PCPAddressLine1 varchar(100) ,
	@PCPAddressLine2 varchar(100) ,
	@PCPCity varchar(50) ,
	@PCPState varchar(50) ,
	@PCPCounty varchar(50) ,
	@PCPZipCode varchar(20) ,
	@PCP_Effective_Date varchar(10) ,
	@PCP_End_Date varchar(10) ,
	@Coverage_Effective_Date varchar(10) ,
	@Coverage_End_Date varchar(10) ,
	@Devoted_Contracting_Group_ID varchar(50) ,
	@Devoted_Contracting_Group_Name varchar(50) ,
	@Member_Status varchar(50) ,
	@File_Date varchar(20) ,
	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
	@DataDate varchar(10),
	--@CreateDate  ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100),
	@LastUpdatedDate varchar(100)
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--UPDATE adi.[stg_claims] 
	--SET FirstName = @FirstName,
	--    LastName = @LastName

 --   WHERE SUBSCRIBER_ID = @SUBSCRIBER_ID
--	and 
  EXEC [ACDW_CLMS_DHTX].[adi].[ImportMembershipEnrollment]
    @Devoted_Member_ID ,
	@Member_First_Name,
	@Member_Last_Name ,
	@Member_Date_Of_Birth ,
	@Member_Address_Line_1 ,
	@Member_Address_Line_2 ,
	@Member_City  ,
	@Member_State ,
	@Member_Zip ,
	@Member_County ,
	@Member_County_ID ,
	@Member_Phone ,
	@Member_Language ,
	@Member_Gender ,
	@Member_ESRD_Indicator ,
	@MBI_or_HICN  ,
	@Member_HICNs  ,
	@Plan_Name,
	@CMS_Contract_PBP  ,
	@Line_Of_Business  ,
	@Member_Dual_Eligible_Flag  ,
	@Practice_Name  ,
	@Devoted_PCP_ID  ,
	@PCP_NPI , 
	@PCP_Name ,
	@PCPAddressLine1  ,
	@PCPAddressLine2  ,
	@PCPCity  ,
	@PCPState ,
	@PCPCounty  ,
	@PCPZipCode  ,
	@PCP_Effective_Date  ,
	@PCP_End_Date  ,
	@Coverage_Effective_Date ,
	@Coverage_End_Date ,
	@Devoted_Contracting_Group_ID ,
	@Devoted_Contracting_Group_Name ,
	@Member_Status ,
	@File_Date ,
	@SrcFileName ,
	@FileDate ,
	@DataDate ,
	--@CreateDate  ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy,
	@LastUpdatedDate




END
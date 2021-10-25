﻿-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[sp_ImportMbrAetCom](
   @SrcFileName varchar(100),
  -- @LoadDate varchar(10),
   @DataDate varchar(10),
  -- @CreatedDate date,
   @CreatedBy varchar(50),
 --  @LastUpdatedDate varchar(10),
   @LastUpdatedBy varchar(50),
   @MEMBER_ID varchar(20),
   @EffectiveMonth varchar(10),
   @Prefix_Name varchar(5) ,
   @LastName varchar(30) ,
   @Member_First_Name varchar(30) ,
   @Member_Suffix_Name varchar(5) ,
   @Member_Gender char(1) ,
   @Member_Date_of_Birth date,
   @Member_Address_Line1 varchar(35),
   @Member_Address_Line2 varchar(35),
   @Member_City varchar(30),
   @Member_State char(2),
   @Member_County_Code varchar(5),
   @Member_Zipcode varchar(5),
   @Member_PhoneNum varchar(10),
   @Member_Source_Member_ID varchar(22),
   @Member_Relationship_to_Employee char(1),
   @Members_SSN varchar(11),
   @ps_unique_id varchar(16),
   @customer_nbr varchar(8) ,
   @group_nbr varchar(8),
   @subgroup_nbr varchar(8),
   @account_nbr varchar(5),
   @Employee_Last_Name varchar(30),
   @Employee_First_Name_or_Initial varchar(30),
   @Employee_Gender char(1),
   @Employee_Date_of_Birth varchar(10),
   @Employee_Zip_Code varchar(5),
   @Employee_State char(2),
	@Employee_County_Code varchar(5) ,
	@Employee_SSN varchar(11),
	@Source_System_Platform char(2) ,
	@General_Category_of_Health_Plan char(2),
	@Line_of_Business char(2) ,
	@Funding_Arrangement char(1),
	@Coverage_Type_Code char(1),
	@Network_Identifier varchar(5),
	@Customer_Segment char(3),
	@Medical_Indicator char(1) ,
	@Drug_Indicator char(1),
	@Substance_Abuse_Indicator char(1),
	@Mental_Health_Indicator char(1),
	@Individual_Original_Effective_date_at_Aetna varchar(10),
	@PCP_Provider_Tax_ID_Number_TIN varchar(9),
	@PCP_Provider_PIN varchar(7),
	@PCP_Provider_Name_Last_or_Full varchar(40) ,
	@PCP_Provider_Street_Address_1 varchar(35) ,
	@PCP_Provider_Street_Address_2 varchar(35),
	@PCP_Provider_City varchar(30),
	@PCP_Provider_State varchar(2) ,
	@PCP_Provider_Zip_Code varchar(5),
	@PCP_Provider_NPI_Number varchar(22),
	@PCP_Provider_Specialty_Code varchar(5),
	@Organization_ID varchar(10),
	@From_attribution_date_of_first_visit varchar(10),
--	date ,
	@From_attribution_date_of_last_visit varchar(10),
	--date,
	@From_attribution_number_of_visits int,
	@Attributed_Provider_Tax_ID_Number_TIN varchar(9),
	@Attributed_Provider_PIN varchar(7),
	@Attributed_Provider_Name_Last_or_Full varchar(40),
	@Attributed_Provider_Street_Address_1 varchar(35),
	@Attributed_Provider_Street_Address_2 varchar(35),
	@Attributed_Provider_City varchar(30),
	@Attributed_Provider_State char(2) ,
	@Attributed_Provider_Zip_Code varchar(5) ,
	@Attributed_Provider_NPI_Number varchar(22) ,
	@Attributed_Provider_Specialty_Code varchar(5),
	@Attribution_Record_status char(1),
	@Attribution_Original_Effective_Date varchar(10),
	--date,
	@Attribution_Cancel_Date varchar(10),
	--date,
	@Member_Cumb_ID varchar(22),
	@Employe_Cumb_ID varchar(22),
	@Middle_Name varchar(11),
	@Individual_ID varchar(20),
	@Pulse_score_Point_in_time varchar(5),
	@ERGProspective_score_point_in_time varchar(5),
	@ERG_Retrospective_score_point_in_time varchar(5),
	@Aetna_Line_of_Business varchar(2),
	@Aetna_Card_ID varchar(20),
	@Employer_Name varchar(40),
	@Current_Record_Indicator varchar(1),
	@Sequence_Number varchar(11),
	@Duplicate_Indicator varchar(1),
	@Attribution_Type varchar(3),
	@Risk varchar(3),
	@Organization_Code varchar(10),
	@PLAN_ID varchar(5),
	@Hcontract_PBP_ID varchar(10),
	@End_of_record_marker varchar(11) 
  
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--UPDATE [adi].[MbrAetCom]
--	SET [MEMBER_ID]  =  @MEMBER_ID 

  --  WHERE  MEMBER_ID = @MEMBER_ID

	 
--	IF @@ROWCOUNT = 0

    -- Insert statements for procedure here
 INSERT INTO [adi].[MbrAetCom]
   (
   [SrcFileName],
    [LoadDate] ,
	[DataDate],
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate],
	[LastUpdatedBy],
	[MEMBER_ID] ,
	[EffectiveMonth],
	[Prefix_Name],
	[LastName],
	[Member_First_Name] ,
	[Member_Suffix_Name] ,
	[Member_Gender],
	[Member_Date_of_Birth],
	[Member_Address_Line1],
	[Member_Address_Line2],
	[Member_City],
	[Member_State],
	[Member_County_Code] ,
	[Member_Zipcode],
	[Member_PhoneNum],
	[Member_Source_Member_ID] ,
	[Member_Relationship_to_Employee] ,
	[Members_SSN],
	[ps_unique_id],
	[customer_nbr],
	[group_nbr],
	[subgroup_nbr],
	[account_nbr] ,
	[Employee_Last_Name] ,
	[Employee_First_Name_or_Initial] ,
	[Employee_Gender] ,
	[Employee_Date_of_Birth] ,
	[Employee_Zip_Code] ,
	[Employee_State] ,
	[Employee_County_Code] ,
	[Employee_SSN] ,
	[Source_System_Platform],
	[General_Category_of_Health_Plan],
	[Line_of_Business] ,
	[Funding_Arrangement] ,
	[Coverage_Type_Code] ,
	[Network_Identifier] ,
	[Customer_Segment] ,
	[Medical_Indicator] ,
	[Drug_Indicator] ,
	[Substance_Abuse_Indicator] ,
	[Mental_Health_Indicator] ,
	[Individual_Original_Effective_date_at_Aetna] ,
	[PCP_Provider_Tax_ID_Number_TIN] ,
	[PCP_Provider_PIN],
	[PCP_Provider_Name_Last_or_Full],
	[PCP_Provider_Street_Address_1] ,
	[PCP_Provider_Street_Address_2] ,
	[PCP_Provider_City] ,
	[PCP_Provider_State] ,
	[PCP_Provider_Zip_Code] ,
	[PCP_Provider_NPI_Number] ,
	[PCP_Provider_Specialty_Code] ,
	[Organization_ID],
	[From_attribution_date_of_first_visit],
	[From_attribution_date_of_last_visit],
	[From_attribution_number_of_visits],
	[Attributed_Provider_Tax_ID_Number_TIN] ,
	[Attributed_Provider_PIN] ,
	[Attributed_Provider_Name_Last_or_Full] ,
	[Attributed_Provider_Street_Address_1] ,
	[Attributed_Provider_Street_Address_2] ,
	[Attributed_Provider_City] ,
	[Attributed_Provider_State] ,
	[Attributed_Provider_Zip_Code],
	[Attributed_Provider_NPI_Number],
	[Attributed_Provider_Specialty_Code] ,
	[Attribution_Record_status] ,
	[Attribution_Original_Effective_Date] ,
	[Attribution_Cancel_Date],
	[Member_Cumb_ID] ,
	[Employe_Cumb_ID] ,
	[Middle_Name] ,
	[Individual_ID] ,
	[Pulse_score_Point_in_time] ,
	[ERGProspective_score_point_in_time],
	[ERG_Retrospective_score_point_in_time] ,
	[Aetna_Line_of_Business] ,
	[Aetna_Card_ID] ,
	[Employer_Name] ,
	[Current_Record_Indicator] ,
	[Sequence_Number] ,
	[Duplicate_Indicator] ,
	[Attribution_Type] ,
	[Risk] ,
	[Organization_Code],
	[PLAN_ID],
	[Hcontract_PBP_ID],
	[End_of_record_marker],
	[OriginalFileName]


   )
     VALUES
   (
    @SrcFileName ,
	DATEADD(mm, DATEDIFF(mm,0, GETDATE()), 0),
  --CONVERT(date, AceMetaData.adi.udf_GetCleanString(@DataDate)) ,
   CONVERT(DATE, @DataDate),
  -- CONVERT(date, RIGHT( Substring(@SrcFileName,1, (PATINDEX('%.txt%', @SrcFileName)-1)), 8)),   --  @DataDate ,
   GETDATE(), -- @CreatedDate date,
   @CreatedBy ,
   GETDATE(),    --@LastUpdatedDate,
   @LastUpdatedBy ,
   AceMetaData.adi.udf_GetCleanString(@MEMBER_ID) ,
   AceMetaData.adi.udf_GetCleanString(@EffectiveMonth) ,
   AceMetaData.adi.udf_GetCleanString(@Prefix_Name) ,
   AceMetaData.adi.udf_GetCleanString(@LastName)  ,
   AceMetaData.adi.udf_GetCleanString(@Member_First_Name),
   AceMetaData.adi.udf_GetCleanString(@Member_Suffix_Name) ,
   AceMetaData.adi.udf_GetCleanString(@Member_Gender),
   --AceMetaData.adi.udf_GetCleanDate (AceMetaData.adi.udf_GetCleanString(@Member_Date_of_Birth)),
   CONVERT(date, AceMetaData.adi.udf_GetCleanString(@Member_Date_of_Birth)) ,
   AceMetaData.adi.udf_GetCleanString(@Member_Address_Line1) ,
   AceMetaData.adi.udf_GetCleanString(@Member_Address_Line2) ,
   AceMetaData.adi.udf_GetCleanString(@Member_City) ,
   AceMetaData.adi.udf_GetCleanString(@Member_State) ,
   AceMetaData.adi.udf_GetCleanString(@Member_County_Code) ,
   AceMetaData.adi.udf_GetCleanString(@Member_Zipcode) ,
   AceMetaData.adi.udf_GetCleanString(@Member_PhoneNum) ,
   AceMetaData.adi.udf_GetCleanString(@Member_Source_Member_ID) ,
   AceMetaData.adi.udf_GetCleanString(@Member_Relationship_to_Employee) ,
   AceMetaData.adi.udf_GetCleanString(@Members_SSN) ,
   AceMetaData.adi.udf_GetCleanString(@ps_unique_id) ,
   AceMetaData.adi.udf_GetCleanString(@customer_nbr)  ,
   AceMetaData.adi.udf_GetCleanString(@group_nbr) ,
   AceMetaData.adi.udf_GetCleanString(@subgroup_nbr) ,
   AceMetaData.adi.udf_GetCleanString(@account_nbr) ,
   AceMetaData.adi.udf_GetCleanString(@Employee_Last_Name) ,
   AceMetaData.adi.udf_GetCleanString(@Employee_First_Name_or_Initial) ,
   AceMetaData.adi.udf_GetCleanString(@Employee_Gender) ,
   --AceMetaData.adi.udf_GetCleanDate(
   AceMetaData.adi.udf_GetCleanString(@Employee_Date_of_Birth),
   --),
   AceMetaData.adi.udf_GetCleanString(@Employee_Zip_Code) ,
   AceMetaData.adi.udf_GetCleanString(@Employee_State) ,
   AceMetaData.adi.udf_GetCleanString(@Employee_County_Code) ,
   AceMetaData.adi.udf_GetCleanString(@Employee_SSN) ,
   AceMetaData.adi.udf_GetCleanString(@Source_System_Platform)  ,
   AceMetaData.adi.udf_GetCleanString(@General_Category_of_Health_Plan) ,
   AceMetaData.adi.udf_GetCleanString(@Line_of_Business)  ,
   AceMetaData.adi.udf_GetCleanString(@Funding_Arrangement) ,
	AceMetaData.adi.udf_GetCleanString(@Coverage_Type_Code) ,
	AceMetaData.adi.udf_GetCleanString(@Network_Identifier) ,
	AceMetaData.adi.udf_GetCleanString(@Customer_Segment) ,
	AceMetaData.adi.udf_GetCleanString(@Medical_Indicator)  ,
	AceMetaData.adi.udf_GetCleanString(@Drug_Indicator) ,
	AceMetaData.adi.udf_GetCleanString(@Substance_Abuse_Indicator) ,
	AceMetaData.adi.udf_GetCleanString(@Mental_Health_Indicator) ,
	--AceMetaData.adi.udf_GetCleanDate(
	AceMetaData.adi.udf_GetCleanString(@Individual_Original_Effective_date_at_Aetna),
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_Tax_ID_Number_TIN) ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_PIN) ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_Name_Last_or_Full)  ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_Street_Address_1)  ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_Street_Address_2) ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_City) ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_State)  ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_Zip_Code) ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_NPI_Number) ,
	AceMetaData.adi.udf_GetCleanString(@PCP_Provider_Specialty_Code) ,
	AceMetaData.adi.udf_GetCleanString(@Organization_ID) ,
	CONVERT(date, AceMetaData.adi.udf_GetCleanString(@From_attribution_date_of_first_visit)),
	--AceMetaData.adi.udf_GetCleanDate(AceMetaData.adi.udf_GetCleanString(@From_attribution_date_of_first_visit)),
	CONVERT(date, AceMetaData.adi.udf_GetCleanString(@From_attribution_date_of_last_visit)),
	--AceMetaData.adi.udf_GetCleanDate(AceMetaData.adi.udf_GetCleanString(@From_attribution_date_of_last_visit)),
	AceMetaData.adi.udf_GetCleanString(@From_attribution_number_of_visits) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_Tax_ID_Number_TIN) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_PIN) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_Name_Last_or_Full) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_Street_Address_1) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_Street_Address_2) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_City) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_State)  ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_Zip_Code)  ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_NPI_Number) ,
	AceMetaData.adi.udf_GetCleanString(@Attributed_Provider_Specialty_Code) ,
	AceMetaData.adi.udf_GetCleanString(@Attribution_Record_status),
	CONVERT(date, AceMetaData.adi.udf_GetCleanString(@Attribution_Original_Effective_Date)),
	--AceMetaData.adi.udf_GetCleanDate(AceMetaData.adi.udf_GetCleanString(@Attribution_Original_Effective_Date)),
	CONVERT(date, AceMetaData.adi.udf_GetCleanString(@Attribution_Cancel_Date)),
	--AceMetaData.adi.udf_GetCleanDate(AceMetaData.adi.udf_GetCleanString(@Attribution_Cancel_Date)),
	AceMetaData.adi.udf_GetCleanString(@Member_Cumb_ID) ,
	AceMetaData.adi.udf_GetCleanString(@Employe_Cumb_ID) ,
	AceMetaData.adi.udf_GetCleanString(@Middle_Name) ,
	AceMetaData.adi.udf_GetCleanString(@Individual_ID) ,
	AceMetaData.adi.udf_GetCleanString(@Pulse_score_Point_in_time) ,
	AceMetaData.adi.udf_GetCleanString(@ERGProspective_score_point_in_time) ,
	AceMetaData.adi.udf_GetCleanString(@ERG_Retrospective_score_point_in_time) ,
	AceMetaData.adi.udf_GetCleanString(@Aetna_Line_of_Business) ,
	AceMetaData.adi.udf_GetCleanString(@Aetna_Card_ID) ,
	AceMetaData.adi.udf_GetCleanString(@Employer_Name) ,
	AceMetaData.adi.udf_GetCleanString(@Current_Record_Indicator) ,
	AceMetaData.adi.udf_GetCleanString(@Sequence_Number) ,
	AceMetaData.adi.udf_GetCleanString(@Duplicate_Indicator) ,
	AceMetaData.adi.udf_GetCleanString(@Attribution_Type) ,
	AceMetaData.adi.udf_GetCleanString(@Risk) ,
	AceMetaData.adi.udf_GetCleanString(@Organization_Code) ,
	@PLAN_ID,
	@Hcontract_PBP_ID,
	AceMetaData.adi.udf_GetCleanString(@End_of_record_marker) ,
	Substring(@SrcFileName, 1, PATINDEX('%.txt%', @SrcFileName )) + 'txt'
   );
END

--select CONVERT(date, RIGHT( Substring('ALTUS_AETACOE6_202002_202003182.txt_0778',1, (PATINDEX('%.txt%', 'ALTUS_AETACOE6_202002_202003182.txt_0778')-1)), 8))
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[sp_ImportcopUhcPcorPlusAudit_8](  

--ALTER PROCEDURE [adi].[sp_copUhcPcor_8](
    @GroupName varchar(100),
	@Physician varchar(100),
	@PhysicianAddress varchar(100),
	@FirstName varchar(100),
	@LastName varchar(100),
	@MemberID varchar(50),
	@DOB date ,
	@Phone varchar(25),
	@MemberAddress varchar(100),
	@MemberState varchar(25),
	@MemberZip varchar(15),
	@DateOfLastService date,
	@IncentiveProgram varchar(50),
	@CareScore varchar(10),
	@FUH_FollowUpHospMentalIllness_30 varchar(3),
	@FUH_FollowUpAfterHospMentIllness7Day varchar(3),
	@FUH_FollowUpHospMentalIllness_30_6_17_years varchar(3),
	@FUH_FollowUpHospMentalIllness_30_18_64_years varchar(3),
	@FUH_FollowUpHospMentalIllness_30_65_years varchar(3),
	@FUH_FollowUpAfterHospMentIllness7Day_6_17_years varchar(3),
	@FUH_FollowUpAfterHospMentIllness7Day_18_64_years varchar(3),
	@FUH_FollowUpAfterHospMentIllness7Day_65_years varchar(3),
	@PPC_PostPartumCare varchar(3),
	@PPC_TimelinessPrenatalCare varchar(3),
	@ADD_FollowUpCareChild_ADHD_ContMaintPhase varchar(3),
	@ADD_FollowUpCareChild_ADHD_InitiationPhase varchar(3),
	@AWC_AdolescentWellCareVisits varchar(3),
	@BCS_BreastCancerScreening varchar(3),
	@CAP_ChildrenAdolescentsAccessPrimaryCare varchar(3),
	@CBP_ControllingHighBloodPressure varchar(3),
	@CCS_CervicalCancerScreening varchar(3),
	@CDC_CompDiabetesCareHbA1cControl varchar(3),
	@CDC_CompDiabetesCareHbA1cPoorControl varchar(3),
	@CIS_ChildImmunizationStatusComb10 varchar(3),
	@CTM_STWAWC_AdolescentWellCareVisits varchar(3),
    @SSD_DiabetesScreeningSchizophreniaBipolar varchar(3),
	@URI_ChildUpperRespInf varchar(3),
	@W15_WellChildVisitsFirst_15_Months varchar(3),
	@W34_WellChildVisits_3_6_Years varchar(3),
	@WCC_WeightCounselingChildBMIPercentile varchar(3),
	@WCC_WeightCounselingChildNutrition varchar(3),
	@WCC_WeightCounselingChildPhysicalActivity varchar(3),
	@HealthPlanName varchar(20),
	@Product varchar(50),
	@loadDate date,
	@DataDate date,
	@SrcFileName varchar(100),
	@CreatedDate date,
	@CreatedBy varchar(50),
	@LastUpdatedDate date,
	@LastUpdatedBy varchar(50)
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	-- ADD ACE ETL AUDIT
	DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2, @ActionStopDateTime as datetime2
	
	SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';
--	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR',  @ActionStartDateTime , 'Test', '[ACECARDW].[adi].[copUhcPcor]', '' ;



 IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN TRY
 INSERT INTO [adi].[copUhcPcor]
   (

   	[GroupName],
	[Physician] ,
	[PhysicianAddress] ,
	[FirstName] ,
	[LastName] ,
	[MemberID] ,
	[DOB] ,
	[Phone] ,
	[MemberAddress] ,
	[MemberState] ,
	[MemberZip] ,
	[DateOfLastService] ,
	[IncentiveProgram] ,
	[CareScore] ,
	[FUH_FollowUpHospMentalIllness_30],
	[FUH_FollowUpAfterHospMentIllness7Day] ,

	[FUH_FollowUpHospMentalIllness_30_6_17_years],
	[FUH_FollowUpHospMentalIllness_30_18_64_years] ,
	[FUH_FollowUpHospMentalIllness_30_65_years],
	[FUH_FollowUpAfterHospMentIllness7Day_6_17_years],
	[FUH_FollowUpAfterHospMentIllness7Day_18_64_years] ,
	[FUH_FollowUpAfterHospMentIllness7Day_65_years],

	[PPC_PostPartumCare] ,
	[PPC_TimelinessPrenatalCare] ,
	[ADD_FollowUpCareChild_ADHD_ContMaintPhase] ,
	[ADD_FollowUpCareChild_ADHD_InitiationPhase] ,
	[AWC_AdolescentWellCareVisits] ,
	[BCS_BreastCancerScreening] ,
	[CAP_ChildrenAdolescentsAccessPrimaryCare] ,
	[CBP_ControllingHighBloodPressure] ,
	[CCS_CervicalCancerScreening] ,
	[CDC_CompDiabetesCareHbA1cControl] ,
	[CDC_CompDiabetesCareHbA1cPoorControl] ,
	[CIS_ChildImmunizationStatusCombo10] ,
	[CTM_STWAWC_AdolescentWellCareVisits] ,
	[SSD_DiabetesScreeningSchizophreniaBipolar] ,
	[URI_ChildUpperRespInfection] ,
	[W15_WellChildVisitsFirst_15_Months] ,
	[W34_WellChildVisits_3_6_Years] ,
	[WCC_WeightCounselingChildBMIPercentile] ,
	[WCC_WeightCounselingChildNutrition] ,
	[WCC_WeightCounselingChildPhysicalActivity] ,
	[HealthPlanName],
	[Product],
	[loadDate] ,
	[DataDate] ,
	[SrcFileName] ,
	[CreatedDate] ,
	[CreatedBy] ,
	[LastUpdatedDate] ,
	[LastUpdatedBy] 
            )
     VALUES
   (
    @GroupName,
	@Physician,
	@PhysicianAddress,
	@FirstName,
	@LastName,
	@MemberID,
	@DOB ,
	@Phone ,
	@MemberAddress,
	@MemberState ,
	@MemberZip ,
	@DateOfLastService ,
	@IncentiveProgram ,
	@CareScore ,
	@FUH_FollowUpHospMentalIllness_30 ,
	@FUH_FollowUpAfterHospMentIllness7Day ,
	@FUH_FollowUpHospMentalIllness_30_6_17_years ,
	@FUH_FollowUpHospMentalIllness_30_18_64_years ,
	@FUH_FollowUpHospMentalIllness_30_65_years ,
	@FUH_FollowUpAfterHospMentIllness7Day_6_17_years ,
	@FUH_FollowUpAfterHospMentIllness7Day_18_64_years ,
	@FUH_FollowUpAfterHospMentIllness7Day_65_years ,

	@PPC_PostPartumCare,
	@PPC_TimelinessPrenatalCare ,
	@ADD_FollowUpCareChild_ADHD_ContMaintPhase ,
	@ADD_FollowUpCareChild_ADHD_InitiationPhase ,
	@AWC_AdolescentWellCareVisits ,
	@BCS_BreastCancerScreening ,
	@CAP_ChildrenAdolescentsAccessPrimaryCare ,
	@CBP_ControllingHighBloodPressure ,
	@CCS_CervicalCancerScreening ,
	@CDC_CompDiabetesCareHbA1cControl ,
	@CDC_CompDiabetesCareHbA1cPoorControl ,
	@CIS_ChildImmunizationStatusComb10 ,
	@CTM_STWAWC_AdolescentWellCareVisits,
    @SSD_DiabetesScreeningSchizophreniaBipolar ,
	@URI_ChildUpperRespInf ,
	@W15_WellChildVisitsFirst_15_Months ,
	@W34_WellChildVisits_3_6_Years ,
	@WCC_WeightCounselingChildBMIPercentile ,
	@WCC_WeightCounselingChildNutrition ,
	@WCC_WeightCounselingChildPhysicalActivity ,
	@HealthPlanName ,
	@Product ,
	GETDATE(),
	--@loadDate ,
	CASE 
	WHEN @DataDate = '' 
	  THEN NULL
	ELSE     
	  CONVERT(date, @DataDate) 
	
	END, 
	
--	'RD_'+ (CONVERT(varchar(8), GETDATE(), 112)) +'.' + @SrcFileName,
    'RD_' + REPLACE((CONVERT(VARCHAR(10), GETDATE(), 101)), '/','')   + '.' + @SrcFileName,
	GETDATE(),
	--@CreatedDate ,
	@CreatedBy ,
	---@LastUpdatedDate ,
	GETDATE(),
	@LastUpdatedBy
   )

   SET @ActionStopDateTime = GETDATE(); 
   EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,2
   END TRY

   BEGIN CATCH
	  SET @ActionStopDateTime = GETDATE(); 
      EXEC AceMetaData.amd.sp_AceEtlAudit_Close  @AuditID, @ActionStopDateTime, 1,1,0,3   
   END CATCH



  --  EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 2, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', '';

END





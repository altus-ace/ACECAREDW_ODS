-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[sp_copUhcPcor_2](
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
	@FUH_FollowUpHospMentalIllness_30 varchar(1),
	@FUH_FollowUpAfterHospMentIllness7Day varchar(1),
	@PPC_PostPartumCare varchar(1),
	@PPC_TimelinessPrenatalCare varchar(1),
	@ADD_FollowUpCareChild_ADHD_ContMaintPhase varchar(1),
	@ADD_FollowUpCareChild_ADHD_InitiationPhase varchar(1),
	@AWC_AdolescentWellCareVisits varchar(1),
	@BCS_BreastCancerScreening varchar(1),
	@CAP_ChildrenAdolescentsAccessPrimaryCare varchar(1),
	@CBP_ControllingHighBloodPressure varchar(1),
	@CCS_CervicalCancerScreening varchar(1),
	@CDC_CompDiabetesCareHbA1cControl varchar(1),
	@CDC_CompDiabetesCareHbA1cPoorControl varchar(1),
	@CIS_ChildImmunizationStatusComb10 varchar(1),
	@CTM_STWAWC_AdolescentWellCareVisits varchar(1),
    @SSD_DiabetesScreeningSchizophreniaBipolar varchar(1),
	@URI_ChildUpperRespInf varchar(1),
	@W15_WellChildVisitsFirst_15_Months varchar(1),
	@W34_WellChildVisits_3_6_Years varchar(1),
	@WCC_WeightCounselingChildBMIPercentile varchar(1),
	@WCC_WeightCounselingChildNutrition varchar(1),
	@WCC_WeightCounselingChildPhysicalActivity varchar(1),
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

	-- Call ACE ETL Audit to log progress
	
	DECLARE @AuditID AS INT, @ActionStartDateTime AS datetime2
	
	SET @ActionStartDateTime = GETDATE(); 
	
	--'2017-12-16 11:15:23.2393473'
    
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID Out, 1, 1, 1,'UHC Import PCOR', @ActionStartDateTime, @SrcFileName, '[ACECARDW].[adi].[copUhcPcor]', ''; 

    -- Insert statements for procedure here

 IF (@Physician <>'' AND @FirstName <> '' AND @LastName <> ''  AND @MemberID <> '') 
 BEGIN
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
	@DataDate ,
	@SrcFileName,
	GETDATE(),
	--@CreatedDate ,
	@CreatedBy ,
	--@LastUpdatedDate ,
	GETDATE(),
	@LastUpdatedBy
   )
  END ;

END

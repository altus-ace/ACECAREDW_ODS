-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [adi].[ImportNtfAetComDlyCensus](
    @SrcFileName VARCHAR(100)
      ,@CreatedDate date 
      ,@CreatedBy VARCHAR(20)
      ,@CarrierName VARCHAR(30)
      ,@ACOName VARCHAR(30)
      ,@ACOAttributedProviderName VARCHAR(100)
      ,@NPINumber VARCHAR(15)
      ,@ACOAttributedProviderAddress1 VARCHAR(100)
      ,@ACOAttributedProviderAddress2 VARCHAR(100)
      ,@ACOAttributedProviderCity VARCHAR(35) 
      ,@ACOAttributedProviderState VARCHAR(25)
      ,@ACOAttributedProviderZipcode VARCHAR(15)
      ,@ACOAttributedProviderPhone VARCHAR(35)
      ,@MemberLastName VARCHAR(50)
      ,@MemberFirstName VARCHAR(50)
      ,@DWMemberID VARCHAR(50)
      ,@CumbID VARCHAR(25)
      ,@CardID VARCHAR(25)
      ,@CardIDSeqNo VARCHAR(10)
      ,@DateofBirth VARCHAR(20)
      ,@PulseScore VARCHAR(20)
      ,@Status VARCHAR(50)
      ,@MemberPhone VARCHAR(35)
      ,@ACOAttributionEffectiveDate VARCHAR(20)
      ,@ACOAttributionEndDate VARCHAR(20)
      ,@MemberTerminationDate VARCHAR(20)
      ,@LineofBusiness VARCHAR(30)
      ,@Product VARCHAR(30)
      ,@PlanSponsorName VARCHAR(100)
      ,@PlanSponsorControl VARCHAR(15)
      ,@AdmitPotentiallyAvoidable VARCHAR(10)
      ,@EventType VARCHAR(15)
      ,@EventStageStatus VARCHAR(10) 
      ,@StayType VARCHAR(50)
      ,@AdmissionType VARCHAR(30)
      ,@NotificationDate VARCHAR(10)
      ,@ExpectedAdmitDate VARCHAR(10)
      ,@ActualAdmitDate VARCHAR(10)
      ,@ExpectedDischargeDate VARCHAR(10)
      ,@ActualDischargeDate VARCHAR(10) 
      ,@DischargeDisposition VARCHAR(10)
      ,@DiagnosisCode VARCHAR(20)
      ,@DiagnosisDescription VARCHAR(50)
      ,@OtherComorbidDiagnosis1 VARCHAR(20)
      ,@OtherComorbidDiagnosis2 VARCHAR(20)
      ,@ProcedureCode VARCHAR(20)
      ,@ProcedureDescription VARCHAR(250)
      ,@ProcedureStartDate VARCHAR(10)
      ,@ProviderNameRole varchar(150)
      ,@FacilityNameRole VARCHAR(150)
      ,@FacilityAddress VARCHAR(50)
      ,@filler1 VARCHAR(100)
      ,@filler2 VARCHAR(100)
      ,@filler3 VARCHAR(100)
      ,@filler4 VARCHAR(100)
      ,@filler5 VARCHAR(100)
  
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--UPDATE adi.MbrAetCom
--	SET MEMBER_ID  =  @MEMBER_ID 

--    WHERE  MEMBER_ID = @MEMBER_ID

	 
--	IF @@ROWCOUNT = 0

    -- Insert statements for procedure here
 INSERT INTO adi.NtfAetComDlyCensus
   (
   SrcFileName,
	CreatedDate ,
	LoadDate,
	DataDate,
	CreatedBy 
      ,[Carrier Name]
      ,[ACO Name]
      ,[ACO Attributed Provider Name]
      ,[NPI Number]
      ,[ACO Attributed Provider Address1]
      ,[ACO Attributed Provider Address2]
      ,[ACO Attributed Provider City]
      ,[ACO Attributed Provider State]
      ,[ACO Attributed Provider Zipcode]
      ,[ACO Attributed Provider Phone]
      ,[Member Last Name]
      ,[Member First Name]
      ,[DW Member ID]
      ,[Cumb ID]
      ,[Card ID]
      ,[Card ID Seq No]
      ,[Date of Birth]
      ,[Pulse Score]
      ,[Status]
      ,[Member Phone]
      ,[ACO Attribution Effective Date]
      ,[ACO Attribution End Date]
      ,[Member Termination Date]
      ,[Line of Business]
      ,[Product]
      ,[Plan Sponsor Name]
      ,[Plan Sponsor Control]
      ,[Admit Potentially Avoidable]
      ,[Event Type]
      ,[Event Stage (Status) ]
      ,[Stay Type]
      ,[Admission Type]
      ,[Notification Date]
      ,[Expected Admit Date]
      ,[Actual Admit Date]
      ,[Expected Discharge Date]
      ,[Actual Discharge Date]
      ,[Discharge Disposition ]
      ,[Diagnosis Code]
      ,[Diagnosis Description]
      ,[Other Comorbid Diagnosis1]
      ,[Other Comorbid Diagnosis2]
      ,[Procedure Code]
      ,[Procedure Description]
      ,[Procedure Start Date]
      ,[Provider Name/Role]
      ,[Facility Name/Role]
      ,[Facility Address]
      ,[filler 1]
      ,[filler 2]
      ,[filler 3]
      ,[filler 4]
      ,[filler 5]
	       
)
     VALUES
   (
    @SrcFileName 
    ,GETDATE()
   --@CreatedDate ,
   ,GETDATE()
   ,CONVERT(DATE, Substring(@SrcFileName, (PATINDEX('%.csv%', @SrcFileName)-8), 8)) 
 -- , CONVERT(date, RIGHT(Substring(@SrcFileName,1, (PATINDEX('%.xlsx%', @SrcFileName)-1)), 8))
       ,@CreatedBy
       ,@CarrierName
      ,@ACOName 
      ,@ACOAttributedProviderName 
      ,@NPINumber 
      ,@ACOAttributedProviderAddress1 
      ,@ACOAttributedProviderAddress2 
      ,@ACOAttributedProviderCity  
      ,@ACOAttributedProviderState 
      ,@ACOAttributedProviderZipcode 
      ,@ACOAttributedProviderPhone 
      ,@MemberLastName 
      ,@MemberFirstName 
      ,@DWMemberID 
      ,@CumbID 
      ,@CardID 
      ,@CardIDSeqNo 
      ,@DateofBirth 
	   ,CASE WHEN @PulseScore  = ''
	    Then NULL
		ELSE CONVERT(numeric(5,3),@PulseScore)
		END 

      ,@Status 
      ,@MemberPhone 
      ,@ACOAttributionEffectiveDate 
      ,@ACOAttributionEndDate 
      ,@MemberTerminationDate 
      ,@LineofBusiness 
      ,@Product 
      ,@PlanSponsorName 
      ,@PlanSponsorControl 
      ,@AdmitPotentiallyAvoidable 
      ,@EventType 
      ,@EventStageStatus 
      ,@StayType
      ,@AdmissionType 

      ,@NotificationDate 
      ,@ExpectedAdmitDate 
	  , CASE WHEN @ActualAdmitDate  = ''
	    Then NULL
		ELSE CONVERT(date,@ActualAdmitDate)
		END 
	  , CASE WHEN @ExpectedDischargeDate  = ''
	    Then NULL
		ELSE CONVERT(date,@ExpectedDischargeDate)
		END 
	  , CASE WHEN @ActualDischargeDate  = ''
	    Then NULL
		ELSE CONVERT(date,@ActualDischargeDate )
		END   
      ,@DischargeDisposition 
      ,@DiagnosisCode 
      ,@DiagnosisDescription 
      ,@OtherComorbidDiagnosis1 
      ,@OtherComorbidDiagnosis2 
      ,@ProcedureCode 
      ,@ProcedureDescription 
	  , CASE WHEN @ProcedureStartDate = ''
	    Then NULL
		ELSE CONVERT(date,@ProcedureStartDate)
		END 
      ,@ProviderNameRole 
      ,@FacilityNameRole 
      ,@FacilityAddress 
      ,@filler1 
      ,@filler2 
      ,@filler3 
      ,@filler4 
      ,@filler5 
   );
END




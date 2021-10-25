-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert Cigna MA AWV to DB
-- ============================================
CREATE PROCEDURE [adi].[ImporCignaMA_MedAdherencePlans]
    @SrcFileName [varchar](100),
	@FileDate varchar(10),
  --[CreateDate] [datetime] NULL,
	@CreateBy [varchar] (100),
	@OriginalFileName [varchar],
	@LastUpdatedBy [varchar](100),
	--[LastUpdatedDate] [datetime] ,
	@DataDate varchar(10),
	@ContractID [varchar](10),
	@PBP [varchar](10) ,
	@Region [varchar](20),
	@Market [varchar](20) ,
	@CurrentYRFills [varchar](10),
	@PCPNPI [varchar](50),
	@PCPLastName [varchar](50) ,
	@PCPFirstName [varchar](50) ,
	@PCP [varchar](50),
	@QNXTPCPID [varchar](50),
	@PODName [varchar](50) ,
	@MemberID [varchar](20),
	@LastName [varchar](50) ,
	@FirstName [varchar](50),
	@TermDate varchar(10),
	@DenominatorDaysYTD [varchar](5),
	@DaysCoveredYTD varchar(5),
	@CURRENTYEARPDC_YTD [varchar](10),
	@PDCR12 [varchar](10) ,
	@One_YR_prior_PDC [varchar](10) ,
	@Two_YR_prior_PDC [varchar](10) ,
	@Three_YR_prior_PDC [varchar](10),
	@NonAdherentDaysRemaining [varchar](5),
	@PossibleToMeet [varchar](10) ,
	@DrugClass [varchar](50),
	@MedicationName [varchar](50),
	@DaysSupply [varchar](5),
	@MedicationTier [varchar](10) ,
	@FirstFillDate varchar(10),
	@LastFillDate varchar(10),
	@NextFillDueDate varchar(10),
	@PharmacyType [varchar](10),
	@PharmacyTypeDesc [varchar](50),
	@PatResdDescr [varchar](50)  
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC [ACDW_CLMS_CIGNA_MA].[adi].[ImporCignaMA_MedAdherencePlans]
	@SrcFileName ,
	@FileDate ,
  --[CreateDate] [datetime] NULL,
	@CreateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	--[LastUpdatedDate] [datetime] ,
	@DataDate,
	@ContractID ,
	@PBP ,
	@Region ,
	@Market ,
	@CurrentYRFills ,
	@PCPNPI ,
	@PCPLastName ,
	@PCPFirstName  ,
	@PCP ,
	@QNXTPCPID ,
	@PODName ,
	@MemberID ,
	@LastName ,
	@FirstName ,
	@TermDate ,
	@DenominatorDaysYTD ,
	@DaysCoveredYTD ,
	@CURRENTYEARPDC_YTD ,
	@PDCR12  ,
	@One_YR_prior_PDC ,
	@Two_YR_prior_PDC ,
	@Three_YR_prior_PDC ,
	@NonAdherentDaysRemaining ,
	@PossibleToMeet ,
	@DrugClass ,
	@MedicationName ,
	@DaysSupply ,
	@MedicationTier ,
	@FirstFillDate ,
	@LastFillDate ,
	@NextFillDueDate ,
	@PharmacyType ,
	@PharmacyTypeDesc ,
	@PatResdDescr 



END





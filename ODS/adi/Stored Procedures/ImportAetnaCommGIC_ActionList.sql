-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- change log
-- add Datedate and use the last date from file name  
-- =============================================
CREATE PROCEDURE [adi].[ImportAetnaCommGIC_ActionList](
	@OriginalFileName varchar(100) ,
	@SrcFileName varchar(100) ,
	--@LoadDate date NOT ,
	--@CreatedDate date NOT ,
	@CreatedBy varchar(50)  ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy varchar(50) ,
	@OrgCode varchar(20) ,
	@GapCount int ,
	@OnPriorList char(1) ,
	@SourceCUMBID varchar(50) ,
	@AetnaCardID varchar(50) ,
	@SeqNumber varchar(20) ,
	@Funding varchar(50) ,
	@PlanSponsorName varchar(50) ,
	@MemberID varchar(50) ,
	@LastName varchar(50) ,
	@FirstName varchar(50) ,
	@DateBirth varchar(10) ,
	@Gender char(1) ,
	@Phone varchar(20) ,
	@SegmentName varchar(50) ,
	@Carrier varchar(50) ,
	@MemberActive varchar(10) ,
	@AttributedTIN varchar(20) ,
	@AttributedTIName varchar(50) ,
	@AttributedPIN varchar(20) ,
	@AttributedProviderNPI varchar(20) ,
	@AttributedProviderName varchar(50) ,
	@LastSeenPCPName varchar(50) ,
	@LastseenPCPNPI varchar(20) ,
	@LastseenPCPVisitDate varchar(10) ,
	@NumberDaysLastPCPvisit int ,
	@PCPwithinACO varchar(50) ,
	@LastSeenSpecName varchar(50) ,
	@LastSeenSpecSpclty varchar(50) ,
	@LastseenSpecVisitDate varchar(10) ,
	@MedicalConditions varchar(50) ,
	@ContinuousEnrollment varchar(50) ,
	@Measure varchar(50) ,
	@ActionRequired varchar(50) ,
	@LastTest_ExamDate varchar(10) ,
	@ValueType varchar(50) ,
	@Value varchar(50) ,
	@Exam_DrugName varchar(50) ,
	@HBA1C_Value varchar(50) 
   
)
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_AET_TX_COM].[adi].[ImportAetnaCommGIC_ActionList]
	@OriginalFileName  ,
	@SrcFileName  ,
	--@LoadDate date NOT ,
	--@CreatedDate date NOT ,
	@CreatedBy   ,
	--@LastUpdatedDate datetime ,
	@LastUpdatedBy  ,
	@OrgCode  ,
	@GapCount ,
	@OnPriorList  ,
	@SourceCUMBID  ,
	@AetnaCardID  ,
	@SeqNumber  ,
	@Funding  ,
	@PlanSponsorName  ,
	@MemberID  ,
	@LastName  ,
	@FirstName  ,
	@DateBirth  ,
	@Gender  ,
	@Phone  ,
	@SegmentName  ,
	@Carrier  ,
	@MemberActive  ,
	@AttributedTIN  ,
	@AttributedTIName  ,
	@AttributedPIN  ,
	@AttributedProviderNPI  ,
	@AttributedProviderName  ,
	@LastSeenPCPName  ,
	@LastseenPCPNPI  ,
	@LastseenPCPVisitDate  ,
	@NumberDaysLastPCPvisit  ,
	@PCPwithinACO  ,
	@LastSeenSpecName  ,
	@LastSeenSpecSpclty  ,
	@LastseenSpecVisitDate  ,
	@MedicalConditions  ,
	@ContinuousEnrollment  ,
	@Measure  ,
	@ActionRequired  ,
	@LastTest_ExamDate ,
	@ValueType  ,
	@Value  ,
	@Exam_DrugName  ,
	@HBA1C_Value  
   
END





﻿
-- =============================================
-- Author:		Bing Yu
-- Create date: 12/04/2019
-- Description:	Insert Partc Claim file to DB
-- 
-- =============================================
CREATE PROCEDURE [adi].[ImportDHTX_MedicalClaims]
    @ReportDate varchar(10) ,
	@MemberID varchar(50) ,
	@MemberFirstName varchar(50) ,
	@MemberLastName varchar(50) ,
	@MemberBirthDate varchar(10) ,
	@MBI varchar(50) ,
	@PcpName varchar(50) ,
	@PcpNPI varchar(20) ,
	@PcpPracticeName varchar(50) ,
	@PCPAddress varchar(50) ,
	@PCPPhone varchar(20) ,
	@PcpTIN varchar(20) ,
	@PcpTINName varchar(20) ,
	@ClaimType varchar(20) ,
	@ClaimNumber varchar(20) ,
	@ClaimLineNumber varchar(20) ,
	@TotAmtAllowed varchar(10) ,
	@TotAmtCopmt varchar(10) ,
	@TotAmtCharge varchar(10) ,
	@TotAmtPaid varchar(10) ,
	@TotAmtDenied varchar(10) ,
	@CheckNbr varchar(20) ,
	@DateCreated varchar(10) ,
	@DatePaid varchar(10) ,
	@SvcFromDate varchar(10) ,
	@SvcToDate varchar(10) ,
	@AdjudicationStatus varchar(10) ,
	@PaymentStatus varchar(10) ,
	@BillingProviderNPI varchar(15) ,
	@BillingProviderName varchar(50) ,
	@BillingProviderTIN varchar(15) ,
	@BillingProviderSpecialtyCode varchar(15) ,
	@BillingProviderSpecialtyName varchar(50) ,
	@RenderingProviderNPI varchar(15) ,
	@RenderingProviderName varchar(50) ,
	@RenderingProviderTIN varchar(15) ,
	@RenderingProviderSpecialtyCode varchar(15) ,
	@RenderingProviderSpecialtyName varchar(50) ,
	@SpecialtyCode varchar(15) ,
	@SpecialtyDescription varchar(100) ,
	@Units varchar(10) ,
	@PlaceOfService varchar(100) ,
	@ProcedureCode varchar(50) ,
	@ProcModifier varchar(50) ,
	@ProcModifier2 varchar(50) ,
	@ProcModifier3 varchar(50) ,
	@ProcModifier4 varchar(50) ,
	@RevenueCode varchar(50) ,
	@PrincipalDiagnosisCode varchar(50) ,
	@Icd10Diag1 varchar(50) ,
	@Icd10Diag2 varchar(50) ,
	@Icd10Diag3 varchar(50) ,
	@Icd10Diag4 varchar(50) ,
	@Icd10Diag5 varchar(50) ,
	@Icd10Diag6 varchar(50) ,
	@Icd10Diag7 varchar(50) ,
	@Icd10Diag8 varchar(50) ,
	@Icd10Diag9 varchar(50) ,
	@Icd10Diag10 varchar(50) ,
	@Icd10Diag11 varchar(50) ,
	@Icd10Diag12 varchar(50) ,
	@Icd10Diag13 varchar(50) ,
	@Icd10Diag14 varchar(50) ,
	@Icd10Diag15 varchar(50) ,
	@Icd10Diag16 varchar(50) ,
	@Icd10Diag17 varchar(50) ,
	@Icd10Diag18 varchar(50) ,
	@Icd10Diag19 varchar(50) ,
	@Icd10Diag20 varchar(50) ,
	@Icd10Diag21 varchar(50) ,
	@Icd10Diag22 varchar(50) ,
	@Icd10Diag23 varchar(50) ,
	@Icd10Diag24 varchar(50) ,
	@Icd10Diag25 varchar(50) ,
	@Icd10Diag26 varchar(50) ,
	@Icd10Diag27 varchar(50) ,
	@Icd10Diag28 varchar(50) ,
	@Icd10Diag29 varchar(50) ,
	@Icd10Diag30 varchar(50) ,
	@Icd10Diag31 varchar(50) ,
	@Icd10Diag32 varchar(50) ,
	@Icd10Diag33 varchar(50) ,
	@Icd10Diag34 varchar(50) ,
	@Icd10Diag35 varchar(50) ,
	@Icd10Diag36 varchar(50) ,
	@Icd10Diag37 varchar(50) ,
	@Icd10Diag38 varchar(50) ,
	@Icd10Diag39 varchar(50) ,
	@Icd10Diag40 varchar(50) ,
	@Icd10Diag41 varchar(50) ,
	@Icd10Diag42 varchar(50) ,
	@Icd10Diag43 varchar(50) ,
	@Icd10Diag44 varchar(50) ,
	@Icd10Diag45 varchar(50) ,
	@Icd10Diag46 varchar(50) ,
	@Icd10Diag47 varchar(50) ,
	@Icd10Diag48 varchar(50) ,
	@Icd10Proc1 varchar(50) ,
	@Icd10Proc1Date varchar(10) ,
	@Icd10Proc2 varchar(50) ,
	@Icd10Proc2Date varchar(10) ,
	@Icd10Proc3 varchar(50) ,
	@Icd10Proc3Date varchar(10) ,
	@Icd10Proc4 varchar(50) ,
	@Icd10Proc4Date varchar(10) ,
	@Icd10Proc5 varchar(50) ,
	@Icd10Proc5Date varchar(10) ,
	@Icd10Proc6 varchar(50) ,
	@Icd10Proc6Date varchar(10) ,
	@Icd10Proc7 varchar(50) ,
	@Icd10Proc7Date varchar(10) ,
	@Icd10Proc8 varchar(50) ,
	@Icd10Proc8Date varchar(10) ,
	@Icd10Proc9 varchar(50) ,
	@Icd10Proc9Date varchar(10) ,
	@Icd10Proc10 varchar(50) ,
	@Icd10Proc10Date varchar(10) ,
	@Icd10Proc11 varchar(50) ,
	@Icd10Proc11Date varchar(10) ,
	@Icd10Proc12 varchar(50) ,
	@Icd10Proc12Date varchar(10) ,
	@Icd10Proc13 varchar(50) ,
	@Icd10Proc13Date varchar(10) ,
	@Icd10Proc14 varchar(50) ,
	@Icd10Proc14Date varchar(10) ,
	@Icd10Proc15 varchar(50) ,
	@Icd10Proc15Date varchar(10) ,
	@Icd10Proc16 varchar(50) ,
	@Icd10Proc16Date varchar(10) ,
	@Icd10Proc17 varchar(50) ,
	@Icd10Proc17Date varchar(10) ,
	@Icd10Proc18 varchar(50) ,
	@Icd10Proc18Date varchar(10) ,
	@Icd10Proc19 varchar(50) ,
	@Icd10Proc19Date varchar(10) ,
	@Icd10Proc20 varchar(50) ,
	@Icd10Proc20Date varchar(10) ,
	@Icd10Proc21 varchar(50) ,
	@Icd10Proc21Date varchar(10) ,
	@Icd10Proc22 varchar(50) ,
	@Icd10Proc22Date varchar(10) ,
	@Icd10Proc23 varchar(50) ,
	@Icd10Proc23Date varchar(10) ,
	@Icd10Proc24 varchar(50) ,
	@Icd10Proc24Date varchar(10) ,
	@Icd10Proc25 varchar(50) ,
	@Icd10Proc25Date varchar(10) ,
	@Icd10Proc26 varchar(50) ,
	@Icd10Proc26Date varchar(10) ,
	@Icd10Proc27 varchar(50) ,
	@Icd10Proc27Date varchar(10) ,
	@Icd10Proc28 varchar(50) ,
	@Icd10Proc28Date varchar(10) ,
	@Icd10Proc29 varchar(50) ,
	@Icd10Proc29Date varchar(10) ,
	@Icd10Proc30 varchar(50) ,
	@Icd10Proc30Date varchar(10) ,
	@Icd10Proc31 varchar(50) ,
	@Icd10Proc31Date varchar(10) ,
	@Icd10Proc32 varchar(50) ,
	@Icd10Proc32Date varchar(10) ,
	@Icd10Proc33 varchar(50) ,
	@Icd10Proc33Date varchar(10) ,
	@Icd10Proc34 varchar(50) ,
	@Icd10Proc34Date varchar(10) ,
	@Icd10Proc35 varchar(50) ,
	@Icd10Proc35Date varchar(10) ,
	@Icd10Proc36 varchar(50) ,
	@Icd10Proc36Date varchar(10) ,
	@Icd10Proc37 varchar(50) ,
	@Icd10Proc37Date varchar(10) ,
	@Icd10Proc38 varchar(50) ,
	@Icd10Proc38Date varchar(10) ,
	@Icd10Proc39 varchar(50) ,
	@Icd10Proc39Date varchar(10) ,
	@Icd10Proc40 varchar(50) ,
	@Icd10Proc40Date varchar(10) ,
	@Icd10Proc41 varchar(50) ,
	@Icd10Proc41Date varchar(10) ,
	@Icd10Proc42 varchar(50) ,
	@Icd10Proc42Date varchar(10) ,
	@Icd10Proc43 varchar(50) ,
	@Icd10Proc43Date varchar(10) ,
	@Icd10Proc44 varchar(50) ,
	@Icd10Proc44Date varchar(10) ,
	@Icd10Proc45 varchar(50) ,
	@Icd10Proc45Date varchar(10) ,
	@Icd10Proc46 varchar(50) ,
	@Icd10Proc46Date varchar(10) ,
	@Icd10Proc47 varchar(50) ,
	@Icd10Proc47Date varchar(10) ,
	@Icd10Proc48 varchar(50) ,
	@Icd10Proc48Date varchar(10) ,
	@OutOfNetwork varchar(50) ,
	@Encounter varchar(50) ,
	@AdmissionDate varchar(10) ,
	@DischargeDate varchar(10) ,
	@AdmissionType varchar(50) ,
	@AdmissionSource varchar(50) ,
	@BillType varchar(50) ,
	@DrgCode varchar(50) ,
	@DischargeCode varchar(50) ,
	@SrcFileName varchar(100) ,
	@FileDate varchar(10) ,
--	@CreateDate datetime ,
	@CreateBy varchar(100) ,
	@OriginalFileName varchar(100) ,
	@LastUpdatedBy varchar(100) ,
--	@LastUpdatedDate datetime ,
	@DataDate varchar(10) 
         
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	EXEC [ACDW_CLMS_DHTX].[adi].[ImportDHTX_MedicalClaims]
	@ReportDate  ,
	@MemberID  ,
	@MemberFirstName  ,
	@MemberLastName  ,
	@MemberBirthDate  ,
	@MBI  ,
	@PcpName  ,
	@PcpNPI  ,
	@PcpPracticeName  ,
	@PCPAddress  ,
	@PCPPhone  ,
	@PcpTIN  ,
	@PcpTINName  ,
	@ClaimType  ,
	@ClaimNumber  ,
	@ClaimLineNumber  ,
	@TotAmtAllowed  ,
	@TotAmtCopmt  ,
	@TotAmtCharge  ,
	@TotAmtPaid  ,
	@TotAmtDenied  ,
	@CheckNbr  ,
	@DateCreated  ,
	@DatePaid  ,
	@SvcFromDate  ,
	@SvcToDate  ,
	@AdjudicationStatus  ,
	@PaymentStatus  ,
	@BillingProviderNPI  ,
	@BillingProviderName  ,
	@BillingProviderTIN  ,
	@BillingProviderSpecialtyCode  ,
	@BillingProviderSpecialtyName  ,
	@RenderingProviderNPI  ,
	@RenderingProviderName  ,
	@RenderingProviderTIN  ,
	@RenderingProviderSpecialtyCode  ,
	@RenderingProviderSpecialtyName  ,
	@SpecialtyCode  ,
	@SpecialtyDescription  ,
	@Units  ,
	@PlaceOfService  ,
	@ProcedureCode  ,
	@ProcModifier  ,
	@ProcModifier2  ,
	@ProcModifier3  ,
	@ProcModifier4  ,
	@RevenueCode  ,
	@PrincipalDiagnosisCode  ,
	@Icd10Diag1  ,
	@Icd10Diag2  ,
	@Icd10Diag3  ,
	@Icd10Diag4  ,
	@Icd10Diag5  ,
	@Icd10Diag6  ,
	@Icd10Diag7  ,
	@Icd10Diag8  ,
	@Icd10Diag9  ,
	@Icd10Diag10  ,
	@Icd10Diag11  ,
	@Icd10Diag12  ,
	@Icd10Diag13  ,
	@Icd10Diag14  ,
	@Icd10Diag15  ,
	@Icd10Diag16  ,
	@Icd10Diag17  ,
	@Icd10Diag18  ,
	@Icd10Diag19  ,
	@Icd10Diag20  ,
	@Icd10Diag21  ,
	@Icd10Diag22  ,
	@Icd10Diag23  ,
	@Icd10Diag24  ,
	@Icd10Diag25  ,
	@Icd10Diag26  ,
	@Icd10Diag27  ,
	@Icd10Diag28  ,
	@Icd10Diag29  ,
	@Icd10Diag30  ,
	@Icd10Diag31  ,
	@Icd10Diag32  ,
	@Icd10Diag33  ,
	@Icd10Diag34  ,
	@Icd10Diag35  ,
	@Icd10Diag36  ,
	@Icd10Diag37  ,
	@Icd10Diag38  ,
	@Icd10Diag39  ,
	@Icd10Diag40  ,
	@Icd10Diag41  ,
	@Icd10Diag42  ,
	@Icd10Diag43  ,
	@Icd10Diag44  ,
	@Icd10Diag45  ,
	@Icd10Diag46  ,
	@Icd10Diag47  ,
	@Icd10Diag48  ,
	@Icd10Proc1  ,
	@Icd10Proc1Date  ,
	@Icd10Proc2  ,
	@Icd10Proc2Date  ,
	@Icd10Proc3  ,
	@Icd10Proc3Date  ,
	@Icd10Proc4  ,
	@Icd10Proc4Date  ,
	@Icd10Proc5  ,
	@Icd10Proc5Date  ,
	@Icd10Proc6  ,
	@Icd10Proc6Date  ,
	@Icd10Proc7  ,
	@Icd10Proc7Date  ,
	@Icd10Proc8  ,
	@Icd10Proc8Date  ,
	@Icd10Proc9  ,
	@Icd10Proc9Date  ,
	@Icd10Proc10  ,
	@Icd10Proc10Date  ,
	@Icd10Proc11  ,
	@Icd10Proc11Date  ,
	@Icd10Proc12  ,
	@Icd10Proc12Date  ,
	@Icd10Proc13  ,
	@Icd10Proc13Date  ,
	@Icd10Proc14  ,
	@Icd10Proc14Date  ,
	@Icd10Proc15  ,
	@Icd10Proc15Date  ,
	@Icd10Proc16  ,
	@Icd10Proc16Date  ,
	@Icd10Proc17  ,
	@Icd10Proc17Date  ,
	@Icd10Proc18  ,
	@Icd10Proc18Date  ,
	@Icd10Proc19  ,
	@Icd10Proc19Date  ,
	@Icd10Proc20  ,
	@Icd10Proc20Date  ,
	@Icd10Proc21  ,
	@Icd10Proc21Date  ,
	@Icd10Proc22  ,
	@Icd10Proc22Date  ,
	@Icd10Proc23  ,
	@Icd10Proc23Date  ,
	@Icd10Proc24  ,
	@Icd10Proc24Date  ,
	@Icd10Proc25  ,
	@Icd10Proc25Date  ,
	@Icd10Proc26  ,
	@Icd10Proc26Date  ,
	@Icd10Proc27  ,
	@Icd10Proc27Date  ,
	@Icd10Proc28  ,
	@Icd10Proc28Date  ,
	@Icd10Proc29  ,
	@Icd10Proc29Date  ,
	@Icd10Proc30  ,
	@Icd10Proc30Date  ,
	@Icd10Proc31  ,
	@Icd10Proc31Date  ,
	@Icd10Proc32  ,
	@Icd10Proc32Date  ,
	@Icd10Proc33  ,
	@Icd10Proc33Date  ,
	@Icd10Proc34  ,
	@Icd10Proc34Date  ,
	@Icd10Proc35  ,
	@Icd10Proc35Date  ,
	@Icd10Proc36  ,
	@Icd10Proc36Date  ,
	@Icd10Proc37  ,
	@Icd10Proc37Date  ,
	@Icd10Proc38  ,
	@Icd10Proc38Date  ,
	@Icd10Proc39  ,
	@Icd10Proc39Date  ,
	@Icd10Proc40  ,
	@Icd10Proc40Date  ,
	@Icd10Proc41  ,
	@Icd10Proc41Date  ,
	@Icd10Proc42  ,
	@Icd10Proc42Date  ,
	@Icd10Proc43  ,
	@Icd10Proc43Date  ,
	@Icd10Proc44  ,
	@Icd10Proc44Date  ,
	@Icd10Proc45  ,
	@Icd10Proc45Date  ,
	@Icd10Proc46  ,
	@Icd10Proc46Date  ,
	@Icd10Proc47  ,
	@Icd10Proc47Date  ,
	@Icd10Proc48  ,
	@Icd10Proc48Date  ,
	@OutOfNetwork  ,
	@Encounter  ,
	@AdmissionDate  ,
	@DischargeDate  ,
	@AdmissionType  ,
	@AdmissionSource  ,
	@BillType  ,
	@DrgCode  ,
	@DischargeCode  ,
	@SrcFileName  ,
	@FileDate  ,
--	@CreateDate datetime ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy  ,
--	@LastUpdatedDate datetime ,
	@DataDate  
END

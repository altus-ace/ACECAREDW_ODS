CREATE PROCEDURE adi.AceValidMbrsAetMaTx	
AS
BEGIN
    select 'Aet adiCurMem'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_adi_currentmembership]
    select 'Aet TinFlow'		  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_aditoadwTINFlowValidation_cleanup]
    select 'Aet MbrPlanChange'  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrcsplanChangembrs]
    select 'Aet MbrPlnCurMem'   as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrcsplancurrentMembership]
    select 'Aet CsPlan'		  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrCsplannewmbrs]
    select 'Aet PlanPcp'		  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_Mbrcsplannopcp]
    select 'Aet PlanTerm'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrcsplanTermsmbrs]
    select 'Aet Demographic'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrDemograhics]
    select 'Aet MbrMember'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrMember]
    select 'Aet MbrPcp'		  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_Mbrpcpchanges]
    select 'Aet MbrPhone'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_Mbrphonecheck]
    select 'Aet MbrPlan'		  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrplanChangembrs]
    select 'Aet MbrPlanNew'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_Mbrplannewmbrs]
    select 'Aet PlanNoPcp'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_Mbrplannopcp]
    select 'Aet PlanTermMbr'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_MbrplanTermsmbrs]
    select 'Aet MultElig'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_multipleeligbilitylines]
    select 'Aet NewProv'		  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_NewProviderMembersadded]
    select 'Aet NonContract'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_Non_Contracted_Members]
    select 'Aet PlanCode'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_Plancode]
    select 'Aet ProvNotInMbrs'  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_ProviderinSFNotinMembership]
    select 'Aet ProvNotInSF'	  as ValType, * FROM [dbo].[vw_ACE_Validation_Chk_AET_ProviderNotinSF]

END

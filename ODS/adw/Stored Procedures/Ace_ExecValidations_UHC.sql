
CREATE PROCEDURE [adw].[Ace_ExecValidations_UHC]
    (@VerboseOutput CHAR(1) = 'N')
AS
-- make this an sp: It runs all validations for UHC Mbr Load:
    -- make each validation return "Valid" as a result if valid, or relevant details as Key:Value set 
    -- make it log the out put
SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_Account_TIN]  V;

SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_ActiveMemberToCsPlans] v;

SELECT * 
FROM[dbo].[vw_Ace_Validation_Chk_UHC_AltMapping_SubGrp] V

SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_Exp_Eligibility_Enddate] V

/*
SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_Highriskmembersmbrhistory] v
*/

SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_LOB] V
/*
SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_MemberplanHistory_Stopdate] V
*/
/*
SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_MembersbyPCP] V
*/
/*
SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_NewMembersbypcpAHSplan] V
*/

SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_Plan] V

SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_PlanchangembrpcpandAHSplanhistory] V

/*
SELECT 'vw_ACE_Validation_Chk_UHC_PlanchangesMembers' ValName,  v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_PlanchangesMembers] V;
*/

/* any results in this list are to be sent to Network team, to add to SF */
SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_Provider_NPI] V;

SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_TermMembersbypcpAHSplan] V;

SELECT v.*
FROM [dbo].[vw_ACE_Validation_Chk_UHC_Zipcode] V;




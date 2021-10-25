/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view vw_ACE_Validation_Chk_AET_MbrcsplancurrentMembership
As
Select * from adw.mbrCsPlanHistory
where MbrCsSubPlanName like 'AETNA%' and ExpirationDate='12-31-2099'

/* this count should match with [dbo].[vw_ACE_Validation_Chk_AET_adi_currentmembership]
this view counts*/
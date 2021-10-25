CREATE view [dbo].[vw_AH_Mpluse_MembersDonotCall]
As
select pd.Client_patient_id,hn.Health_Notes_text as HEALTH_NOTES,hnt.NOTE_TYPE,hn.created_on from ahs_altus_prod.dbo.[PATIENT_HEALTH_NOTES] hn 
inner join ahs_altus_prod.dbo.Health_Note_type hnt on hnt.Note_type_id=hn.Notes_type
inner join ahs_altus_prod.dbo.PATIENT_DETAILS pd on pd.Patient_id=hn.patient_id
where hnt.NOTE_TYPE='Do Not Call' and IS_ACTIVE=1



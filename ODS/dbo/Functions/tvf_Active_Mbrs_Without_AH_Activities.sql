/*****************************************************************
CREATED BY : AM
CREATE DATE : 10/23/2019
DESCRIPTION : 
Ticket #1765- Members by clients in AceCareDW without activities in Altruista

******************************************************************/

CREATE FUNCTION [dbo].[tvf_Active_Mbrs_Without_AH_Activities](@ClientKey varchar(10))
RETURNS TABLE
AS RETURN
(
--declare @clientkey varchar(10) ;
--set @clientkey = 'WLC';   
select distinct AB.Member_ID, AB.MEMBER_FIRST_NAME,ab.MEMBER_LAST_NAME, ab.DATE_OF_BIRTH,ab.PCP_NAME, PCP_PRACTICE_NAME from 
(select distinct member_id from [ACECAREDW].[dbo].[vw_ActiveMembers] where [ACECAREDW].[dbo].[vw_ActiveMembers].client = @clientkey
except
Select DISTINCT PD.client_patient_id 

from [Ahs_Altus_Prod].dbo.patient_followup as pf
JOIN [Ahs_Altus_Prod].dbo.patient_details AS PD ON PD.patient_id = pf.patient_id 
JOIN [Ahs_Altus_Prod].[dbo].[HEALTH_NOTES] H on convert(date ,h.CREATED_ON,101)  = convert(DATE,pf.CREATED_DATE ,101) and h.PATIENT_ID = pf.PATIENT_ID
JOIN [Ahs_Altus_Prod].dbo.HEALTH_NOTE_TYPE healthtype on healthtype.NOTE_TYPE_ID = h.HEALTH_NOTE_TYPE_ID 
JOIN [Ahs_Altus_Prod].dbo.care_activity_type AS cat ON pf.CARE_ACTIVITY_TYPE_ID = cat.care_activity_type_id 
where 
h.HEALTH_NOTES IS NOT NULL
) AF
join [ACECAREDW].[dbo].[vw_ActiveMembers] Ab on Af.member_id = ab.MEMBER_ID
	
) 

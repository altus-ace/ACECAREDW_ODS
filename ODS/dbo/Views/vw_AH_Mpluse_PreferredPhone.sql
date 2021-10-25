CREATE VIEW [vw_AH_Mpluse_PreferredPhone]
As
select pd.CLIENT_PATIENT_ID,ppt.PHONE_TYPE,pp.PHONE_NUMBER,pp.CREATED_ON,pp.UPDATED_ON from AHS_ALTUS_PROD.DBO.PATIENT_phone pp 
inner join AHS_ALTUS_PROD.DBO.MA_PHONE_TYPE ppt on ppt.Phone_type_id=pp.Phone_type_id
inner join AHS_ALTUS_PROD.DBO.PATIENT_DETAILS pd on pd.patient_id=pp.patient_id
where pp.IS_PREFERRED=1 and pp.PHONE_NUMBER is not null

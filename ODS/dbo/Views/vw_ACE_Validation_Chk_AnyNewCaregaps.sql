

CREATE VIEW [dbo].[vw_ACE_Validation_Chk_AnyNewCaregaps]
AS
select distinct Measure_desc, Sub_Meas from uhc_careopps
where A_LAST_UPDATE_FLAG = 'Y'
except
	select SOURCE_MEASURE_NAME,SOURCE_SUB_MEASURE_NAME from ACECAREDW.dbo.ACE_MAP_CAREOPPS_PROGRAMS
	where destination = 'ALTRUISTA' and source = 'UHC'

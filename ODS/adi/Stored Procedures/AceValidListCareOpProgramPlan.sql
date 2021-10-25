CREATE PROCEDURE adi.AceValidListCareOpProgramPlan
AS
SELECT 
    co.Measure_desc, co.Sub_Meas, CONVERT(DATE, co.LoadDate) as LoadDate
    , CoProg.DESTINATION_PROGRAM_NAME AS AhsProgramName
    , CotP.CsPlan AS CareOpForPlan
FROM (SELECT co.Measure_desc, co.Sub_Meas, Max(co.A_LAST_UPDATE_DATE) as LoadDate
	   FROM dbo.UHC_CareOpps co
	   GROUP BY co.Measure_desc, co.Sub_Meas
	   ) AS co
    LEFT JOIN dbo.ACE_MAP_CAREOPPS_PROGRAMS CoProg ON co.Measure_Desc = CoProg.SOURCE_MEASURE_NAME
	   AND co.Sub_Meas = CoProg.SOURCE_SUB_MEASURE_NAME
	   AND CoProg.SOURCE = 'UHC'
	   AND coProg.Destination = 'ALTRUISTA'
    LEFT JOIN lst.lstCareOpToPlan CotP ON CoProg.SOURCE_MEASURE_NAME = CotP.MeasureDesc
	   AND coProg.SOURCE_SUB_MEASURE_NAME = CotP.SubMeasure
	   AND CotP.ClientKey = 1
	   AND GETDATE() BETWEEN CotP.EffectiveDate and CotP.ExpirationDate;


CREATE VIEW [dbo].[vw_AH_PH_AET_careopps_old]
AS
     SELECT DISTINCT 
            MCP.SOURCE AS CLIENT_ID, 
            a.MEMBER_ID AS MEMBER_ID, 
            concat(LTRIM(RTRIM(
			mh.SOURCE_MEASURE_ID)), '-', LTRIM(RTRIM(Mh.SOURCE_MEASURE_NAME))) AS OPPURTUNITY, 
            LTRIM(RTRIM(Mh.SOURCE_MEASURE_ID)) AS MEASURE_CODE, 
            LTRIM(RTRIM(mh.Source)) AS MEASURE_CATEGORY,
            CASE
                WHEN pr.PROGRAM_STATUS_NAME = 'ACTIVE'
                THEN 'Not Addressed'
                WHEN pr.PROGRAM_STATUS_NAME = 'In Progress'
                THEN 'In Progress'
                WHEN pr.PROGRAM_STATUS_NAME = 'CLOSE-PENDING CLAIMS'
                THEN 'Completed'
                ELSE 'Not Addressed'
            END AS 'STATUS', 
            CONVERT(DATE, careopp.A_LAST_UPDATE_DATE, 101) AS DATE_IDENTIFIED, 
            YEAR(GETDATE()) AS MEASURE_VERSION
     FROM
     (
         SELECT DISTINCT 
                co.MemberID, 
                'AceiArbAdherence' AS Measure, 
                co.AceiArbAdherence Measurestatus, 
                co.a_last_update_flag, 
                CO.A_LAST_UPDATE_DATE, 
                co.tin
        FROM tmpAet_Careopps co -- dbo.tmpAet_Careopps: adi.copAetMaCareopps GK: 6/5
         WHERE co.AceiArbAdherence = 'N'
         UNION
         SELECT DISTINCT 
                co1.MemberID, 
                'BreastScreeningCompliance' AS Measure, 
                LTRIM(RTRIM(LEFT(co1.[Breast ScreeningCompliance], 1))) AS Measurestatus, 
                co1.a_last_update_flag, 
                CO1.A_LAST_UPDATE_DATE, 
                co1.tin
         FROM tmpAet_Careopps co1
         WHERE LTRIM(RTRIM(LEFT(co1.[Breast ScreeningCompliance], 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co2.MemberID, 
                'ColorectalScreeningCompliance' AS Measure, 
                LTRIM(RTRIM(LEFT(co2.ColorectalScreeningCompliance, 1))) AS Measurestatus, 
                co2.a_last_update_flag, 
                CO2.A_LAST_UPDATE_DATE, 
                co2.tin
         FROM tmpAet_Careopps co2
         WHERE LTRIM(RTRIM(LEFT(co2.ColorectalScreeningCompliance, 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co3.MemberID, 
                'DiabetesEyeExam' AS Measure, 
                LTRIM(RTRIM(LEFT(co3.DiabetesEyeExam, 1))) AS Measurestatus, 
                co3.a_last_update_flag, 
                CO3.A_LAST_UPDATE_DATE, 
                co3.tin
         FROM tmpAet_Careopps co3
         WHERE LTRIM(RTRIM(LEFT(co3.DiabetesEyeExam, 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co4.MemberID, 
                'DiabetesNephropathyScreening' AS Measure, 
                LTRIM(RTRIM(LEFT(co4.DiabetesNephropathyScreening, 1))) AS Measurestatus, 
                co4.a_last_update_flag, 
                CO4.A_LAST_UPDATE_DATE, 
                co4.tin
         FROM tmpAet_Careopps co4
         WHERE LTRIM(RTRIM(LEFT(co4.DiabetesNephropathyScreening, 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co5.MemberID, 
                'DiabetesLdlControl' AS Measure, 
                LTRIM(RTRIM(LEFT(co5.DiabetesLdlControl, 1))) AS Measurestatus, 
                co5.a_last_update_flag, 
                CO5.A_LAST_UPDATE_DATE, 
                co5.tin
         FROM tmpAet_Careopps co5
         WHERE LTRIM(RTRIM(LEFT(co5.DiabetesLdlControl, 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co6.MemberID, 
                'DiabetesMedicationAdherence' AS Measure, 
                co6.DiabetesMedicationAdherence AS Measurestatus, 
                co6.a_last_update_flag, 
                CO6.A_LAST_UPDATE_DATE, 
                co6.tin
         FROM tmpAet_Careopps co6
         WHERE LTRIM(RTRIM(LEFT(co6.DiabetesMedicationAdherence, 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co7.MemberID, 
                'DiabetesControlledHbA1c' AS Measure, 
                LTRIM(RTRIM(LEFT(co7.DiabetesControlledHbA1c, 1))) AS Measurestatus, 
                co7.a_last_update_flag, 
                CO7.A_LAST_UPDATE_DATE, 
                co7.tin
         FROM tmpAet_Careopps co7
         WHERE LTRIM(RTRIM(LEFT(co7.DiabetesControlledHbA1c, 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co8.MemberID, 
                'StatinUseInDiabetics' AS Measure, 
                LTRIM(RTRIM(LEFT(co8.StatinUseInDiabetics, 1))) AS Measurestatus, 
                co8.a_last_update_flag, 
                CO8.A_LAST_UPDATE_DATE, 
                co8.tin
         FROM tmpAet_Careopps co8
         WHERE LTRIM(RTRIM(LEFT(co8.StatinUseInDiabetics, 1))) = 'N'
         UNION
         SELECT DISTINCT 
                co9.MemberID, 
                'StatinMedicationAdherence' AS Measure, 
                LTRIM(RTRIM(LEFT(co9.StatinMedicationAdherence, 1))) AS Measurestatus, 
                co9.a_last_update_flag, 
                CO9.A_LAST_UPDATE_DATE, 
                co9.tin
         FROM tmpAet_Careopps co9
         WHERE co9.StatinMedicationAdherence = 'N'
         UNION
         SELECT DISTINCT 
                co10.MemberID, 
                'OsteoporosisManagement' AS Measure, 
                LTRIM(RTRIM(co10.OsteoporosisManagement)) AS Measurestatus, 
                co10.a_last_update_flag, 
                CO10.A_LAST_UPDATE_DATE, 
                co10.tin
         FROM tmpAet_Careopps co10
         WHERE co10.OsteoporosisManagement = 'N'
         UNION
         SELECT DISTINCT 
                co11.MemberID, 
                'RheumatoidArthritisManagement' AS Measure, 
                LTRIM(RTRIM(co11.RheumatoidArthritisManagement)) AS Measurestatus, 
                co11.a_last_update_flag, 
                CO11.A_LAST_UPDATE_DATE, 
                co11.tin
         FROM tmpAet_Careopps co11
         WHERE co11.RheumatoidArthritisManagement = 'N'
         UNION
         SELECT DISTINCT 
                co12.MemberID, 
                'AdultBMIAssessment' AS Measure, 
                LTRIM(RTRIM(LEFT(co12.AdultBMIAssessment, 1))) AS Measurestatus, 
                co12.a_last_update_flag, 
                CO12.A_LAST_UPDATE_DATE, 
                co12.tin
         FROM tmpAet_Careopps co12
         WHERE co12.AdultBMIAssessment = 'N'
         UNION
         SELECT DISTINCT 
                co13.MemberID, 
                'LastOfficeVisit' AS Measure, 
                LTRIM(RTRIM(LEFT(co13.LastOfficeVisit, 1))) AS Measurestatus, 
                co13.a_last_update_flag, 
                CO13.A_LAST_UPDATE_DATE, 
                co13.tin
         FROM tmpAet_Careopps co13
         WHERE co13.LastOfficeVisit = 'N'
         UNION
         SELECT DISTINCT 
                co14.MemberID, 
                'OfficeVisits-Chronic1stHalf' AS Measure, 
                LTRIM(RTRIM(LEFT(co14.[OfficeVisits-Chronic1stHalf], 1))) AS Measurestatus, 
                co14.a_last_update_flag, 
                CO14.A_LAST_UPDATE_DATE, 
                co14.tin
         FROM tmpAet_Careopps co14
         WHERE co14.[OfficeVisits-Chronic1stHalf] = '0'
         UNION
         SELECT DISTINCT 
                co15.MemberID, 
                'OfficeVisits-Chronic2ndHalf' AS Measure, 
                LTRIM(RTRIM(LEFT(co15.[Office Visits-Chronic2ndHalf], 1))) AS Measurestatus, 
                co15.a_last_update_flag, 
                CO15.A_LAST_UPDATE_DATE, 
                co15.tin
         FROM tmpAet_Careopps co15
         WHERE co15.[Office Visits-Chronic2ndHalf] = '0'
         UNION
         SELECT DISTINCT 
                co16.MemberID, 
                'AnnualFluVaccine' AS Measure, 
                LTRIM(RTRIM(LEFT(co16.AnnualFluVaccine, 1))) AS Measurestatus, 
                co16.a_last_update_flag, 
                CO16.A_LAST_UPDATE_DATE, 
                co16.tin
         FROM tmpAet_Careopps co16
         WHERE co16.AnnualFluVaccine = 'N'
         UNION
         SELECT DISTINCT 
                co17.MemberID, 
                'ControllingHighBloodPressure' AS Measure, 
                LTRIM(RTRIM(LEFT(co17.ControllingHighBloodPressure, 1))) AS Measurestatus, 
                co17.a_last_update_flag, 
                CO17.A_LAST_UPDATE_DATE, 
                co17.tin
         FROM tmpAet_Careopps co17
         WHERE co17.ControllingHighBloodPressure = 'N'
         UNION
         SELECT DISTINCT 
                co18.MemberID, 
                'MedicationReconciliationPostDischarge' AS Measure, 
                LTRIM(RTRIM(LEFT(co18.MedicationReconciliationPostDischarge, 1))) AS Measurestatus, 
                co18.a_last_update_flag, 
                CO18.A_LAST_UPDATE_DATE, 
                co18.tin
         FROM tmpAet_Careopps co18
         WHERE co18.MedicationReconciliationPostDischarge = 'N'
     ) AS careopp
     --INNER JOIN vw_Aetna_providerRoster p ON CONVERT(INT, p.[tax Id]) = CONVERT(INT, careopp.tin)
     --                                        AND CONVERT(DATE, p.effective_date__C) >=getdate()
     INNER JOIN adi.MbrAetMbrByPcp m ON LTRIM(RTRIM(m.srcMemberId)) = LTRIM(RTRIM(careopp.MemberID))
     INNER JOIN dbo.vw_ActiveMembers a ON LTRIM(RTRIM(a.MEMBER_ID)) = LTRIM(RTRIM(m.AetSubscriberID))
     INNER JOIN
     (
         SELECT *
         FROM ACE_MAP_CAREOPPS_PROGRAMS
         WHERE is_active = 1
     ) MCP ON MCP.SOURCE_MEASURE_NAME = careopp.Measure
              AND MCP.DESTINATION = 'ALTRUISTA'
              AND MCP.IS_ACTIVE = 1
              AND MCP.SOURCE = 'Aetna'
     INNER JOIN
     (
         SELECT *
         FROM [ACE_MAP_PROGRAMS_HEDIS]
         WHERE [Source] = 'hedis'
               AND Destination = 'ALTRUISTA'
     ) AS MH ON MH.Destination_program_name = mCP.DESTINATION_PROGRAM_NAME
     LEFT JOIN
     ( -- Why is this here? The xport ETL has a lookup for the same purpose. GK: 6/5
         SELECT CLIENT_PATIENT_ID, 
                PROGRAM_NAME, 
                START_DATE, 
                end_date, 
                PROGRAM_STATUS_NAME
         FROM Ahs_Altus_Prod.dbo.vw_ACE_ALT_PE
         WHERE YEAR(start_date) = YEAR(GETDATE())
               AND client_patient_id NOT LIKE 'ALT%'
     ) AS pr ON LTRIM(RTRIM(pr.client_patient_id)) = LTRIM(RTRIM(a.MEMBER_ID))
                AND pr.PROGRAM_NAME = mcp.DESTINATION_PROGRAM_NAME
     WHERE careopp.a_last_update_flag = 'Y';  -- THis is how the Care Ops are being Partitioned by date, we need to find a new way.
	-- possibly-- DataDate = (SELECT Max(Datadate) from table) GK: 6/5


  
/****** Object:  View [dbo].[vw_AH_PH_AET_careopps]    Script Date: 6/5/2019 4:07:00 PM ******/  
--SET ANSI_NULLS ON  
--GO  
  
--SET QUOTED_IDENTIFIER ON  
--GO  
--SELECT CONVERT(datetime,CONVERT(NVARCHAR(50), DataDate),101) AS DATE_IDENTIFIED, * FROM [adi].[copAetMaCareopps]  
--SELECT DATADATE, CreatedDate, * FROM [adi].[copAetMaCareopps]  
  
--SELECT * FROM [adi].[copAetMaCareopps]  
--SELECT * FROM [dbo].[vw_AH_PH_AET_careopps]    
--SELECT * FROM SYS.TABLES WHERE NAME LIKE '%copAetMaCareopps%'  
--SELECT * FROM SYS.columns WHERE [NAME] = 'DATADATE'AND OBJECT_ID = 366676404  

--SELECT Top 200 * FROM  [vw_AH_PH_AET_careopps]
  
CREATE  VIEW [vw_AH_PH_AET_careopps]    
AS  
     SELECT DISTINCT   
            MCP.SOURCE AS CLIENT_ID,   
            a.MEMBER_ID AS MEMBER_ID,   
            concat(LTRIM(RTRIM(Mh.SOURCE_MEASURE_ID)), '-', LTRIM(RTRIM(Mh.SOURCE_MEASURE_NAME))) AS OPPURTUNITY,   
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
            CAST(CONVERT(datetime,CONVERT(NVARCHAR(50), careopp.DataDate),101) AS DATE) AS DATE_IDENTIFIED,   
            YEAR(GETDATE()) AS MEASURE_VERSION  
     FROM  
     (  
         SELECT DISTINCT   
                co.MemberID,   
                'AceiArbAdherence' AS Measure,   
                co.AceiArbAdherence Measurestatus,   
                co.CreatedDate,   
                CO.DataDate,   
                co.tin  
         FROM [adi].[copAetMaCareopps] co -- dbo.tmpAet_Careopps: adi.copAetMaCareopps GK: 6/5  
         WHERE co.AceiArbAdherence = 'N'  
         UNION  
         SELECT DISTINCT   
                co1.MemberID,   
                'BreastScreeningCompliance' AS Measure,   
                LTRIM(RTRIM(LEFT(co1.[Breast ScreeningCompliance], 1))) AS Measurestatus,   
                co1.CreatedDate,   
                CO1.DataDate,   
                co1.tin  
         FROM [adi].[copAetMaCareopps] co1  
         WHERE LTRIM(RTRIM(LEFT(co1.[Breast ScreeningCompliance], 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co2.MemberID,   
                'ColorectalScreeningCompliance' AS Measure,   
                LTRIM(RTRIM(LEFT(co2.ColorectalScreeningCompliance, 1))) AS Measurestatus,   
                co2.CreatedDate,   
                CO2.DataDate,   
                co2.tin  
         FROM [adi].[copAetMaCareopps] co2  
         WHERE LTRIM(RTRIM(LEFT(co2.ColorectalScreeningCompliance, 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co3.MemberID,   
                'DiabetesEyeExam' AS Measure,   
                LTRIM(RTRIM(LEFT(co3.DiabetesEyeExam, 1))) AS Measurestatus,   
                co3.CreatedDate,   
                CO3.DataDate,   
                co3.tin  
         FROM [adi].[copAetMaCareopps] co3  
         WHERE LTRIM(RTRIM(LEFT(co3.DiabetesEyeExam, 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co4.MemberID,   
                'DiabetesNephropathyScreening' AS Measure,   
                LTRIM(RTRIM(LEFT(co4.DiabetesNephropathyScreening, 1))) AS Measurestatus,   
                co4.CreatedDate,   
                CO4.DataDate,   
                co4.tin  
         FROM [adi].[copAetMaCareopps] co4  
         WHERE LTRIM(RTRIM(LEFT(co4.DiabetesNephropathyScreening, 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co5.MemberID,   
                'DiabetesLdlControl' AS Measure,   
                LTRIM(RTRIM(LEFT(co5.DiabetesLdlControl, 1))) AS Measurestatus,   
                co5.CreatedDate,   
                CO5.DataDate,   
                co5.tin  
         FROM [adi].[copAetMaCareopps] co5  
         WHERE LTRIM(RTRIM(LEFT(co5.DiabetesLdlControl, 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co6.MemberID,   
                'DiabetesMedicationAdherence' AS Measure,   
                co6.DiabetesMedicationAdherence AS Measurestatus,   
                co6.CreatedDate,   
                CO6.DataDate,   
                co6.tin  
         FROM [adi].[copAetMaCareopps] co6  
         WHERE LTRIM(RTRIM(LEFT(co6.DiabetesMedicationAdherence, 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co7.MemberID,   
                'DiabetesControlledHbA1c' AS Measure,   
                LTRIM(RTRIM(LEFT(co7.DiabetesControlledHbA1c, 1))) AS Measurestatus,   
                co7.CreatedDate,   
                CO7.DataDate,   
                co7.tin  
         FROM [adi].[copAetMaCareopps] co7  
         WHERE LTRIM(RTRIM(LEFT(co7.DiabetesControlledHbA1c, 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co8.MemberID,   
                'StatinUseInDiabetics' AS Measure,   
                LTRIM(RTRIM(LEFT(co8.StatinUseInDiabetics, 1))) AS Measurestatus,   
                co8.CreatedDate,   
                CO8.DataDate,   
                co8.tin  
         FROM [adi].[copAetMaCareopps] co8  
         WHERE LTRIM(RTRIM(LEFT(co8.StatinUseInDiabetics, 1))) = 'N'  
         UNION  
         SELECT DISTINCT   
                co9.MemberID,   
                'StatinMedicationAdherence' AS Measure,   
                LTRIM(RTRIM(LEFT(co9.StatinMedicationAdherence, 1))) AS Measurestatus,   
                co9.CreatedDate,   
                CO9.DataDate,   
                co9.tin  
         FROM [adi].[copAetMaCareopps] co9  
         WHERE co9.StatinMedicationAdherence = 'N'  
         UNION  
         SELECT DISTINCT   
                co10.MemberID,   
                'OsteoporosisManagement' AS Measure,   
                LTRIM(RTRIM(co10.OsteoporosisManagement)) AS Measurestatus,   
                co10.CreatedDate,   
                CO10.DataDate,   
                co10.tin  
         FROM [adi].[copAetMaCareopps] co10  
         WHERE co10.OsteoporosisManagement = 'N'  
         UNION  
         SELECT DISTINCT   
                co11.MemberID,   
                'RheumatoidArthritisManagement' AS Measure,   
                LTRIM(RTRIM(co11.RheumatoidArthritisManagement)) AS Measurestatus,   
                co11.CreatedDate,   
                CO11.DataDate,   
                co11.tin  
         FROM [adi].[copAetMaCareopps] co11  
         WHERE co11.RheumatoidArthritisManagement = 'N'  
         UNION  
         SELECT DISTINCT   
                co12.MemberID,   
                'AdultBMIAssessment' AS Measure,   
                LTRIM(RTRIM(LEFT(co12.AdultBMIAssessment, 1))) AS Measurestatus,   
                co12.CreatedDate,   
                CO12.DataDate,   
                co12.tin  
         FROM [adi].[copAetMaCareopps] co12  
         WHERE co12.AdultBMIAssessment = 'N'  
         UNION  
         SELECT DISTINCT   
                co13.MemberID,   
                'LastOfficeVisit' AS Measure,   
                LTRIM(RTRIM(LEFT(co13.LastOfficeVisit, 1))) AS Measurestatus,   
                co13.CreatedDate,   
                CO13.DataDate,   
                co13.tin  
         FROM [adi].[copAetMaCareopps] co13  
         WHERE co13.LastOfficeVisit = 'N'  
         UNION  
         SELECT DISTINCT   
                co14.MemberID,   
                'OfficeVisits-Chronic1stHalf' AS Measure,   
                LTRIM(RTRIM(LEFT(co14.[OfficeVisits-Chronic1stHalf], 1))) AS Measurestatus,   
                co14.CreatedDate,   
                CO14.DataDate,   
                co14.tin  
         FROM [adi].[copAetMaCareopps] co14  
         WHERE co14.[OfficeVisits-Chronic1stHalf] = '0'  
         UNION  
         SELECT DISTINCT   
                co15.MemberID,   
                'OfficeVisits-Chronic2ndHalf' AS Measure,   
                LTRIM(RTRIM(LEFT(co15.[Office Visits-Chronic2ndHalf], 1))) AS Measurestatus,   
                co15.CreatedDate,   
                CO15.DataDate,   
                co15.tin  
         FROM [adi].[copAetMaCareopps] co15  
         WHERE co15.[Office Visits-Chronic2ndHalf] = '0'  
         UNION  
         SELECT DISTINCT   
                co16.MemberID,   
                'AnnualFluVaccine' AS Measure,   
                LTRIM(RTRIM(LEFT(co16.AnnualFluVaccine, 1))) AS Measurestatus,   
                co16.CreatedDate,   
                CO16.DataDate,   
                co16.tin  
         FROM [adi].[copAetMaCareopps] co16  
         WHERE co16.AnnualFluVaccine = 'N'  
         UNION  
         SELECT DISTINCT   
                co17.MemberID,   
                'ControllingHighBloodPressure' AS Measure,   
                LTRIM(RTRIM(LEFT(co17.ControllingHighBloodPressure, 1))) AS Measurestatus,   
                co17.CreatedDate,   
                CO17.DataDate,   
                co17.tin  
         FROM [adi].[copAetMaCareopps] co17  
         WHERE co17.ControllingHighBloodPressure = 'N'  
         UNION  
         SELECT DISTINCT   
                co18.MemberID,   
                'MedicationReconciliationPostDischarge' AS Measure,   
                LTRIM(RTRIM(LEFT(co18.MedicationReconciliationPostDischarge, 1))) AS Measurestatus,   
                co18.CreatedDate,   
                CO18.DataDate,   
                co18.tin  
         FROM [adi].[copAetMaCareopps] co18  
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
     WHERE careopp.DataDate = (SELECT Max(Datadate) from [adi].[copAetMaCareopps] );  -- THis is how the Care Ops are being Partitioned by date, we need to find a new way.  
 -- possibly-- DataDate = (SELECT Max(Datadate) from table) GK: 6/5  
  
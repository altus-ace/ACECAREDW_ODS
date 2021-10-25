


CREATE VIEW [adi].[vw_PdwSrc_CopAetMa_Careopps]
AS
    -- Encapsulates the de pivot logic for the Aetna MA Care Opps
    /* Version History:
    12/03/2020: GK Changed co6 DIabetes medication adherence to be 'y' and a numeric region of values. per change in requirement

    */
     SELECT DISTINCT
            1 AS ClientKey ,
            adiData_Unpivot.MemberID Adi_MemberID,
		  ConvertMemberID.member_id srcClientMemberKey,
            adiData_Unpivot.Measure, 
		  adiData_Unpivot.Measurestatus,
		  adiData_Unpivot.TIN,
		  adiData_Unpivot.DataDate,
		  adiData_Unpivot.CreatedDate          
            
     FROM
(
    SELECT  DISTINCT
           co.MemberID,
           'Ace/ArbAdherence' AS Measure,
           co.AceiArbAdherence Measurestatus,
           co.CreatedDate,
           CO.DataDate,
           co.tin, co.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co
    WHERE co.AceiArbAdherence = 'Y'
	--AND   CONVERT(numeric(4,2),left(LTRIM(RTRIM(CO.[Acei ArbPDCYTD])),4)) BETWEEN 0.85 AND 0.95
	AND   CONVERT(numeric(4,2),left(LTRIM(RTRIM(CO.[Acei ArbPDCYTD])),4)) BETWEEN 0.70  AND 0.95	
	/* here */
	
    UNION
    SELECT DISTINCT
           co1.MemberID,
           'BreastScreeningCompliance' AS Measure,
           LTRIM(RTRIM(LEFT(co1.[Breast ScreeningCompliance], 1))) AS Measurestatus,
           co1.CreatedDate,
           CO1.DataDate,
           co1.tin, co1.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co1
    WHERE LTRIM(RTRIM(LEFT(co1.[Breast ScreeningCompliance], 1))) = 'N'
    UNION
    SELECT DISTINCT
           co2.MemberID,
           'ColorectalScreeningCompliance' AS Measure,
           LTRIM(RTRIM(LEFT(co2.ColorectalScreeningCompliance, 1))) AS Measurestatus,
           co2.CreatedDate,
           CO2.DataDate,
           co2.tin,co2.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co2
    WHERE LTRIM(RTRIM(LEFT(co2.ColorectalScreeningCompliance, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co3.MemberID,
           'DiabetesEyeExam' AS Measure,
           LTRIM(RTRIM(LEFT(co3.DiabetesEyeExam, 1))) AS Measurestatus,
           co3.CreatedDate,
           CO3.DataDate,
           co3.tin,co3.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co3
    WHERE LTRIM(RTRIM(LEFT(co3.DiabetesEyeExam, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co4.MemberID,
           'DiabetesNephropathyScreening' AS Measure,
           LTRIM(RTRIM(LEFT(co4.DiabetesNephropathyScreening, 1))) AS Measurestatus,
           co4.CreatedDate,
           CO4.DataDate,
           co4.tin,co4.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co4
    WHERE LTRIM(RTRIM(LEFT(co4.DiabetesNephropathyScreening, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co5.MemberID,
           'DiabetesLdlControl' AS Measure,
           LTRIM(RTRIM(LEFT(co5.DiabetesLdlControl, 1))) AS Measurestatus,
           co5.CreatedDate,
           CO5.DataDate,
           co5.tin,co5.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co5
    WHERE LTRIM(RTRIM(LEFT(co5.DiabetesLdlControl, 1))) = 'N'
    UNION
    
    SELECT DISTINCT
           co6.MemberID,
           'DiabetesMedicationAdherence' AS Measure,
           co6.DiabetesMedicationAdherence AS Measurestatus,
           co6.CreatedDate,
           CO6.DataDate,
           co6.tin,co6.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co6
    WHERE LTRIM(RTRIM(LEFT(co6.DiabetesMedicationAdherence, 1))) = 'Y'
	   --AND   CONVERT(numeric(4,2),left(LTRIM(RTRIM(co6.DiabetesMedicationPDCYTD)),4)) BETWEEN 0.85 AND 0.95
	   AND   CONVERT(numeric(4,2),left(LTRIM(RTRIM(co6.DiabetesMedicationPDCYTD)),4)) BETWEEN 0.70  AND 0.95		   
    UNION
    SELECT DISTINCT
           co7.MemberID,
           'DiabetesControlledHbA1c' AS Measure,
           LTRIM(RTRIM(LEFT(co7.DiabetesControlledHbA1c, 1))) AS Measurestatus,
           co7.CreatedDate,
           CO7.DataDate,
           co7.tin,co7.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co7
    WHERE LTRIM(RTRIM(LEFT(co7.DiabetesControlledHbA1c, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co8.MemberID,
           'StatinUseInDiabetics' AS Measure,
           LTRIM(RTRIM(LEFT(co8.StatinUseInDiabetics, 1))) AS Measurestatus,
           co8.CreatedDate,
           CO8.DataDate,
           co8.tin,co8.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co8
    WHERE LTRIM(RTRIM(LEFT(co8.StatinUseInDiabetics, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co9.MemberID,
           'StatinMedicationAdherence' AS Measure,
           LTRIM(RTRIM(LEFT(co9.StatinMedicationAdherence, 1))) AS Measurestatus,
           co9.CreatedDate,
           CO9.DataDate,
           co9.tin,co9.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co9
    WHERE co9.StatinMedicationAdherence = 'Y'
	--AND  convert(numeric(4,2),left(LTRIM(RTRIM(co9.StatinMedicationPDCYTD)),4)) BETWEEN 0.85 AND 0.95
	AND   CONVERT(numeric(4,2),left(LTRIM(RTRIM(co9.StatinMedicationPDCYTD)),4)) BETWEEN 0.70  AND 0.95	
	/* Here */
    UNION
    SELECT DISTINCT
           co10.MemberID,
           'OsteoporosisManagement' AS Measure,
           LTRIM(RTRIM(co10.OsteoporosisManagement)) AS Measurestatus,
           co10.CreatedDate,
           CO10.DataDate,
           co10.tin,co10.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co10
    WHERE co10.OsteoporosisManagement = 'N'
    UNION
    SELECT DISTINCT
           co11.MemberID,
           'RheumatoidArthritisManagement' AS Measure,
           LTRIM(RTRIM(co11.RheumatoidArthritisManagement)) AS Measurestatus,
           co11.CreatedDate,
           CO11.DataDate,
           co11.tin,co11.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co11
    WHERE co11.RheumatoidArthritisManagement = 'N'
    UNION
    SELECT DISTINCT
           co12.MemberID,
           'AdultBMIAssessment' AS Measure,
           LTRIM(RTRIM(LEFT(co12.AdultBMIAssessment, 1))) AS Measurestatus,
           co12.CreatedDate,
           CO12.DataDate,
           co12.tin,co12.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co12
    WHERE co12.AdultBMIAssessment = 'N'
    UNION
    SELECT DISTINCT
           co13.MemberID,
           'LastOfficeVisit' AS Measure,
           LTRIM(RTRIM(LEFT(co13.LastOfficeVisit, 1))) AS Measurestatus,
           co13.CreatedDate,
           CO13.DataDate,
           co13.tin,co13.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co13
    WHERE co13.LastOfficeVisit = 'N'
    UNION
    SELECT DISTINCT
           co14.MemberID,
           'OfficeVisits-Chronic1stHalf' AS Measure,
           LTRIM(RTRIM(LEFT(co14.[OfficeVisits-Chronic1stHalf], 1))) AS Measurestatus,
           co14.CreatedDate,
           CO14.DataDate,
           co14.tin,co14.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co14
    WHERE co14.[OfficeVisits-Chronic1stHalf] = '0'
    UNION
    SELECT DISTINCT
           co15.MemberID,
           'OfficeVisits-Chronic2ndHalf' AS Measure,
           LTRIM(RTRIM(LEFT(co15.[Office Visits-Chronic2ndHalf], 1))) AS Measurestatus,
           co15.CreatedDate,
           CO15.DataDate,
           co15.tin,co15.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co15
    WHERE co15.[Office Visits-Chronic2ndHalf] = '0'
	and co15.chronicdisease <> ''
    UNION
    SELECT DISTINCT
           co16.MemberID,
           'AnnualFluVaccine' AS Measure,
           LTRIM(RTRIM(LEFT(co16.AnnualFluVaccine, 1))) AS Measurestatus,
           co16.CreatedDate,
           CO16.DataDate,
           co16.tin, co16.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co16
    WHERE co16.AnnualFluVaccine = 'N'
    UNION
    SELECT DISTINCT
           co17.MemberID,
           'ControllingHighBloodPressure' AS Measure,
           LTRIM(RTRIM(LEFT(co17.ControllingHighBloodPressure, 1))) AS Measurestatus,
           co17.CreatedDate,
           CO17.DataDate,
           co17.tin, co17.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co17
    WHERE co17.ControllingHighBloodPressure = 'N'
    UNION
    SELECT DISTINCT
           co18.MemberID,
           'MedicationReconciliationPostDischarge' AS Measure,
           LTRIM(RTRIM(LEFT(co18.MedicationReconciliationPostDischarge, 1))) AS Measurestatus,
           co18.CreatedDate,
           CO18.DataDate,
           co18.tin, co18.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co18
    WHERE co18.MedicationReconciliationPostDischarge = 'N'
	 UNION
	 /* Added a new measure. 
	 **It will return the diabetesHba1C level where row is not null and is greater than 8.5
	 */
    SELECT DISTINCT
           co19.MemberID,
           'Diabetes Hba1C Level' AS Measure,
           LTRIM(RTRIM(LEFT(co19.[DiabetesHba1C Level], 1))) AS Measurestatus,
           co19.CreatedDate,
           CO19.DataDate,
           co19.tin,co19.copAetMaCareoppsKey
    FROM [adi].[copAetMaCareopps] co19
    WHERE co19.[DiabetesHba1C Level]<> ''
    --and TRY_CONVERT(DECIMAL(4,2),LTRIM(RTRIM(LEFT([DiabetesHba1C Level], 4))))  >= 8.5 this is a business rule do this in stg
   
) AS adiData_Unpivot
INNER JOIN adi.copAetMaCareopps CurLoad ON CurLoad.copAetMaCareoppsKey = adiData_Unpivot.copAetMaCareoppsKey
INNER JOIN adi.MbrAetMaTx ConvertMemberID on LTRIM(RTRIM(ConvertMemberID .Member_Source_Member_ID))=LTRIM(RTRIM(adiData_Unpivot.MemberID))
WHERE CurLoad.CopStgLoadStatus = 0
    

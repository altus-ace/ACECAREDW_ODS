
--select top 10 * from [adi].[vw_AetMa_CareOps_Validation]
CREATE view [adi].[vw_AetMa_CareOps_Validation]
AS
    -- Version: gK: changed end date to be end of current year (2020)
    /* VERSION HISTORY:
    12/03/2020: GK: CHanged c06 Diabetes Med Adherence to USe "Y" and a numeric range of PDCYTD 
    04/08 removed filter for copStgLoadStatus and data date
    */
     SELECT DISTINCT
            'Aetna' AS CLIENT_ID,
            MCP.DESTINATION_PROGRAM_NAME AS PROGRAM_NAME,
            a.MEMBER_ID AS MEMBER_ID,
            CONVERT(VARCHAR(10), DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0), 120) AS ENROLL_DATE,
            CONVERT(DATE, careopp.DataDate, 101) AS CREATE_DATE,
            CONVERT(DATE, '12/31/2021', 101) AS ENROLL_END_DATE,
            CONVERT(NVARCHAR, RTRIM('ACTIVE')) AS PROGRAM_STATUS,
            'Enrolled in a Program' AS REASON_DESCRIPTION,
            'Aetna CareOpps' AS REFERAL_TYPE
		  , careopp.*
     FROM
(
    SELECT  DISTINCT
           co.MemberID,
           'AceiArbAdherence' AS Measure,
           co.AceiArbAdherence Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus		 
    FROM [adi].[copAetMaCareopps] co
    WHERE co.AceiArbAdherence = 'Y'
	AND   CONVERT(numeric(4,2),left(LTRIM(RTRIM(CO.[Acei ArbPDCYTD])),4)) BETWEEN 0.85 AND 0.95
	
    UNION
    SELECT DISTINCT
           co.MemberID,
           'BreastScreeningCompliance' AS Measure,
           LTRIM(RTRIM(LEFT(co.[Breast ScreeningCompliance], 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.[Breast ScreeningCompliance], 1))) = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'ColorectalScreeningCompliance' AS Measure,
           LTRIM(RTRIM(LEFT(co.ColorectalScreeningCompliance, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.ColorectalScreeningCompliance, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'DiabetesEyeExam' AS Measure,
           LTRIM(RTRIM(LEFT(co.DiabetesEyeExam, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.DiabetesEyeExam, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'DiabetesNephropathyScreening' AS Measure,
           LTRIM(RTRIM(LEFT(co.DiabetesNephropathyScreening, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.DiabetesNephropathyScreening, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'DiabetesLdlControl' AS Measure,
           LTRIM(RTRIM(LEFT(co.DiabetesLdlControl, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.DiabetesLdlControl, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'DiabetesMedicationAdherence' AS Measure,
           co.DiabetesMedicationAdherence AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.DiabetesMedicationAdherence, 1))) = 'Y'
	   AND  convert(numeric(4,2),left(LTRIM(RTRIM(co.DiabetesMedicationPDCYTD)),4)) BETWEEN 0.85 AND 0.95
    UNION
    SELECT DISTINCT
           co.MemberID,
           'DiabetesControlledHbA1c' AS Measure,
           LTRIM(RTRIM(LEFT(co.DiabetesControlledHbA1c, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.DiabetesControlledHbA1c, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'StatinUseInDiabetics' AS Measure,
           LTRIM(RTRIM(LEFT(co.StatinUseInDiabetics, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE LTRIM(RTRIM(LEFT(co.StatinUseInDiabetics, 1))) = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'StatinMedicationAdherence' AS Measure,
           LTRIM(RTRIM(LEFT(co.StatinMedicationAdherence, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.StatinMedicationAdherence = 'Y'
	AND  convert(numeric(4,2),left(LTRIM(RTRIM(co.StatinMedicationPDCYTD)),4)) BETWEEN 0.85 AND 0.95

    UNION
    SELECT DISTINCT
           co.MemberID,
           'OsteoporosisManagement' AS Measure,
           LTRIM(RTRIM(co.OsteoporosisManagement)) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.OsteoporosisManagement = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'RheumatoidArthritisManagement' AS Measure,
           LTRIM(RTRIM(co.RheumatoidArthritisManagement)) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.RheumatoidArthritisManagement = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'AdultBMIAssessment' AS Measure,
           LTRIM(RTRIM(LEFT(co.AdultBMIAssessment, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.AdultBMIAssessment = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'LastOfficeVisit' AS Measure,
           LTRIM(RTRIM(LEFT(co.LastOfficeVisit, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.LastOfficeVisit = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'OfficeVisits-Chronic1stHalf' AS Measure,
           LTRIM(RTRIM(LEFT(co.[OfficeVisits-Chronic1stHalf], 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.[OfficeVisits-Chronic1stHalf] = '0'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'OfficeVisits-Chronic2ndHalf' AS Measure,
           LTRIM(RTRIM(LEFT(co.[Office Visits-Chronic2ndHalf], 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.[Office Visits-Chronic2ndHalf] = '0'
	and co.chronicdisease <> ''
    UNION
    SELECT DISTINCT
           co.MemberID,
           'AnnualFluVaccine' AS Measure,
           LTRIM(RTRIM(LEFT(co.AnnualFluVaccine, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.AnnualFluVaccine = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'ControllingHighBloodPressure' AS Measure,
           LTRIM(RTRIM(LEFT(co.ControllingHighBloodPressure, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.ControllingHighBloodPressure = 'N'
    UNION
    SELECT DISTINCT
           co.MemberID,
           'MedicationReconciliationPostDischarge' AS Measure,
           LTRIM(RTRIM(LEFT(co.MedicationReconciliationPostDischarge, 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.MedicationReconciliationPostDischarge = 'N'
	 UNION
	 /* Added a new measure. 
	 **It will return the diabetesHba1C level WHERE row is not null and is greater than 8.5
	 */
    SELECT DISTINCT
           co.MemberID,
           'Diabetes Hba1C Level' AS Measure,
           LTRIM(RTRIM(LEFT(co.[DiabetesHba1C Level], 1))) AS Measurestatus,
           co.CreatedDate,
           CO.DataDate,Co.LoadDate, Co.copAetMaCareoppsKey,
           co.tin, co.CopStgLoadStatus
    FROM [adi].[copAetMaCareopps] co
    WHERE co.[DiabetesHba1C Level]<> ''
and TRY_CONVERT(DECIMAL(4,2),LTRIM(RTRIM(LEFT([DiabetesHba1C Level], 4))))  >= 8.5 
) AS careopp
--INNER JOIN vw_Aetna_providerRoster p ON CONVERT(INT, p.[tax Id]) = CONVERT(INT, careopp.tin)
   --                                   AND CONVERT(DATE, p.effective_date__C) BETWEEN '01/01/2018' AND '08/12/2018'
Inner join adi.MbrAetMaTx m on LTRIM(RTRIM(m.Member_Source_Member_ID))=LTRIM(RTRIM(careopp.MemberID))
INNER JOIN ACECAREDW.dbo.vw_ActiveMembers a ON LTRIM(RTRIM(a.MEMBER_ID)) = CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0),m.MEMBER_ID))
INNER JOIN [ACECAREDW].[dbo].[ACE_MAP_CAREOPPS_PROGRAMS] MCP ON MCP.SOURCE_MEASURE_NAME = careopp.Measure
                                                                AND MCP.DESTINATION = 'ALTRUISTA'
                                                                AND MCP.IS_ACTIVE = 1
     --WHERE careopp.DataDate = (SELECT MAX(DataDate) FROM [adi].[copAetMaCareopps])
	   --and careOpp.CopStgLoadStatus = 0 



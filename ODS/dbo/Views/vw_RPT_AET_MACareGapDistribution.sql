




/**************************************************************
Created by : RA
Create Date : 10/07/2019
Description : 
# 1578 - CareGap Distribution rpt for AAET MA from ADI tables , for Quality team
			
Modification:
 Date		User   Comment
10/09/2019   AC		Added DOB column and case statement 		
11/18/2019   AC       Updated column to  TRY_CONVERT(DECIMAL(4,2),LTRIM(RTRIM(LEFT([DiabetesHba1C Level], 4)))) from CONVERT(numeric(4,2),left(LTRIM(RTRIM(CO.[Acei ArbPDCYTD])),4))
					

******************************************************************/

CREATE VIEW [dbo].[vw_RPT_AET_MACareGapDistribution]
AS
SELECT DISTINCT 
			A.CLIENT_SUBSCRIBER_ID,
			cc.member_id,
            A.MEMBER_LAST_NAME+','+A.MEMBER_FIRST_NAME as 'Member_Name', 
            A.MEMBER_MI, 
            A.MEMBER_HOME_ADDRESS, 
            A.MEMBER_HOME_ADDRESS2, 
            A.MEMBER_HOME_CITY, 
            A.MEMBER_HOME_STATE, 
            A.MEMBER_HOME_ZIP_C, 
            A.GENDER, 
            A.AGE, 
			A.DATE_OF_BIRTH,
            A.PCP_NAME, 
            A.PCP_PRACTICE_NAME, 
            A.PCP_PRACTICE_TIN, 
			A.member_home_phone,
			case when A.member_home_phone is NULL then 'NA' else A.member_home_phone  end as 'Phone' ,
            CC.PROGRAM_NAME
     FROM VW_ACTIVEMEMBERS A
        right  JOIN 
		(
		     SELECT DISTINCT
		            'Aetna' AS CLIENT_ID,
            MCP.DESTINATION_PROGRAM_NAME AS PROGRAM_NAME,
            a.MEMBER_ID AS MEMBER_ID,
            CONVERT(VARCHAR(10), DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0), 120) AS ENROLL_DATE,
            CONVERT(DATE, careopp.DataDate, 101) AS CREATE_DATE,
            CONVERT(DATE, '12/31/2019', 101) AS ENROLL_END_DATE,
            CONVERT(NVARCHAR, RTRIM('ACTIVE')) AS PROGRAM_STATUS,
            'Enrolled in a Program' AS REASON_DESCRIPTION,
            'Aetna CareOpps' AS REFERAL_TYPE
     FROM
(
    SELECT  DISTINCT
           co.MemberID,
           'AceiArbAdherence' AS Measure,
           co.AceiArbAdherence Measurestatus,
           co.CreatedDate,
           CO.DataDate,
           co.tin
    FROM [adi].[copAetMaCareopps] co
    WHERE co.AceiArbAdherence = 'Y'
	AND   CONVERT(decimal(4,2),left(LTRIM(RTRIM(CO.[Acei ArbPDCYTD])),4)) BETWEEN 0.85 AND 0.95
	
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
    WHERE co9.StatinMedicationAdherence = 'Y'
	AND  convert(decimal(4,2),left(LTRIM(RTRIM(co9.StatinMedicationPDCYTD)),4)) BETWEEN 0.85 AND 0.95

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
	and co15.chronicdisease <> ''
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
	 UNION
	 /* Added a new measure. 
	 **It will return the diabetesHba1C level where row is not null and is greater than 8.5
	 */
    SELECT DISTINCT
           co19.MemberID,
           'Diabetes Hba1C Level' AS Measure,
           LTRIM(RTRIM(LEFT([DiabetesHba1C Level], 4))) AS Measurestatus,
           co19.CreatedDate,
           CO19.DataDate,
           co19.tin
    FROM [adi].[copAetMaCareopps] co19
    WHERE co19.[DiabetesHba1C Level]<> ''
and TRY_CONVERT(DECIMAL(4,2),LTRIM(RTRIM(LEFT([DiabetesHba1C Level], 4)))) >= 8.5 
) AS careopp
--INNER JOIN vw_Aetna_providerRoster p ON CONVERT(INT, p.[tax Id]) = CONVERT(INT, careopp.tin)
   --                                   AND CONVERT(DATE, p.effective_date__C) BETWEEN '01/01/2018' AND '08/12/2018'
Inner join adi.MbrAetMaTx m on LTRIM(RTRIM(m.Member_Source_Member_ID))=LTRIM(RTRIM(careopp.MemberID))
INNER JOIN ACECAREDW.dbo.vw_ActiveMembers a ON LTRIM(RTRIM(a.MEMBER_ID)) = CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0),m.MEMBER_ID))
INNER JOIN [ACECAREDW].[dbo].[ACE_MAP_CAREOPPS_PROGRAMS] MCP ON MCP.SOURCE_MEASURE_NAME = careopp.Measure
                                                                AND MCP.DESTINATION = 'ALTRUISTA'
                                                         
     WHERE careopp.DataDate = (SELECT MAX(DataDate) FROM [adi].[copAetMaCareopps])
		
		) cc ON cc.MEMBER_ID =  A.CLIENT_SUBSCRIBER_ID 
		where a.CLIENT ='Aet'

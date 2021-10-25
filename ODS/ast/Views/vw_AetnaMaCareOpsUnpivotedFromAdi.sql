










CREATE VIEW [ast].[vw_AetnaMaCareOpsUnpivotedFromAdi]
as
    -- Version: gK: changed end date to be end of current year (2020)
    /* VERSION HISTORY:
    12/03/2020: GK: CHanged c06 Diabetes Med Adherence to USe "Y" and a numeric range of PDCYTD 
	2021-08-01: Brit: Changed the PDC values for DiabetesMedicationPDCYTD, StatinMedicationPDCYTD. Included this column Acei ArbPDCYTD to read the PDC Values as others
    */
     SELECT DISTINCT

            --'Aetna' AS CLIENT_ID,
            --adiData.Measure AS PROGRAM_NAME,
            --adiMembers.MEMBER_ID AS MEMBER_ID,
            --CONVERT(VARCHAR(10), DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0), 120) AS ENROLL_DATE,
            --CONVERT(DATE, adiData.DataDate, 101) AS CREATE_DATE,
            --CONVERT(DATE, '12/31/2021', 101) AS ENROLL_END_DATE,
            --CONVERT(NVARCHAR, RTRIM('ACTIVE')) AS PROGRAM_STATUS,
            --'Enrolled in a Program' AS REASON_DESCRIPTION,
            --'Aetna CareOpps' AS REFERAL_TYPE,


			 CONVERT(VARCHAR(50), CONVERT(NUMERIC(20, 0), AdiMembers.MEMBER_ID)) AS MemberId,
			adiData.skey,
			adiData.Sourcefilename ,
			adiData.DataDate,
			adiData.LoadDate,
			adiData.LoadStatus,
			adiData.tin as TIN,
			adiData.NPI as NPI,
			adiData.PafSubmission as PafSubmission,
			adiData.OfficeVisits, 
			adiData.LastOfficeVisit, 
			adiData.ChronicDisease, 
			adiData.HTNDiagnosisDate, 
			adiData.ReportAsOf,
			adiData.Measure,
			adiData.Measurestatus,
			adiData.CreatedDate,
			adiData.CreatedBy,
			adiData.LastUpdatedBy,
		    adiData.LastUpdatedDate,
			adiData.qmComp,
			m.Destination AceQmMsrId,
		    listQm.Active LoadtoAST
			,ListQm.MeasureID
     FROM (
	 /* Required changes to overide Column
		 SELECT  DISTINCT
			co.MemberID,
			co.copAetMaCareoppsKey AS skey,
			co.SrcFileName as Sourcefilename ,
			co.DataDate as DataDate,
			co.LoadDAte as LoadDate,
			co.CopStgLoadStatus as LoadStatus,
			co.tin as TIN,
			co.NPI as NPI,
			co.PafSubmission as PafSubmission,
			co.OfficeVisits, 
			co.LastOfficeVisit, 
			co.ChronicDisease, 
			co.HTNDiagnosisDate, 
			co.ReportAsOf, 
			co.CreatedBy,
			co.LastUpdatedBy,
			co.LastUpdatedDate,
			co.CreatedDate,
           
          
         
		  'AceiArbAdherence' AS Measure,
		   co.AceiArbAdherence Measurestatus,
		  CASE WHEN (co.AceiArbAdherence  like 'Y%')  then 'NUM'
          WHEN (co.AceiArbAdherence  like 'N%')  then 'COP' --NEED TO CHECK WITH GEOFF
		  WHEN (TRY_convert(numeric(10,2), co.AceiArbAdherence)BETWEEN 0.70 AND 0.95) then 'COP'
          else 'UNK' end as qmComp

    FROM [adi].[copAetMaCareopps] co
    where isnull(co.AceiArbAdherence, '') != '' -- remove rows not part of Denom
           And co.CopStgLoadStatus = 0*/
  -- UNION

    SELECT DISTINCT
			co1.MemberID,
			co1.copAetMaCareoppsKey AS skey,
			co1.SrcFileName as Sourcefilename ,
			co1.DataDate as DataDate,
			co1.LoadDAte as LoadDate,
			co1.CopStgLoadStatus as LoadStatus,
			co1.tin as TIN,
			co1.NPI as NPI,
			co1.PafSubmission as PafSubmission,
			co1.OfficeVisits, 
			co1.LastOfficeVisit, 
			co1.ChronicDisease, 
			co1.HTNDiagnosisDate, 
			co1.ReportAsOf, 
			co1.CreatedBy,
			co1.LastUpdatedBy,
			co1.LastUpdatedDate,
			co1.CreatedDate,

           'BreastScreeningCompliance' AS Measure,
            LTRIM(RTRIM(LEFT(co1.[Breast ScreeningCompliance], 1))) AS Measurestatus
			, CASE WHEN (co1.[Breast ScreeningCompliance]  like 'Y%')  then 'NUM'
           WHEN (co1.[Breast ScreeningCompliance]  like 'N%')  then 'COP'
          --WHEN (TRY_convert(numeric(10,2), co1.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
          
           
    FROM [adi].[copAetMaCareopps] co1
    where isnull(co1.[Breast ScreeningCompliance] , '') != ''
	And co1.CopStgLoadStatus = 0

	UNION

    SELECT DISTINCT
			co2.MemberID,
			co2.copAetMaCareoppsKey AS skey,
			co2.SrcFileName as Sourcefilename ,
			co2.DataDate as DataDate,
			co2.LoadDAte as LoadDate,
			co2.CopStgLoadStatus as LoadStatus,
			co2.tin as TIN,
			co2.NPI as NPI,
			co2.PafSubmission as PafSubmission,
			co2.OfficeVisits, 
			co2.LastOfficeVisit, 
			co2.ChronicDisease, 
			co2.HTNDiagnosisDate, 
			co2.ReportAsOf, 
			co2.CreatedBy,
			co2.LastUpdatedBy,
		    co2.LastUpdatedDate,
		    co2.CreatedDate,
			
			'ColorectalScreeningCompliance' AS Measure,
            LTRIM(RTRIM(LEFT(co2.ColorectalScreeningCompliance, 1))) AS Measurestatus,
            CASE WHEN (co2.ColorectalScreeningCompliance like 'Y%')  then 'NUM'
          WHEN (co2.ColorectalScreeningCompliance  like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co2
    where isnull(co2.ColorectalScreeningCompliance, '') != ''   -- remove rows not part of Denom
	And co2.CopStgLoadStatus = 0

     UNION

    SELECT DISTINCT
			co3.MemberID,
			co3.copAetMaCareoppsKey AS skey,
			co3.SrcFileName as Sourcefilename ,
			co3.DataDate as DataDate,
			co3.LoadDAte as LoadDate,
			co3.CopStgLoadStatus as LoadStatus,
			co3.tin as TIN,
			co3.NPI as NPI,
			co3.PafSubmission as PafSubmission,
			co3.OfficeVisits, 
			co3.LastOfficeVisit, 
			co3.ChronicDisease, 
			co3.HTNDiagnosisDate, 
			co3.ReportAsOf, 
			co3.CreatedBy,
			co3.LastUpdatedBy,
		    co3.LastUpdatedDate,
			co3.CreatedDate,

           'DiabetesEyeExam' AS Measure,
           LTRIM(RTRIM(LEFT(co3.DiabetesEyeExam, 1))) AS Measurestatus,      
		   CASE WHEN (co3.DiabetesEyeExam like 'Y%')  then 'NUM'
           WHEN (co3.DiabetesEyeExam  like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co3
    where isnull(co3.DiabetesEyeExam, '') != ''   -- remove rows not part of Denom
		And co3.CopStgLoadStatus = 0
    
	UNION


    SELECT DISTINCT
			co4.MemberID,
			co4.copAetMaCareoppsKey AS skey,
			co4.SrcFileName as Sourcefilename ,
			co4.DataDate as DataDate,
			co4.LoadDAte as LoadDate,
			co4.CopStgLoadStatus as LoadStatus,
			co4.tin as TIN,
			co4.NPI as NPI,
			co4.PafSubmission as PafSubmission,
			co4.OfficeVisits, 
			co4.LastOfficeVisit, 
			co4.ChronicDisease, 
			co4.HTNDiagnosisDate, 
			co4.ReportAsOf, 
			co4.CreatedBy,
			co4.LastUpdatedBy,
		    co4.LastUpdatedDate,
			co4.CreatedDate,

           'DiabetesNephropathyScreening' AS Measure,
           LTRIM(RTRIM(LEFT(co4.DiabetesNephropathyScreening, 1))) AS Measurestatus,
          CASE WHEN (co4.DiabetesNephropathyScreening  like 'Y%')  then 'NUM'
          WHEN (co4.DiabetesNephropathyScreening  like 'N%')  then 'COP'
         --WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp

    FROM [adi].[copAetMaCareopps] co4
    where isnull(co4.DiabetesNephropathyScreening, '') != ''   -- remove rows not part of Denom
	And co4.CopStgLoadStatus = 0

    UNION

    SELECT DISTINCT
			co5.MemberID,
			co5.copAetMaCareoppsKey AS skey,
			co5.SrcFileName as Sourcefilename ,
			co5.DataDate as DataDate,
			co5.LoadDAte as LoadDate,
			co5.CopStgLoadStatus as LoadStatus,
			co5.tin as TIN,
			co5.NPI as NPI,
			co5.PafSubmission as PafSubmission,
			co5.OfficeVisits, 
			co5.LastOfficeVisit, 
			co5.ChronicDisease, 
			co5.HTNDiagnosisDate, 
			co5.ReportAsOf, 
			co5.CreatedBy,
			co5.LastUpdatedBy,
		    co5.LastUpdatedDate,
			co5.CreatedDate,
           'DiabetesLdlControl' AS Measure,
           
		   LTRIM(RTRIM(LEFT(co5.DiabetesLdlControl, 1))) AS Measurestatus,
		   CASE WHEN (co5.DiabetesLdlControl  like 'Y%')  then 'NUM'
          WHEN (co5.DiabetesLdlControl  like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp

    FROM [adi].[copAetMaCareopps] co5
    where isnull(co5.DiabetesLdlControl, '') != ''
	And co5.CopStgLoadStatus = 0

	 UNION

    SELECT DISTINCT

            co6.MemberID,
			co6.copAetMaCareoppsKey AS skey,
			co6.SrcFileName as Sourcefilename ,
			co6.DataDate as DataDate,
			co6.LoadDAte as LoadDate,
			co6.CopStgLoadStatus as LoadStatus,
			co6.tin as TIN,
			co6.NPI as NPI,
			co6.PafSubmission as PafSubmission,
			co6.OfficeVisits, 
			co6.LastOfficeVisit, 
			co6.ChronicDisease, 
			co6.HTNDiagnosisDate, 
			co6.ReportAsOf,
			co6.CreatedBy,
			co6.LastUpdatedBy,
            co6.LastUpdatedDate,
		    co6.CreatedDate,
           
		   'DiabetesMedicationPDCYTD' AS Measure,
           co6.DiabetesMedicationAdherence AS Measurestatus,
		   /*Required changes applied by Brit on 8/31/2021*/
		   CASE -- WHEN (co6.DiabetesMedicationAdherence  like 'Y%')  then 'NUM'
          --WHEN (co6.DiabetesMedicationAdherence  like 'N%')  then 'COP' 
		  WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)>= 0.96) then 'NUM'
          WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.60 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co6
    where isnull(co6.DiabetesMedicationAdherence, '') != ''   -- remove rows not part of Denom
	And co6.CopStgLoadStatus = 0
    
	UNION

    SELECT DISTINCT
			co7.MemberID,
			co7.copAetMaCareoppsKey AS skey,
			co7.SrcFileName as Sourcefilename ,
			co7.DataDate as DataDate,
			co7.LoadDAte as LoadDate,
			co7.CopStgLoadStatus as LoadStatus,
			co7.tin as TIN,
			co7.NPI as NPI,
			co7.PafSubmission as PafSubmission,
			co7.OfficeVisits, 
			co7.LastOfficeVisit, 
			co7.ChronicDisease, 
			co7.HTNDiagnosisDate, 
			co7.ReportAsOf,
			co7.CreatedBy,
			co7.LastUpdatedBy,
		    co7.LastUpdatedDate,
			co7.CreatedDate,

           'DiabetesControlledHbA1c' AS Measure,
           LTRIM(RTRIM(LEFT(co7.DiabetesControlledHbA1c, 1))) AS Measurestatus,
		    CASE WHEN (co7.DiabetesControlledHbA1c  like 'Y%')  then 'NUM'
           WHEN (co7.DiabetesControlledHbA1c like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co7
    where isnull(co7.DiabetesControlledHbA1c, '') != ''   -- remove rows not part of Denom
	AND co7.CopStgLoadStatus = 0
   
   UNION

    SELECT DISTINCT
			co8.MemberID,
			co8.copAetMaCareoppsKey AS skey,
			co8.SrcFileName as Sourcefilename ,
			co8.DataDate as DataDate,
			co8.LoadDAte as LoadDate,
			co8.CopStgLoadStatus as LoadStatus,
			co8.tin as TIN,
			co8.NPI as NPI,
			co8.PafSubmission as PafSubmission,
			co8.OfficeVisits, 
			co8.LastOfficeVisit, 
			co8.ChronicDisease, 
			co8.HTNDiagnosisDate, 
			co8.ReportAsOf,
			co8.CreatedBy,
			co8.LastUpdatedBy,
		    co8.LastUpdatedDate,
			co8.CreatedDate,

           'StatinUseInDiabetics' AS Measure,
           LTRIM(RTRIM(LEFT(co8.StatinUseInDiabetics, 1))) AS Measurestatus,
		   CASE WHEN (co8.StatinUseInDiabetics like 'Y%')  then 'NUM'
           WHEN (co8.StatinUseInDiabetics  like 'N%')  then 'COP'
          --WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co8
    where isnull(co8.StatinUseInDiabetics, '') != ''   -- remove rows not part of Denom
	AND co8.CopStgLoadStatus = 0
   
   UNION

    SELECT DISTINCT
			co9.MemberID,
			co9.copAetMaCareoppsKey AS skey,
			co9.SrcFileName as Sourcefilename ,
			co9.DataDate as DataDate,
			co9.LoadDAte as LoadDate,
			co9.CopStgLoadStatus as LoadStatus,
			co9.tin as TIN,
			co9.NPI as NPI,
			co9.PafSubmission as PafSubmission,
			co9.OfficeVisits, 
			co9.LastOfficeVisit, 
			co9.ChronicDisease, 
			co9.HTNDiagnosisDate, 
			co9.ReportAsOf,
			co9.CreatedBy,
			co9.LastUpdatedBy,
		    co9.LastUpdatedDate,
			co9.CreatedDate,

           'StatinMedicationPDCYTD' AS Measure,
           LTRIM(RTRIM(LEFT(co9.StatinMedicationAdherence, 1))) AS Measurestatus,
		   /*Required changes applied by Brit on 8/31/2021*/
		    CASE --WHEN (co9.StatinMedicationAdherence like 'Y%')  then 'NUM'
          -- WHEN (co9.StatinMedicationAdherence like 'N%')  then 'COP'
		  WHEN (TRY_convert(numeric(10,2), co9.StatinMedicationPDCYTD)>= 0.96) then 'NUM'
          WHEN (TRY_convert(numeric(10,2), co9.StatinMedicationPDCYTD)BETWEEN 0.60 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co9
    where isnull(co9.StatinMedicationAdherence, '') != ''   -- remove rows not part of Denom
	AND co9.CopStgLoadStatus = 0
	
	 UNION

    SELECT DISTINCT
			co10.MemberID,
			co10.copAetMaCareoppsKey AS skey,
			co10.SrcFileName as Sourcefilename ,
			co10.DataDate as DataDate,
			co10.LoadDAte as LoadDate,
			co10.CopStgLoadStatus as LoadStatus,
			co10.tin as TIN,
			co10.NPI as NPI,
			co10.PafSubmission as PafSubmission,
			co10.OfficeVisits, 
			co10.LastOfficeVisit, 
			co10.ChronicDisease, 
			co10.HTNDiagnosisDate, 
			co10.ReportAsOf,
			co10.CreatedBy,
			co10.LastUpdatedBy,
		    co10.LastUpdatedDate,
			co10.CreatedDate,

           'OsteoporosisManagement' AS Measure,
           LTRIM(RTRIM(co10.OsteoporosisManagement)) AS Measurestatus,
		  CASE WHEN (co10.OsteoporosisManagement  like 'Y%')  then 'NUM'
          WHEN (co10.OsteoporosisManagement  like 'N%')  then 'COP'
          --WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co10
    where isnull(co10.OsteoporosisManagement, '') != ''   -- remove rows not part of Denom
    	AND co10.CopStgLoadStatus = 0
    
	UNION

    SELECT DISTINCT
			co11.MemberID,
			co11.copAetMaCareoppsKey AS skey,
			co11.SrcFileName as Sourcefilename ,
			co11.DataDate as DataDate,
			co11.LoadDAte as LoadDate,
			co11.CopStgLoadStatus as LoadStatus,
			co11.tin as TIN,
			co11.NPI as NPI,
			co11.PafSubmission as PafSubmission,
			co11.OfficeVisits, 
			co11.LastOfficeVisit, 
			co11.ChronicDisease, 
			co11.HTNDiagnosisDate, 
			co11.ReportAsOf,
			co11.CreatedBy,
			co11.LastUpdatedBy,
		    co11.LastUpdatedDate,
			co11.CreatedDate,

           'RheumatoidArthritisManagement' AS Measure,
           LTRIM(RTRIM(co11.RheumatoidArthritisManagement)) AS Measurestatus,
		   CASE WHEN (co11.RheumatoidArthritisManagement  like 'Y%')  then 'NUM'
          WHEN (co11.RheumatoidArthritisManagement  like 'N')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co11
    where isnull(co11.RheumatoidArthritisManagement, '') != ''   -- remove rows not part of Denom
    	AND co11.CopStgLoadStatus = 0

		UNION
    SELECT DISTINCT
			co12.MemberID,
			co12.copAetMaCareoppsKey AS skey,
			co12.SrcFileName as Sourcefilename ,
			co12.DataDate as DataDate,
			co12.LoadDAte as LoadDate,
			co12.CopStgLoadStatus as LoadStatus,
			co12.tin as TIN,
			co12.NPI as NPI,
			co12.PafSubmission as PafSubmission,
			co12.OfficeVisits, 
			co12.LastOfficeVisit, 
			co12.ChronicDisease, 
			co12.HTNDiagnosisDate, 
			co12.ReportAsOf,
			co12.CreatedBy,
			co12.LastUpdatedBy,
		    co12.LastUpdatedDate,
			co12.CreatedDate ,
           
		   'AdultBMIAssessment' AS Measure,
           LTRIM(RTRIM(LEFT(co12.AdultBMIAssessment, 1))) AS Measurestatus,
		 CASE WHEN ( co12.AdultBMIAssessment  like 'Y%')  then 'NUM'
          WHEN ( co12.AdultBMIAssessment  like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co12
    where isnull( co12.AdultBMIAssessment, '') != ''   -- remove rows not part of Denom
	AND co12.CopStgLoadStatus = 0
	
	UNION

    SELECT DISTINCT
			co13.MemberID,
			co13.copAetMaCareoppsKey AS skey,
			co13.SrcFileName as Sourcefilename ,
			co13.DataDate as DataDate,
			co13.LoadDAte as LoadDate,
			co13.CopStgLoadStatus as LoadStatus,
			co13.tin as TIN,
			co13.NPI as NPI,
			co13.PafSubmission as PafSubmission,
			co13.OfficeVisits, 
			co13.LastOfficeVisit, 
			co13.ChronicDisease, 
			co13.HTNDiagnosisDate, 
			co13.ReportAsOf,
			co13.CreatedBy,
			co13.LastUpdatedBy,
		    co13.LastUpdatedDate,
			co13.CreatedDate,

            'LastOfficeVisit' AS Measure,
            LTRIM(RTRIM(LEFT(co13.LastOfficeVisit, 1))) AS Measurestatus,
			CASE WHEN (co13.LastOfficeVisit  like 'Y%')  then 'NUM'
            WHEN (co13.LastOfficeVisit  like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co13
    where isnull(co13.LastOfficeVisit, '') != ''   -- remove rows not part of Denom
    	AND co13.CopStgLoadStatus = 0

		UNION

    SELECT DISTINCT
            co14.MemberID,
			co14.copAetMaCareoppsKey AS skey,
			co14.SrcFileName as Sourcefilename ,
			co14.DataDate as DataDate,
			co14.LoadDAte as LoadDate,
			co14.CopStgLoadStatus as LoadStatus,
			co14.tin as TIN,
			co14.NPI as NPI,
			co14.PafSubmission as PafSubmission,
			co14.OfficeVisits, 
			co14.LastOfficeVisit, 
			co14.ChronicDisease, 
			co14.HTNDiagnosisDate, 
			co14.ReportAsOf,
			co14.CreatedBy,
			co14.LastUpdatedBy,
		    co14.LastUpdatedDate,
			co14.CreatedDate,

           'OfficeVisits-Chronic1stHalf' AS Measure,
           LTRIM(RTRIM(LEFT(co14.[OfficeVisits-Chronic1stHalf], 1))) AS Measurestatus,
		  		   'UNK' as qmComp
    FROM [adi].[copAetMaCareopps] co14
     where isnull(co14.[OfficeVisits-Chronic1stHalf], '') != ''   -- remove rows not part of Denom
	     	AND co14.CopStgLoadStatus = 0
			
			
	UNION

    SELECT DISTINCT
			co15.MemberID,
			co15.copAetMaCareoppsKey AS skey,
			co15.SrcFileName as Sourcefilename ,
			co15.DataDate as DataDate,
			co15.LoadDAte as LoadDate,
			co15.CopStgLoadStatus as LoadStatus,
			co15.tin as TIN,
			co15.NPI as NPI,
			co15.PafSubmission as PafSubmission,
			co15.OfficeVisits, 
			co15.LastOfficeVisit, 
			co15.ChronicDisease, 
			co15.HTNDiagnosisDate, 
			co15.ReportAsOf,
			co15.CreatedBy,
			co15.LastUpdatedBy,
		    co15.LastUpdatedDate,
			co15.CreatedDate,

           'OfficeVisits-Chronic2ndHalf' AS Measure,
		    LTRIM(RTRIM(LEFT(co15.[Office Visits-Chronic2ndHalf], 1))) AS Measurestatus,		  
            'UNK' as qmComp
    FROM [adi].[copAetMaCareopps] co15
    where isnull(co15.[Office Visits-Chronic2ndHalf], '') != ''   -- remove rows not part of Denom
	AND co15.CopStgLoadStatus = 0

	UNION

    SELECT DISTINCT
			co16.MemberID,
			co16.copAetMaCareoppsKey AS skey,
			co16.SrcFileName as Sourcefilename ,
			co16.DataDate as DataDate,
			co16.LoadDAte as LoadDate,
			co16.CopStgLoadStatus as LoadStatus,
			co16.tin as TIN,
			co16.NPI as NPI,
			co16.PafSubmission as PafSubmission,
			co16.OfficeVisits, 
			co16.LastOfficeVisit, 
			co16.ChronicDisease, 
			co16.HTNDiagnosisDate, 
			co16.ReportAsOf,
			co16.CreatedBy,
			co16.LastUpdatedBy,
		    co16.LastUpdatedDate,
			co16.CreatedDate,

           'AnnualFluVaccine' AS Measure,
           LTRIM(RTRIM(LEFT(co16.AnnualFluVaccine, 1))) AS Measurestatus,
		  CASE WHEN (co16.AnnualFluVaccine  like 'Y%')  then 'NUM'
          WHEN (co16.AnnualFluVaccine  like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co16
    where isnull(co16.AnnualFluVaccine, '') != ''   -- remove rows not part of Denom
    	AND co16.CopStgLoadStatus = 0


		 UNION


    SELECT DISTINCT
            co17.MemberID,
			co17.copAetMaCareoppsKey AS skey,
			co17.SrcFileName as Sourcefilename ,
			co17.DataDate as DataDate,
			co17.LoadDAte as LoadDate,
			co17.CopStgLoadStatus as LoadStatus,
			co17.tin as TIN,
			co17.NPI as NPI,
			co17.PafSubmission as PafSubmission,
			co17.OfficeVisits, 
			co17.LastOfficeVisit, 
			co17.ChronicDisease, 
			co17.HTNDiagnosisDate, 
			co17.ReportAsOf,
			co17.CreatedBy,
			co17.LastUpdatedBy,
		    co17.LastUpdatedDate,
			co17.CreatedDate,

           'ControllingHighBloodPressure' AS Measure,
           LTRIM(RTRIM(LEFT(co17.ControllingHighBloodPressure, 1))) AS Measurestatus,
		   CASE WHEN (co17.ControllingHighBloodPressure  like 'Y%')  then 'NUM'
           WHEN (co17.ControllingHighBloodPressure  like 'N%')  then 'COP'
         -- WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co17
    where isnull(co17.ControllingHighBloodPressure, '') != ''   -- remove rows not part of Denom
	AND co17.CopStgLoadStatus = 0

	UNION

    SELECT DISTINCT
            co18.MemberID,
			co18.copAetMaCareoppsKey AS skey,
			co18.SrcFileName as Sourcefilename ,
			co18.DataDate as DataDate,
			co18.LoadDAte as LoadDate,
			co18.CopStgLoadStatus as LoadStatus,
			co18.tin as TIN,
			co18.NPI as NPI,
			co18.PafSubmission as PafSubmission,
			co18.OfficeVisits, 
			co18.LastOfficeVisit, 
			co18.ChronicDisease, 
			co18.HTNDiagnosisDate, 
			co18.ReportAsOf,
			co18.CreatedBy,
			co18.LastUpdatedBy,
		    co18.LastUpdatedDate,
			co18.CreatedDate,

           'MedicationReconciliationPostDischarge' AS Measure,
           LTRIM(RTRIM(LEFT(co18.MedicationReconciliationPostDischarge, 1))) AS Measurestatus,
		   CASE WHEN (co18.MedicationReconciliationPostDischarge  like 'Y%')  then 'NUM'
           WHEN (co18.MedicationReconciliationPostDischarge  like 'N%')  then 'COP'
          --WHEN (TRY_convert(numeric(10,2), co6.DiabetesMedicationPDCYTD)BETWEEN 0.85 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co18
    where isnull(co18.MedicationReconciliationPostDischarge, '') != ''   -- remove rows not part of Denom
			AND co18.CopStgLoadStatus = 0
   
    UNION

	 /* Added a new measure. 
	 **It will return the diabetesHba1C level where row is not null and is greater than 8.5
	 */
    SELECT DISTINCT
            co19.MemberID,
			co19.copAetMaCareoppsKey AS skey,
			co19.SrcFileName as Sourcefilename ,
			co19.DataDate as DataDate,
			co19.LoadDAte as LoadDate,
			co19.CopStgLoadStatus as LoadStatus,
			co19.tin as TIN,
			co19.NPI as NPI,
			co19.PafSubmission as PafSubmission,
			co19.OfficeVisits, 
			co19.LastOfficeVisit, 
			co19.ChronicDisease, 
			co19.HTNDiagnosisDate, 
			co19.ReportAsOf,
			co19.CreatedBy,
			co19.LastUpdatedBy,
		    co19.LastUpdatedDate,
			co19.CreatedDate,

            'Diabetes Hba1C Level' AS Measure,		 
            LTRIM(RTRIM(LEFT(co19.[DiabetesHba1C Level], 1))) AS Measurestatus,  -- should look for decimal, go one to the right and trim		 
			--CASE WHEN ( co19.[DiabetesHba1C Level]  = 'Y')  then 'NUM'
			--WHEN ( co19.[DiabetesHba1C Level]  = 'N')  then 'COP OR A NUM Need to ref to BDR'
			--WHEN (TRY_convert(numeric(10,2), co19.[DiabetesHba1C Level])>= 8.5 ) then 'COP'
			--else 
			'UNK' as qmComp
    FROM [adi].[copAetMaCareopps] co19
    where isnull( co19.[DiabetesHba1C Level], '') != ''   -- remove rows not part of Denom	 
   	AND co19.CopStgLoadStatus = 0

	UNION

	SELECT DISTINCT
            co20.MemberID,
			co20.copAetMaCareoppsKey AS skey,
			co20.SrcFileName as Sourcefilename ,
			co20.DataDate as DataDate,
			co20.LoadDAte as LoadDate,
			co20.CopStgLoadStatus as LoadStatus,
			co20.tin as TIN,
			co20.NPI as NPI,
			co20.PafSubmission as PafSubmission,
			co20.OfficeVisits, 
			co20.LastOfficeVisit, 
			co20.ChronicDisease, 
			co20.HTNDiagnosisDate, 
			co20.ReportAsOf,
			co20.CreatedBy,
			co20.LastUpdatedBy,
		    co20.LastUpdatedDate,
			co20.CreatedDate,

            'StatinTherapyCardiovascularDisease' AS Measure,		 
            LTRIM(RTRIM(LEFT(co20.StatinTherapyCardiovascularDisease, 1))) AS Measurestatus,
			CASE WHEN (co20.StatinTherapyCardiovascularDisease  like 'Y%')  then 'NUM'
            WHEN (co20.StatinTherapyCardiovascularDisease  like 'N%')  then 'COP'
			else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co20
    where isnull( co20.StatinTherapyCardiovascularDisease, '') != ''   -- remove rows not part of Denom	 
   	AND co20.CopStgLoadStatus = 0

	   UNION

    SELECT DISTINCT
			co21.MemberID,
			co21.copAetMaCareoppsKey AS skey,
			co21.SrcFileName as Sourcefilename ,
			co21.DataDate as DataDate,
			co21.LoadDAte as LoadDate,
			co21.CopStgLoadStatus as LoadStatus,
			co21.tin as TIN,
			co21.NPI as NPI,
			co21.PafSubmission as PafSubmission,
			co21.OfficeVisits, 
			co21.LastOfficeVisit, 
			co21.ChronicDisease, 
			co21.HTNDiagnosisDate, 
			co21.ReportAsOf,
			co21.CreatedBy,
			co21.LastUpdatedBy,
		    co21.LastUpdatedDate,
			co21.CreatedDate,

           'Acei ArbPDCYTD' AS Measure,
           LTRIM(RTRIM(LEFT(co21.[Acei ArbPDCYTD], 1))) AS Measurestatus,
		   /*Required changes applied by Brit on 8/31/2021*/
		    CASE --WHEN (co9.StatinMedicationAdherence like 'Y%')  then 'NUM'
          -- WHEN (co9.StatinMedicationAdherence like 'N%')  then 'COP'
		  WHEN (TRY_convert(numeric(10,2), co21.[Acei ArbPDCYTD])>= 0.96) then 'NUM'
          WHEN (TRY_convert(numeric(10,2), co21.[Acei ArbPDCYTD])BETWEEN 0.60 AND 0.95) then 'COP'
          else 'UNK' end as qmComp
    FROM [adi].[copAetMaCareopps] co21
    where isnull(co21.[Acei ArbPDCYTD], '') != ''   -- remove rows not part of Denom
	AND co21.CopStgLoadStatus = 0

) AS adiData
    Inner join adi.MbrAetMaTx AdiMembers on LTRIM(RTRIM(adiMembers.Member_Source_Member_ID))=LTRIM(RTRIM(adiData.MemberID))			 
	LEFT JOIN (SELECT Source,Destination,IsActive
				FROM lst.listacemapping
				WHERE	ClientKey = 3 
				AND MappingTypeKey= 14
				AND	IsActive = 1) m
	ON REplace(adiData.Measure,' ', '') = replace(m.Source, ' ', '')
    LEFT JOIN (SELECT DISTINCT MeasureID,MeasureDesc
						, EffectiveDate,ExpirationDate,ACTIVE 
					FROM lst.lstCareOpToPlan lst
					WHERE ClientKey = 3
					AND   ACTIVE = 'Y'
					AND GETDATE() BETWEEN EffectiveDate AND ExpirationDate
				)	ListQm ON m.Destination = ListQm.MeasureID
--WHERE adiData.DataDate between(select min(datadate) from adi.copAetMaCareopps) and (SELECT MAX(DataDate) FROM [adi].[copAetMaCareopps]) ;
--WHERE adiData.DataDate =  (SELECT MAX(DataDate) FROM [adi].[copAetMaCareopps]) ;

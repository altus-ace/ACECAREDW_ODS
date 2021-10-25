


-- =============================================
-- Author:		Bing Yu
-- Create date: 09/08/2020
-- Description:	Insert 
-- ============================================
CREATE PROCEDURE [adi].[Import_Ahs_Altus_Prod_ProgramEnrollments]
              
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--EXEC [Ahs_Altus_Prod].[adi].[Get_ProgramEnrollments]
INSERT INTO AceCaredw.dbo.tmp_Ahs_ProgramEnrollments (
	   ClientMemberKey, LOB, ProgramName, StartDate, EndDate, PlanStartDate, PlanEndDate, ProgramStatusName , UpdatedOnDate, srcFileName, LoadDate
	   , CreatedDate, CreatedBy)
    SELECT CLIENT_PATIENT_ID, 
       LOB, 
       PROGRAM_NAME, 
       START_DATE, 
       end_date, 
       plan_start_date, 
       plan_end_date, 
       PROGRAM_STATUS_NAME, 
       Updated_on,
	  'Ahs_DailyRestore_ExportProgramEnrollments' srcFileName,
	  CONVERT(DATE,GETDATE()) LoadDate
	  , getdate() AS CreatedDate
	  , SYSTEM_USER AS CreatedBy
    FROM (SELECT DISTINCT 
           pd.CLIENT_PATIENT_ID, 
           lob.LOB_NAME AS LOB, 
           bpr.PROGRAM_NAME, 
           mbpr.START_DATE, 
           mbpr.end_date, 
           mbp.start_date AS plan_start_date, 
           mbp.end_date AS plan_end_date, 
           ps.PROGRAM_STATUS_NAME, 
           mbpr.updated_on, 
           ROW_NUMBER() OVER(PARTITION BY pd.CLIENT_PATIENT_ID, bpr.program_name, mbpr.start_Date ORDER BY mbp.end_date DESC) AS arn
	   FROM ahs_altus_prod.dbo.MEM_BENF_PLAN AS mbp
         INNER JOIN ahs_altus_prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID
         INNER JOIN ahs_altus_prod.dbo.BENEFIT_PLAN AS bpl ON lbp.BENEFIT_PLAN_ID = bpl.BENEFIT_PLAN_ID
         LEFT OUTER JOIN ahs_altus_prod.dbo.MEM_BENF_PROG AS mbpr ON mbp.MEMBER_ID = mbpr.MEMBER_ID
         LEFT OUTER JOIN ahs_altus_prod.dbo.BENF_PLAN_PROG AS bpp ON mbpr.BEN_PLAN_PROG_ID = bpp.BEN_PLAN_PROG_ID
         LEFT OUTER JOIN ahs_altus_prod.dbo.BENEFIT_PROGRAM AS bpr ON bpp.BENEFIT_PROGRAM_ID = bpr.BENEFIT_PROGRAM_ID
         INNER JOIN ahs_altus_prod.dbo.PATIENT_DETAILS AS pd ON mbp.MEMBER_ID = pd.PATIENT_ID 
         -- AND pd.DELETED_ON IS NULL 
         INNER JOIN ahs_altus_prod.dbo.PROGRAM_STATUS AS ps ON mbpr.PROGRAM_STATUS_ID = ps.PROGRAM_STATUS_ID 
         --AND ps.DELETED_ON IS NULL 
         --AND ps.IS_ACTIVE = 1 
         INNER JOIN ahs_altus_prod.dbo.LOB ON LOB.LOB_ID = lbp.LOB_ID
    WHERE(mbp.DELETED_ON IS NULL)
         AND mbpr.deleted_on IS NULL
         /*Deleted the duplicate programs so need to add this condition to eliminate wrong program( Enrollment) 28*/
         AND PS.PROGRAM_STATUS_NAME <> 'ERROR' 
         AND mbpr.START_DATE >= '01/01/2019'
    --AND mbpr.START_DATE >= DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0) --AS StartOfYear: makes the routine only pull values for the current calendar year. 
    GROUP BY pd.CLIENT_PATIENT_ID, 
             bpr.PROGRAM_NAME, 
             mbpr.START_DATE, 
             PS.PROGRAM_STATUS_NAME, 
             mbpr.end_date, 
             lob.lob_name, 
             mbpr.updated_on, 
             mbp.start_date, 
             mbp.end_date
    ) s
    WHERE s.arn = 1	
END






CREATE FUNCTION [dbo].[tvf_AH_MemberPrograms](@Program_year int)
                                           
RETURNS TABLE
AS
     RETURN
(


select Client_patient_id As Member_id,convert(int, Program_YEAR) as Program_Year,sum(cnt) as TotalPrograms ,sum([Newly Enrolled]) as 'TotalNewlyEnrolled'from (
SELECT DISTINCT
                 pd.PATIENT_ID
			  ,pd.CLIENT_PATIENT_ID
			  ,mbpr.mem_benf_prog_id as ID
			  , mbpr.START_DATE as PERFORMED 
			              
               , month( mbpr.START_DATE) AS Program_MONTH
			, year(mbpr.START_DATE) AS   Program_year
			,bpr.PROGRAM_NAME

			,1 as cnt
			,case when bpr.PROGRAM_NAME='Newly Enrolled' then 1 else 0 end as 'Newly Enrolled'
          FROM Ahs_Altus_Prod.dbo.MEM_BENF_PLAN AS mbp
               INNER JOIN Ahs_Altus_Prod.dbo.LOB_BENF_PLAN AS lbp ON mbp.LOB_BEN_ID = lbp.LOB_BEN_ID
               INNER JOIN Ahs_Altus_Prod.dbo.BENEFIT_PLAN AS bpl ON lbp.BENEFIT_PLAN_ID = bpl.BENEFIT_PLAN_ID
               LEFT OUTER JOIN Ahs_Altus_Prod.dbo.MEM_BENF_PROG AS mbpr ON mbp.MEMBER_ID = mbpr.MEMBER_ID
               LEFT OUTER JOIN Ahs_Altus_Prod.dbo.BENF_PLAN_PROG AS bpp ON mbpr.BEN_PLAN_PROG_ID = bpp.BEN_PLAN_PROG_ID
               LEFT OUTER JOIN Ahs_Altus_Prod.dbo.BENEFIT_PROGRAM AS bpr ON bpp.BENEFIT_PROGRAM_ID = bpr.BENEFIT_PROGRAM_ID
               INNER JOIN Ahs_Altus_Prod.dbo.PATIENT_DETAILS AS pd ON mbp.MEMBER_ID = pd.PATIENT_ID
                                                       AND pd.DELETED_ON IS NULL
			 INNER JOIN Ahs_Altus_Prod.dbo.PROGRAM_STATUS AS ps ON mbpr.PROGRAM_STATUS_ID = ps.PROGRAM_STATUS_ID
                                                      AND ps.DELETED_ON IS NULL
                                                      AND ps.IS_ACTIVE = 1
			
          WHERE(mbp.DELETED_ON IS NULL
		and mbpr.deleted_on is null
		   /*Deleted the duplicate programs so need to add this condition to eliminate wrong program( Enrollment) 28*/ 
               AND PS.PROGRAM_STATUS_NAME <> 'ERROR'
			and pd.CLIENT_PATIENT_ID not in ('ALT26860','ALT40110','ALT40111')
			--and pd.client_patient_id in ('100443983')
               )
			) as s
			where program_year=@Program_year
			Group by Client_patient_id,Program_YEAR
			);
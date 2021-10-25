CREATE PROCEDURE [dbo].[LoadAhsExportProgramEnrollment_CleanOldData]
AS
    /* remove older program enrollment records */
    /* clean old program enrollments Keep 7 days*/
    DECLARE @d DATE ;
    DECLARE @min DATE;
    DECLARE @KeepDays INT = 5;
    --SELECT count(*) FROM dbo.tmp_Ahs_ProgramEnrollments pe
    SELECT @d = Max(pe.LoadDate) FROM dbo.tmp_Ahs_ProgramEnrollments pe
    SELECT @min = dateadd(day, -1*@KeepDays, @d);
    --SELECT @d, @min
    --SELECT MIN(pe.LoadDate) FROM dbo.tmp_Ahs_ProgramEnrollments pe
    --SELECT COUNT(*)
    DELETE pe
    FROM dbo.tmp_Ahs_ProgramEnrollments pe
    where pe.LoadDate < @Min;

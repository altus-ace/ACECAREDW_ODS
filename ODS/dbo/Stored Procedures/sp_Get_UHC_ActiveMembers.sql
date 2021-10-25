
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_UHC_ActiveMembers] @StartDate date, @StopDate date
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM vw_UHC_ActiveMembers 
	WHERE MEMBER_ORG_EFF_DATE >= ISNULL(@StartDate, MEMBER_ORG_EFF_DATE) AND MEMBER_ORG_EFF_DATE >= ISNULL(@StopDate, MEMBER_ORG_EFF_DATE)
END


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE sp_GetMemberDemo @memberid varchar(25) = null  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM vw_UHC_ActiveMembers 
	WHERE MEMBER_ID = ISNULL(@memberid, MEMBER_ID)
END

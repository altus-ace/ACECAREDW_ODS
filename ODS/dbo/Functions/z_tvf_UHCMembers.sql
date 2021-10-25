
CREATE FUNCTION [dbo].[z_tvf_UHCMembers](@BaselineDate DATE, @TargetDate DATE)
RETURNS TABLE
    /* Purpose: gets all members active for all clients for a specific day.
	   Incudes the keys of the Rows used to create the set. 
	   */
AS
    RETURN
(   

SELECT m.UHC_SUBSCRIBER_ID as MemberID
	FROM dbo.Uhc_MembersByPcp m    
	WHERE m.A_LAST_UPDATE_DATE = @BaselineDate
INTERSECT 
SELECT m.UHC_SUBSCRIBER_ID as MemberID
	FROM dbo.Uhc_MembersByPcp m    
	WHERE m.A_LAST_UPDATE_DATE = @TargetDate

)

/***
Usage:
SELECT * FROM [dbo].[z_tvf_UHCMembers] ('12/10/2018','12/16/2019')

SELECT m.UHC_SUBSCRIBER_ID
	FROM dbo.Uhc_MembersByPcp m 
	WHERE UHC_SUBSCRIBER_ID = '100414008'
	AND		m.A_LAST_UPDATE_DATE IN ('12/10/2018','12/16/2019')
		
***/
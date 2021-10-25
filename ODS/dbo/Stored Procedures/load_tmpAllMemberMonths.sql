
/*****************************************************************

Modification: Brit
Date :2021/01/18
Purpose: Parameterize

CREATED BY : TS
CREATE DATE : 1/14/2020
DESCRIPTION : 

The procedure should be run monthly (EOM) to all load all
members into a temporary tmpAllMemberMonths. This table is used 
by the Master Member Report (Tableau)

MODIFICATION:
USER        DATE        COMMENT
TS      1/1/2020          updates - added new columns 

--Brit: 
 
******************************************************************/

CREATE PROCEDURE [dbo].[load_tmpAllMemberMonths] (@ClientKey INT, @DataDate DATE) -- [dbo].[load_tmpAllMemberMonths]20,'2020-01-01'
AS
    --TRUNCATE TABLE dbo.tmpAllMemberMonths;

	-- DECLARE @clientKey INT = 9 DECLARE @DataDate DATE = '2021-01-25'
	 EXECUTE [dbo].[GetMemberMonths]@ClientKey,@DataDate


	 ---1ST Step
     INSERT INTO dbo.tmpAllMemberMonths
     EXEC dbo.getMemberMonths 
          9,'2021-01-18';

     INSERT INTO dbo.tmpAllMemberMonths
     EXEC dbo.getMemberMonths 
          3,@DataDate;

     INSERT INTO dbo.tmpAllMemberMonths
     EXEC dbo.getMemberMonths 
          2,@DataDate;

	 INSERT INTO dbo.tmpAllMemberMonths
     EXEC dbo.getMemberMonths 
          11,@DataDate;

	 INSERT INTO dbo.tmpAllMemberMonths
     EXEC dbo.getMemberMonths 
          12,@DataDate;

	 INSERT INTO dbo.tmpAllMemberMonths
     EXEC dbo.getMemberMonths 
          16,@DataDate;
		  	
	 INSERT INTO dbo.tmpAllMemberMonths
     EXEC dbo.getMemberMonths 
          20,@DataDate;

	 INSERT INTO dbo.tmpAllMemberMonths
	 EXEC dbo.GetMemberMonthsForUHC
		  1,@DataDate;



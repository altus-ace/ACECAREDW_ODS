CREATE PROCEDURE adw.MbrPdwUhcProgramsHighRisk
AS 
INSERT INTO CC.dbo.P14 (MEMBER_ID, /* subGrp,*/ PROG_ID, /*ProgramName,*/
		  CREATE_DATE, CREATE_BY, ASSIGN_DATE, /* Date_Appeared*/
		  MEMBER_FIRST_NAME, MEMBER_LAST_NAME, DATE_OF_BIRTH,
		  PLAN_DESC, DUE0, DUE2)
SELECT 
	   m.UHC_SUBSCRIBER_ID				   AS Member_id
    --, m.SUBGRP_ID						   AS SubGrp_ID
    , 'TOC4'							   AS PROG_ID
    --, 'High Risk Cohort'					   AS ProgramName
    , GETDATE()						   AS Create_Date
    , SYSTEM_USER						   AS CreatedBy	
    , GETDATE()						   AS Assign_date
    --, CONVERT(date, m.A_LAST_UPDATE_DATE,101)   AS date_appeared
    , m.MEMBER_FIRST_NAME				   AS Member_first_name
    , m.MEMBER_LAST_NAME					   AS Member_Last_Name  
    , m.DATE_OF_BIRTH					   AS Date_Of_Birth
    , mph.Benefit_Plan  					   AS Benefit_Plan    
    , '10/1/2018'						   AS Due0	
    , '12/31/2018'						   AS DUE2	
FROM dbo.UHC_MembersByPCP m
    JOIN (SELECT SOURCE_VALUE
		  FROM dbo.ALT_MAPPING_TABLES m
		  WHERE URN between 61 and 71) HighRiskSubGrps ON m.SUBGRP_ID = HighRiskSubGrps.SOURCE_VALUE
    JOIN adw.A_ALT_MemberPlanHistory mph ON m.UHC_SUBSCRIBER_ID = mph.Client_Member_ID
	   and getdate() between mph.startDate and mph.stopDate
    ;

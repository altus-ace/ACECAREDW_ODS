CREATE procedure dbo.DevStagingValidtions
    (@CLIENTKEY INT )
AS

/*CIGNA MA ME VALIDATION QUERIES*/   

DECLARE @LoadDate date;
DECLARE @ASOFDATE DATE;
DECLARE @ACTIVE TINYINT= 1;

SELECT @LoadDate=  Max(loadDate)--, max(datadate) 
FROM ast.MbrStg2_MbrData ST 
where st. ClientKey = @clientKey;
SET @AsOfDate = @LoadDate;

DECLARE @TotalMemberCount INT 
SELECT        @TotalMemberCount = COUNT(distinct st.ClientSubscriberId) 
FROM        ast.MbrStg2_MbrData st
WHERE        ClientKey = @ClientKey
    AND            LoadDate = @LoadDate

--INSERT INTO validationRnSummary output skey into stored run value
SELECT @TotalMemberCount, @CLientKey, @LoadDate, @AsOfDate,@Active

-- create two tables to store results:
-- Put summary details: params, counts, dates in
--dbo ValidationRunSummary (skey, date, user, @TotalMemberCount, @CLientKey, @LoadDate, @AsOfDate,@Active
-- put details into 
--dbo validationDetails_FailLog (skey, date, user, stgRowSkey, TestedColumnValue, TestCase)

	------CIGNA MA STAGING VALIDATIONS-----
	/*****IN CIGNA MA IF A MEMBER IS HAS PRVTIN AND NO PRVNPI THEN THE MEMBER IS NOT VALID FOR FURTHER PROCESSING*****/
	/*****TAKE NOTE OF THE MEMBERCOUNT TO MATCH WITH THE ACTIVE MEMBER COUNT****/
	/* NPI */
--    insert into(faillog
    SELECT        stgRowStatus, st.MbrStg2_MbrDataUrn
	   ,prvNPI TestedColumnValue, 'PrvNpiNotNull' TestCase
    FROM        ast.MbrStg2_MbrData st
    WHERE        ClientKey = @ClientKey
	   AND            LoadDate = @LoadDate
	   AND ISNULL(st.prvNPI, '') = ''
        
    /* Tin */
	/*****IN CIGNA MA IF A MEMBER IS HAS PRVTIN AND NO PRVNPI THEN THE MEMBER IS NOT VALID FOR FURTHER PROCESSING*****/
	/*****TAKE NOTE OF THE MEMBERCOUNT TO MATCH WITH THE ACTIVE MEMBER COUNT****/
	
    SELECT        stgRowStatus, st.MbrStg2_MbrDataUrn
        ,prvTin TestedColumnValue, 'PrvTinNotNull' TestCase
    FROM        ast.MbrStg2_MbrData st
    WHERE        ClientKey = @ClientKey
	   AND            LoadDate = @LoadDate
	   AND ISNULL(st.prvTin, '') = ''


 /***** Run the below query to see the distinct MstrMrnkey's need to compare with the above query result******
 ACTION ITEM: IF FOUND MAJOR DESCREPANCY IN THE MEMBER COUNT LET BUSSS ANLYST KNOW ABOUT THE ISSUE ***/

   SELECT        DISTINCT MstrMrnKey
    FROM        ACECAREDW.ast.MbrStg2_MbrData
    WHERE        ClientKey = 12
    AND           LoadDate = '2021-06-20'
	Order by	MstrMrnKey
	asc

/**** CHECK THE BELOW QUERY TO SEE THE MEMBER COUNT IS MATCHING WITH THE ABOVE TABLE AND THE STGROWSTATUS VALID FOR ALL THE MEMBERS. IF NOT VALID THOSE MEMBERS SHOULD BE EXCLUDED IN THE ADW VALIDATION QUERY RESULTS****/
    SELECT        *
    FROM        ast.MbrStg2_PhoneAddEmail 
    WHERE        ClientKey = 12
    AND            LoadDate = '2021-06-20'


	--------******STAGING VALIDATION FOR CIGNA MA******---------
	/**** IF MSTRMRNKEKEY IS -1 FOR ANY MEMBER THEN LOOK FOR PRVNPI AND PRVTIN WHICH WILL ALSO BE -1.
	THIS MEANS THOUGH WE RECEIVE THE MEMBER DETAILS THESE MEMBERS DONT HAVE A VALID PROVIDER ASSIGNIED****/


    SELECT        prvNPI,prvTIN,MstrMrnKey,*
    FROM        ACECAREDW.ast.MbrStg2_MbrData a
    WHERE        ClientKey = 12
    AND            LoadDate = '2021-06-20'

/***THIS QUERY BELOW GIVES THE MEMBERS WITH MSTRMRNKEY -1 AND NO PROVIDER DETAILS THESE MEMBERS WILL EXCLUDED IN THE ADW VALIDATIONS 
ACTION ITEM: IF -1 RECORDS FOUND LET BUSS ANLYST *****/

	SELECT		    * --Distinct MstrMrnKey
	  FROM        ACECAREDW.ast.MbrStg2_MbrData a
    WHERE        ClientKey = 12
    AND            LoadDate = '2021-06-20'
	AND				MstrMrnKey = '-1'


	 SELECT      * -- DISTINCT CLIENTMEMBERKEY
    FROM        ast.MbrStg2_PhoneAddEmail 
    WHERE        ClientKey = 12
    AND            LoadDate = '2021-06-20'


---QUERY TO CHECK IF THE NPI MATCH FROM STAGING TO PROVIDER ROSTER---
--GIVE THE ST.LOADDATE = THE CURRENT MONTH END PROCESSING DATE--
--IF ANY NULL'S FOUND 
--ACTION ITEM: LET BUSS ANLYST KNOW. BUSS ANLYST TO GET WITH BA(BRITIANA)

--DECLARE @CLIENTKEY INT = 12;
--DECLARE @ASOFDATE DATE = '2021-06-21';
--DECLARE @ACTIVE TINYINT = 1
SELECT DISTINCT
ST.prvNPI
,PR.NPI
FROM ast.MbrStg2_MbrData ST
JOIN ADW.tvf_AllClient_ProviderRoster (@CLIENTKEY, @ASOFDATE, @ACTIVE) PR
ON			PR.NPI = ST.prvNPI
WHERE		ST.LoadDate = '2021-06-20'


--PLAN MAPPING QUERY FOR CIGNA MA
--THE BELOW QUERY JOINS WITH LIST PLAN MAPPING AND THE STAGING DATA FOR THE CURRENT MONTHEND TO CHECK IF THE CONTRACTED PLANS ARE MATCHING
-- ACTION ITEM: IF ANY PLANS ARE MISSING OR GIVING NULL FROM THE BELOW QUERY LET BUSS ANLYST KNOW (BUSS ANLYST WILL NEED TO DIG THROUGH THE LISTTABLES AND BRD'S FOR THE CLIENT

SELECT DISTINCT
ST.plnProductSubPlanName
,PM.TargetValue
FROM ast.MbrStg2_MbrData ST
JOIN ACECAREDW.[lst].[lstPlanMapping] PM
ON			PM.TargetValue = ST.plnProductSubPlanName
WHERE		ST.LoadDate = '2021-06-20'
AND			ST.ClientKey = '12'







/****THE BELOW QUERY GIVES THE LISTPLAN MAPPING DETAILS
THE BELOW PLANS SHOULD MATCH WITH THE PLANS IN STAGING AND IN ACTIVE MEMBERS****/

SELECT       *--dISTINCT TARGE
FROM    ACECAREDW.[lst].[lstPlanMapping]
WHERE   ClientKey = '12' 
Order by CreatedDate desc
--AND ACTIVE = 'Y'





--ONCE THE STAGING VALIDATION IS COMPLETED LET BA (BRITIANA) KNOW ABOUT TO PROCESS MEMBERSHIP INTO ADW--

------CIGNA MA ADW VALIDATIONS-------


	--CIGNA MA MbrMember Validation--
	--LOOK FOR THE RECENT DATADATE AND RUN THE BELOW QUERY  
SELECT *
FROM [adw].[MbrMember]
WHERE ClientKey = '12' 
AND DataDate = '2021-06-17' 


--THE BELOW COUNTS SHOULD MATCH WITH THE DISTINCT COUNTS OF STAGING VALIDATIONS--
--RUN THE DISTINCT ON MEMBER_ID OR CLIENT_SUBSCRIBER_ID TO FIND THE ACTUAL COUNT OF MEMBERS ID'S--

--CIGNA MA ActiveMembers--
SELECT       Distinct CLIENT_SUBSCRIBER_ID --1347
FROM ACECAREDW.dbo.vw_ActiveMembers
WHERE Clientkey = '12'   --'9'


SELECT       *--Distinct CLIENT_SUBSCRIBER_ID
FROM ACECAREDW.dbo.vw_ActiveMembers
WHERE Clientkey = '12'






---CIGNA MA TmpALLMEMber Months--

--THE BELOW QUERIES ARE FOR THE TMP ALL MEMBERMONTHS TABLE--
--RUN THE MAX MEMBERMONTH OR THE ORDER BY MEMBERMONTH DESC--
--THE RESULT COUNTS SHOULD MATCH THE ACTIVE MEMBERS COUNT --
--CHANGE THE MEMBERMONTH AS REQUIRED WHILE RUNNING FOR THE CURRENT MONTHS--
--ACTION ITEMS: IF ANY DUPLICATES FOUND IN THE TMP ALL MEMBER MONTHS OR IF THE CURRENT MEMBER MONTH DATA COUNT IS  NOT MATCHIy from QM results by meberhistoryNG WITH THE ACTIVE MEMBERS COUNT THEN LET THE BUSS ANLYST KNOW

SELECT     *--DISTINCT ClientMemberKey
FROM ACECAREDW.[dbo].[TmpAllMemberMonths]
WHERE CLIENTKey = '12'
AND MemberMonth = '2021-06-20'

SELECT       *--DISTINCT ClientMemberKey, RunDate
FROM ACECAREDW.[dbo].[TmpAllMemberMonths]
WHERE CLIENTKey = '12'
AND MemberMonth = '2021-06-20'


--EXPORT VALIDATIONS--NEED TO BE BUILD...TILL NOW EXPORT FILE VALIDATIONS ARE BEING DONE MANUALLY


/* CREATE an result set queries to give the results back to the user */
--select * from validationrunsummary where key = stored run value
--select testCase,  count(disticnt row), date
--from fail log
--group by test case 
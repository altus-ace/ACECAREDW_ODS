

CREATE VIEW [dbo].[vw_AH_UHC_MI_Membership]
AS
        SELECT
            uam.SUBSCRIBER_ID as MEMBER_ID
          , 'UHC' AS CLIENT_ID
          , uam.MEDICAID_NUMBER as MEDICAID_ID
          , REPLACE(RTRIM(uam.MEMBER_FIRST_NAME), ',', ' ') AS MEMBER_FIRST_NAME
          , REPLACE(RTRIM(uam.MEMBER_MIDDLE_INITIAL), ',', ' ') AS MEMBER_MI
          , REPLACE(RTRIM(uam.MEMBER_LAST_NAME), ',', ' ') AS MEMBER_LAST_NAME
          , uam.DATE_OF_BIRTH
          , UAM.GENDER AS MEMBER_GENDER
          , REPLACE(RTRIM(uam.ADDRESS_LINE_1), ',', ' ')+' '+REPLACE(RTRIM(uam.ADDRESS_LINE_2), ',', ' ') AS HOME_ADDRESS
          , uam.CITY AS HOME_CITY
          , uam.[STATE] AS HOME_STATE
          , uam.ZIP_CODE AS HOME_ZIPCODE
		/*GETTING PREFERRED ADDRESS TO MAILING ADDRESS*/
          , CASE WHEN PREADD.MEMBER_ADDRESS IS NULL 
		THEN REPLACE(RTRIM(uam.ADDRESS_LINE_1), ',', ' ')+' '+REPLACE(RTRIM(uam.ADDRESS_LINE_2), ',', ' ') ELSE REPLACE(RTRIM(PREADD.MEMBER_ADDRESS), ',', ' ') END AS MAILING_ADDRESS
          , CASE WHEN PREADD.MEMBER_CITY IS NULL THEN uam.CITY ELSE PREADD.MEMBER_CITY END AS MAILING_CITY
          , CASE WHEN PREADD.MEMBER_STATE IS NULL THEN uam.[STATE] ELSE PREADD.MEMBER_STATE END  AS MAILING_STATE
          , CASE WHEN PREADD.MEMEBR_ZIP IS NULL THEN uam.ZIP_CODE ELSE PREADD.MEMEBR_ZIP END   AS MAILING_ZIP
          , UAM.HOME_PHONE_NUMBER AS HOME_PHONE
          , '' AS ADDITIONAL_PHONE
          , '' AS CELL_PHONE
          , ISNULL(NULL, 'TEST LANGUAGE') AS LANGUAGE
          , ltrim(rtrim(uam.ETHNICITY_DESC)) AS Ethnicity
          , uam.MEDICARE_NUMBER as MEDICARE_ID
          , '' as MEMBER_ORG_EFF_DATE
          , '' as MEMBER_CONT_EFF_DATE
          , uam.EFFECTIVE_DATE as MEMBER_CUR_EFF_DATE
          , uam.TERMINATION_DATE as MEMBER_CUR_TERM_DATE
          , REPLACE(RTRIM(UAM.RESP_PERSON_FIRST_NAME), ',', ' ') AS RESP_FIRST_NAME
          , REPLACE(RTRIM(UAM.RESP_PERSON_LAST_NAME), ',', ' ') AS RESP_LAST_NAME
		, 'Responsible Party' AS RESP_RELATIONSHIP					   -- PlaceHolder for future data
          , REPLACE(RTRIM(UAM.RESP_PERSON_ADDRESS_1), ',', ' ') AS RESP_ADDRESS
          , REPLACE(RTRIM(UAM.RESP_PERSON_ADDRESS_2), ',', ' ') AS RESP_ADDRESS2
          , UAM.RESP_PERSON_CITY as RESP_CITY
          , UAM.RESP_PERSON_STATE as RESP_STATE
          , UAM.RESP_PERSON_ZIP_CODE as RESP_ZIP
          , UAM.RESP_PERSON_PHONE_NUMBER as RESP_PHONE
          ,'' AS [PRIMARY_RISK_FACTOR],
            '' AS [COUNT_OPEN_CARE_OPPS],
            '' AS [INP_ADMITS_LAST_12_MOS],
            '' AS [LAST_INP_DISCHARGE],
            '' AS [POST_DISCHARGE_FUP_VISIT],
            '' AS [INP_FUP_WITHIN_7_DAYS],
            '' AS [ER_VISITS_LAST_12_MOS],
            '' AS [LAST_ER_VISIT],
            '' AS [POST_ER_FUP_VISIT],
            '' AS [ER_FUP_WITHIN_7_DAYS],
            '' AS [LAST_PCP_VISIT],
            '' AS [LAST_PCP_PRACTICE_SEEN],
            '' AS [LAST_BH_VISIT],
            '' AS [LAST_BH_PRACTICE_SEEN],
            '' AS [TOTAL_COSTS_LAST_12_MOS],
            '' AS [INP_COSTS_LAST_12_MOS],
            '' AS [ER_COSTS_LAST_12_MOS],
            '' AS [OUTP_COSTS_LAST_12_MOS],
            '' AS [PHARMACY_COSTS_LAST_12_MOS],
            '' AS [PRIMARY_CARE_COSTS_LAST_12_MOS],
            '' AS [BEHAVIORAL_COSTS_LAST_12_MOS],
            '' AS [OTHER_OFFICE_COSTS_LAST_12_MOS],
            '' AS [NEXT_PREVENTATIVE_VISIT_DUE]
		  ,'' AS EMAIL
		  ,'' AS RACE
     FROM adi.MbrUhcMicroIncentives AS UAM
	 inner join (
	SELECT i.SUBSCRIBER_ID
FROM adi.MbrUhcMicroIncentives I
   JOIN (SELECT loadDates.loadDate
                FROM (SELECT src.loadDate , ROW_NUMBER() OVER (PARTITION BY src.LoadDate ORDER BY src.LoadDATE DESC) as aRn
                           FROM (  SELECT I.loadDate     
                                      FROM adi.MbrUhcMicroIncentives I
                                     GROUP BY I.loadDate) src
                               ) AS loadDates
                     WHERE loadDates.aRn = 1) as ld ON I.loadDate = ld.loadDate
    JOIN (( SELECT i.Subscriber_ID AS UHC_SUBSCRIBER_ID FROM adi.MbrUhcMicroIncentives i) 
                      EXCEPT
                (SELECT am.UHC_SUBSCRIBER_ID FROM ACECAREDW.dbo.UHC_MembersByPCP am WHERE A_LAST_UPDATE_FLAG = 'Y')) AS AM 
			 ON I.SUBSCRIBER_ID = am.UHC_SUBSCRIBER_ID)
			  s on s.SUBSCRIBER_ID=uam.SUBSCRIBER_ID

	LEFT JOIN (SELECT  
            PD.CLIENT_PATIENT_ID AS MEMBER_ID
          , PDD.ADDRESS_TEXT AS MEMBER_ADDRESS
          , PDD.CITY AS MEMBER_CITY
          , PDD.STATE AS MEMBER_STATE
          , PDD.ZIP AS MEMEBR_ZIP  
		,PDD.CREATED_ON       
		,PDD.UPDATED_ON    
     FROM ahs_altus_prod.dbo.PATIENT_DETAILS AS PD
          INNER JOIN ahs_altus_prod.dbo.[PATIENT_PREFERRED_ADDRESS] AS PDD 
		ON PDD.PATIENT_ID = PD.PATIENT_ID and pdd.Deleted_on is null) AS PREADD ON PREADD.MEMBER_ID=UAM.SUBSCRIBER_ID




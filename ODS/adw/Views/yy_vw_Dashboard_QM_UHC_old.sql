

CREATE VIEW [adw].[yy_vw_Dashboard_QM_UHC_old]
AS
    /* OBJECTIVE: GET QUALITY MEASURE FOR A MEMBER BY MONTH FOR A CLIENT */
    SELECT S.ClientMemberKey, S.CareOpToPlan_Active, S.QmMsr_Tb_Desc, S.AHR_QM_DESC, S.QmMsrId, S.QMDate, 
       S.LOB, S.MeasureDesc, 
                  SUM(S.MbrDEN) AS MbrDEN, SUM(S.MbrNUM) AS MbrNUM, SUM(S.MbrCOP) AS MbrCOP, 
       S.AGE, S.PCP_PRACTICE_TIN, S.PCP_PRACTICE_NAME,s.ProviderAccountType, S.PCP_NPI, S.PCP_PHONE, S.careOpToPlan_MeasureID, S.[Contract?], 
       S.[ACE MBR?], S.ExpirationYear, S.Target, S.Client, S.ProviderName     
                  , S.IsMbrActive, S.TinInContractWithAce               
    FROM
    (
        SELECT [CLIENTMEMBERKEY], 
               A.ACTIVE CAREOPTOPLAN_ACTIVE,
               CASE -- CLEANED UP TO MATCH THE UHC 2020 MEASURES 
                   WHEN [QMMSRID] = 'UHC_AWC'
                   THEN 'AWC :  ADOLESCENT WELL-CARE VISITS .'
                   WHEN [QMMSRID] = 'UHC_BCS'
                   THEN 'BCS :  BREAST CANCER SCREENING.'
                   WHEN [QMMSRID] = 'UHC_CBP'
                   THEN 'CBP:CONTROLLING HIGH BLOOD PRESSURE'
                   WHEN [QMMSRID] = 'UHC_CCS'
                   THEN 'CCS:CERVICAL CANCER SCREENING'
                   WHEN [QMMSRID] = 'UHC_CDC'
                   THEN 'CDC:COMPREHENSIVE DIABETES CARE: HBA1C CONTROL ( < 8% )'
                   WHEN [QMMSRID] = 'UHC_CIS'
                   THEN 'CHILDHOOD IMMUNIZATION STATUS'
                   WHEN [QMMSRID] = 'UHC_FUH_30'
                   THEN 'FUH:FOLLOW UP AFTER HOSPITALIZATION FOR MENTAL ILLNESS:  30-DAY FOLLOW UP'
                   WHEN [QMMSRID] = 'UHC_FUH_7'
                   THEN 'FUH:FOLLOW UP AFTER HOSPITALIZATION FOR MENTAL ILLNESS:  7-DAY FOLLOW UP'
                   WHEN [QMMSRID] = 'UHC_IMA'
                   THEN 'IMA:IMMUNIZATIONS FOR ADOLESCENTS (COMBINATION 2)'
                   WHEN [QMMSRID] = 'UHC_PCR'
                   THEN 'PCR:READMISSIONS - LESS IS BETTER'
                   WHEN [QMMSRID] = 'UHC_SSD'
                   THEN 'SSD :  DIABETES SCREENING FOR PEOPLE WITH SCHIZOPHRENIA OR BIPOLAR DISORDER WHO ARE USING ANTIPSYCHOTIC MEDICATIONS'
                   WHEN [QMMSRID] = 'UHC_URI'
                   THEN 'URI: APPROPRIATE TREATMENT FOR CHILDREN WITH UPPER RESPIRATORY INFECTION'
                   WHEN [QMMSRID] = 'UHC_W15'
                   THEN 'W15:WELL CHILD VISITS IN THE FIRST 15 MONTHS OF LIFE: 6 OR MORE'
                   WHEN [QMMSRID] = 'UHC_W34'
                   THEN 'W34:WELL CHILD  VISITS IN THE THIRD, FOURTH, FIFTH, AND SIXTH YEAR OF LIFE'
                   WHEN [QMMSRID] = 'UHC_WCC'
                   THEN 'WCC: WEIGHT ASSESSMENT AND COUNSELING FOR NUTRITION AND PHYSICAL ACTIVITY FOR CHILDREN/ADOLESCENTS: COUNSELING FOR NUTRITION'
                   ELSE 'O'
               END AS [QMMSR_TB_DESC], 
               A.[AHR_QM_DESC], 
               [QMMSRID], 
               [QMDATE], 
               A.LOB, 
               QM_DESC AS MEASUREDESC,
               CASE
                   WHEN [QMCNTCAT] = 'DEN'
                   THEN 1
                   ELSE 0
               END AS MBRDEN,
               CASE
                   WHEN [QMCNTCAT] = 'NUM'
                   THEN 1
                   ELSE 0
               END AS MBRNUM,
               CASE
                   WHEN [QMCNTCAT] = 'COP'
                   THEN 1
                   ELSE 0
               END AS MBRCOP, 
               [AGE], 
               [PCP_PRACTICE_TIN], 
               [PCP_PRACTICE_NAME], 
                                                ProviderAccountType, 
               [PCP_NPI], 
               [PCP_PHONE], 
               A.CAREOPTOPLAN_MEASUREID,
               CASE
                   WHEN A.CAREOPTOPLAN_MEASUREID IS NULL
                   THEN 'NOT CONTRACTED'
                   ELSE 'CONTRACTED'
               END AS 'CONTRACT?',
               CASE
                   WHEN UHC_SUBSCRIBER_ID IS NULL
                   THEN 'NOT ACE_MBR'
                   ELSE 'ACE MBR'
               END AS 'ACE MBR?', 
               YEAR(SCOR.EXPIRATIONDATE) AS EXPIRATIONYEAR, 
               SCOR.SCORE_A / 100 AS TARGET, 
               A.CLIENTSHORTNAME AS CLIENT, 
               A.PROVIDERNAME
                                                , A.IsMbrActive, A.TinInContractWithAce
        FROM
        ( SELECT DISTINCT 
                   QM.[CLIENTMEMBERKEY], 
                   QM.[CLIENTKEY], 
                   QM.[QMMSRID] AS SOURCEQMMSRID, 
                   CP.ACTIVE,
                   CASE
                       WHEN(QM.[QMMSRID] LIKE 'UHC_FUH_30%')
                       THEN 'UHC_FUH_30'
                       WHEN(QM.[QMMSRID] LIKE 'UHC_FUH_7%')
                       THEN 'UHC_FUH_7'
                       ELSE QM.QMMSRID
                   END AS QMMSRID, 
                   QM.[QMCNTCAT], 
                   LQM.AHR_QM_DESC, 
                   QM.[QMDATE], 
                   ACEMAP_CSPLAN.TARGETVALUE AS AHS_LOB, 
                   MP.SUBGRP_ID, 
                   ACEMAP_CSPLAN.SOURCEVALUE,
                   CASE
                       WHEN ACEMAP_CSPLAN.TARGETVALUE IN('MMP', 'MMP NF', 'MMP  NF', 'MMP WAIVER')
                       THEN 'MMP'
                       WHEN ACEMAP_CSPLAN.TARGETVALUE IN('STARKIDS', 'STARKIDS IDD')
                       THEN 'STARKIDS'
                       WHEN ACEMAP_CSPLAN.TARGETVALUE IN('STARPLUS IDD', 'STARPLUS NHC', 'STARPLUS NHR', 'TX-STAR+PLUS', 'TX STAR+PLUS 111', 'TX STAR+PLUS 120', 'TX STAR+PLUS 123', 'TX STAR+PLUS 901')
                       THEN 'STARPLUS'
                       WHEN ACEMAP_CSPLAN.TARGETVALUE IN('TX-CHIP', 'TX-CHIP PREGNANT WOMEN')
                       THEN 'TX-CHIP'
                       WHEN ACEMAP_CSPLAN.TARGETVALUE IN('TX-STAR', 'TX-STAR PREGNANT WOMEN')
                       THEN 'TX-STAR'
                   END AS LOB, 
                   LQM.QM, 
                   LQM.QM_DESC, 
                   MP.[AGE], 
                   MP.[PCP_PRACTICE_TIN], 
                --   MP.[PCP_PRACTICE_NAME], 
                                                 -- USE  PROVIDERROSTER TO CLEAN UHC TIN NAME, FOR THE SHCN PERMIAN TIN, USE NPI TO GET GROUP NAME , ALL OTHERS JUSTNPI
                                                    CASE WHEN (MP.PCP_PRACTICE_TIN = '134334288') THEN PR_SHCN.GROUPNAME 
                                                                    ELSE PR.GROUPNAME END AS PCP_PRACTICE_NAME,                                                
                                                    CASE WHEN   (PR.ACCOUNTTYPE LIKE 'SHCN_%') THEN PR.ACCOUNTTYPE 
                                                                    WHEN (PR.AccountType is null) THEN NULL
                                                                    ELSE 'ACE' END AS ProviderAccountType,                                                          
                   MP.[PCP_NPI], 
                   MP.[PCP_PHONE], 
                   MP.UHC_SUBSCRIBER_ID, 
                   CP.MEASUREID CAREOPTOPLAN_MEASUREID, 
                   MP.LOADTYPE,                    
                   LC.CLIENTSHORTNAME, 
                   MP.PCP_LAST_NAME + ', ' + MP.PCP_FIRST_NAME AS PROVIDERNAME,
                                                    CASE WHEN (AM.CLIENT_SUBSCRIBER_ID IS NULL) THEN 'INACTIVE' ELSE 'ACTIVE' END AS ISMBRACTIVE,
                                                    CASE WHEN ( pr.AccountType IS NULL) THEN 'INACTIVE' ELSE 'ACTIVE' END AS TinInContractWithAce
            FROM [ADW].[QM_RESULTBYMEMBER_HISTORY] QM 
                 LEFT JOIN DBO.VW_ACTIVEMEMBERS AM 
                                                                ON AM.MEMBER_ID = QM.CLIENTMEMBERKEY -- NEED TO ADD THIS TO REMOVE MEMBERS WHO ARE WRONGLY PULLED INTO PCOR WITH PLANS IN MMP NAMED AS STARPLUS
                                                                    AND AM.CLIENTKEY = QM.CLIENTKEY
                 JOIN LST.LIST_QM_MAPPING LQM ON LQM.QM = QM.[QMMSRID]
                                                
                 LEFT JOIN [ACECAREDW].[DBO].[UHC_MEMBERSBYPCP] MP  ON QM.CLIENTMEMBERKEY = MP.UHC_SUBSCRIBER_ID
                            AND YEAR(QM.[QMDATE]) = YEAR(MP.[A_LAST_UPDATE_DATE])
                            AND MONTH(QM.[QMDATE]) = MONTH(MP.[A_LAST_UPDATE_DATE])
                            AND LOADTYPE <> 'S'
                 LEFT JOIN LST.LSTPLANMAPPING ACEMAP_PLAN ON MP.SUBGRP_ID = ACEMAP_PLAN.SOURCEVALUE
                            AND ACEMAP_PLAN.TARGETSYSTEM = 'ACDW'
                            AND ACEMAP_PLAN.CLIENTKEY = 1
                 LEFT JOIN LST.LSTPLANMAPPING ACEMAP_CSPLAN ON MP.SUBGRP_ID = ACEMAP_CSPLAN.SOURCEVALUE
                                                                                   AND ACEMAP_CSPLAN.TARGETSYSTEM = 'CS_AHS'
                                                                                   AND ACEMAP_CSPLAN.CLIENTKEY = 1
                 LEFT JOIN [ACECAREDW].[LST].[LSTCAREOPTOPLAN] CP ON QM.[QMMSRID] = CP.[MEASUREID]
                                                                     AND CP.CSPLAN = ACEMAP_CSPLAN.TARGETVALUE
                                                                                AND QM.QMDATE BETWEEN CP.EFFECTIVEDATE AND CP.EXPIRATIONDATE
                -- LEFT JOIN [ACECAREDW].[LST].[LSTSCORINGSYSTEM] SCOR ON SCOR.MEASUREID = QM.[QMMSRID]
                --                                                        AND SCOR.CLIENTKEY = '1'
                --                                                        AND YEAR(SCOR.EXPIRATIONDATE) = YEAR(QM.QMDATE)
                 LEFT JOIN ACECAREDW.LST.LIST_CLIENT LC ON LC.CLIENTKEY = QM.CLIENTKEY
                                                -- JOIN TO PROVIDERROSTER TO CLEAN UHC TIN NAME, FOR THE SHCN PERMIAN TIN, USE NPI TO GET GROUP NAME , ALL OTHERS JUSTNPI
                                                  LEFT JOIN (SELECT PR.TIN, PR.GROUPNAME , PR.ACCOUNTTYPE
                                                                                                  FROM DBO.VW_ALLCLIENT_PROVIDERROSTER PR 
                                                                                                  WHERE PR.CALCCLIENTKEY = 1 --AND PR.TIN <> '134334288'                                                                                                                       
                                                                                                  GROUP BY PR.TIN, PR.GROUPNAME, PR.ACCOUNTTYPE) PR
                                                                ON MP.PCP_PRACTICE_TIN            = PR.TIN
                                                LEFT JOIN (SELECT PR.TIN, PR.GROUPNAME, PR.NPI, PR.ACCOUNTTYPE
                                                                                                  FROM DBO.VW_ALLCLIENT_PROVIDERROSTER PR 
                                                                                                  WHERE PR.CALCCLIENTKEY = 1 AND PR.TIN = '134334288'
                                                                                                  GROUP BY PR.TIN, PR.GROUPNAME, PR.NPI, PR.ACCOUNTTYPE) PR_SHCN
                                                                ON MP.PCP_PRACTICE_TIN            = PR_SHCN.TIN 
                                                                    AND MP.PCP_NPI = PR_SHCN.NPI
                                                                    
            --  8/18/2020:GK REMOVED AS ZONES ARE NOT USED IN DASHBOARD              
            --   LEFT JOIN [ACECAREDW_TEST].DBO.[TMP_ZIPCODE_ZONES] TZIP ON TZIP.ZIPCODES = MP.MEMBER_HOME_ZIP
            WHERE QM.CLIENTKEY = 1
                  AND LQM.ACTIVE = 'Y'                                
                                                                  AND  NOT QM.QmMsrId IN ('UHC_FUH_30_0617','UHC_FUH_30_1864','UHC_FUH_7_0617','UHC_FUH_7_1864', 'UHC_URI') -- explicitly suppressed from Provider Gap Report 
                                ) A
                                
                   LEFT JOIN [ACECAREDW].[LST].[LSTSCORINGSYSTEM] SCOR ON SCOR.MEASUREID = A.[QMMSRID]
                                                                        AND SCOR.CLIENTKEY = '1'
                                                                        AND YEAR(SCOR.EXPIRATIONDATE) = YEAR(A.QMDATE)
                                                                                                                                                                                                                                  AND SCOR.LOB = A.LOB
    ) S    
                GROUP BY S.CLIENTMEMBERKEY, S.CAREOPTOPLAN_ACTIVE, S.QMMSR_TB_DESC, S.AHR_QM_DESC, S.QMMSRID, S.QMDATE, 
           S.LOB, S.MEASUREDESC,  S.AGE, S.PCP_PRACTICE_TIN, S.PCP_PRACTICE_NAME, S.PCP_NPI, S.PCP_PHONE, S.CAREOPTOPLAN_MEASUREID, S.[CONTRACT?], 
           S.[ACE MBR?]
                                , S.EXPIRATIONYEAR, S.TARGET
                                , S.CLIENT, S.PROVIDERNAME, S.PROVIDERACCOUNTTYPE
                                , S.IsMbrActive, S.TinInContractWithAce
                ;

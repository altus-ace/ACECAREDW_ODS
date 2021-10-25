CREATE VIEW [zz_vw_AH_UHC_careopps_PH_01]
 as 


        SELECT DISTINCT
	   'UHC' AS CLIENT_ID,
           C.MEMBERID AS MEMBER_ID
            , case when s.Destination_program_name = ' ' then 'C-Well Child visit first 15 months' else 
		  LTRIM(RTRIM(s.Destination_program_name))
              end  AS OPPURTUNITY
			,' ' as MEASURE_CODE
,' ' as MEASURE_CATEGORY
          ,1 as 'STATUS' /* ACTIVE /INACTIVE*/
,c.a_last_update_date as DATE_IDENTIFIED
 ,2018 as MEASURE_VERSION
        FROM uhc_careopps c
             INNER JOIN
        (
            SELECT
                   *
            FROM ACE_MAP_CAREOPPS_PROGRAMS where DESTINATION_PROGRAM_NAME not in ('High-Well Child visit 3rd-6th years','High-Adolescent Well Care visits'
		  ,'Med-Well Child visit 3rd-6th years','Med-Adolescent Well Care visits')
            --WHERE is_active=1
        ) AS s ON s.SOURCE_MEASURE_NAME = c.Measure_Desc
                  AND c.Sub_Meas = s.SOURCE_SUB_MEASURE_NAME
                  AND s.SOURCE = 'UHC'
                  AND S.DESTINATION = 'ALTRUISTA'
		  INNER JOIN vw_UHC_ActiveMembers am ON c.MemberID = am.UHC_SUBSCRIBER_ID
        WHERE C.A_last_update_FLAG = 'Y'
 
    --WHERE ss.Program_name IS not NULL
 
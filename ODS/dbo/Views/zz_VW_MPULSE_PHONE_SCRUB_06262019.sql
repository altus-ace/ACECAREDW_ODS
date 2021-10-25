--drop VIEW [dbo].[VW_MPULSE_PHONE_SCRUB]
CREATE VIEW [dbo].[zz_VW_MPULSE_PHONE_SCRUB_06262019]
AS
     SELECT A.M_Registration_ID AS CLIENT_PATIENT_ID,
            A.latest_mobile_phone AS MOBILE_PHONE,
            B.A_MSTR_MRN AS ACE_ID,
            C.FIRST_NAME,
            C.LAST_NAME,
            C.CLIENT_ID
     FROM
(
    SELECT m_registration_id, --date, 
           MEMBER_MAIL_PHONE AS latest_mobile_phone
    FROM
(
    SELECT DISTINCT
           m_registration_id,
           CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) AS date,
           MEMBER_MAIL_PHONE,
           DENSE_RANK() OVER(PARTITION BY m_registration_id ORDER BY CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) DESC) AS rank
    FROM [ACECAREDW].[dbo].[vw_membership_all]
) A
    WHERE A.rank = 1
          AND A.MEMBER_MAIL_PHONE <> ''
    UNION
    SELECT [MEMBER_ID],
           [MEMBER_CELL_PHONE] AS latest_mobile_phone
    FROM [Ahs_Altus_Prod].[dbo].[ACE_VW_RP_Preferred_WelcomeLetter]
    WHERE member_cell_phone IS NOT NULL
          AND member_cell_phone <> ''
    UNION
    SELECT m_registration_id, --date, 
           MEMBER_BUS_PHONE AS latest_mobile_phone
    FROM
(
    SELECT DISTINCT
           m_registration_id,
           CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) AS date,
           MEMBER_BUS_PHONE,
           DENSE_RANK() OVER(PARTITION BY m_registration_id ORDER BY CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) DESC) AS rank
    FROM [ACECAREDW].[dbo].[vw_membership_all]
) A
    WHERE A.rank = 1
          AND A.MEMBER_BUS_PHONE <> ''
    UNION
    SELECT m_registration_id, --date, 
           MEMBER_HOME_PHONE AS latest_mobile_phone
    FROM
(
    SELECT DISTINCT
           m_registration_id,
           CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) AS date,
           MEMBER_HOME_PHONE,
           DENSE_RANK() OVER(PARTITION BY m_registration_id ORDER BY CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) DESC) AS rank
    FROM [ACECAREDW].[dbo].[vw_membership_all]
) A
    WHERE A.rank = 1
          AND A.MEMBER_HOME_PHONE <> ''
) A
JOIN
(
    SELECT [A_MSTR_MRN],
           [Client_Member_ID]
    FROM [ACECAREDW].[adw].[A_Mbr_Members] M
    WHERE m.Active = 1
) B ON A.M_Registration_ID = B.Client_Member_ID
JOIN
(
    SELECT m_registration_id, --date, 
           M_First_Name AS FIRST_NAME,
           M_Last_Name AS LAST_NAME,
           CLIENT_ID
    FROM
(
    SELECT DISTINCT
           m_registration_id,
           CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) AS date,
           M_First_Name,
           M_Last_Name,
           CLIENT_ID,
           PCP_PRACTICE_TIN,
           DENSE_RANK() OVER(PARTITION BY m_registration_id ORDER BY CAST(STR([MBR_YEAR])+'-'+STR([MBR_MTH])+'-01' AS DATE) DESC) AS rank
    FROM [ACECAREDW].[dbo].[vw_membership_all_for_INF]
) A
    WHERE A.rank = 1
) C ON C.M_Registration_ID = A.M_Registration_ID
     WHERE LEN(A.latest_mobile_phone) = 10;

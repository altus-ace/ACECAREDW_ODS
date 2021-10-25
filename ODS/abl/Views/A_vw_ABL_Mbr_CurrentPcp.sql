CREATE VIEW abl.A_vw_ABL_Mbr_CurrentPcp
AS
     SELECT
            c.Client_ShortName AS CLIENT_ID
          , m.UHC_SUBSCRIBER_ID AS CLIENT_MEMBER_ID
          , PCP_NPI AS PCP_NPI
          , PCP_Last_Name AS PCP_LastName
          , PCP_First_name AS PCP_FirstName
          , PCP_PRACTICE_TIN AS PCP_TIN
          , PCP_PRACTICE_NAME AS PCP_PracticeName
     FROM
     (
         SELECT
                *
         FROM
         (
             SELECT
                    m.urn
                  , m.UHC_SUBSCRIBER_ID
                  , m.A_LAST_UPDATE_DATE
                  , ROW_NUMBER() OVER(PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.A_LAST_UPDATE_DATE DESC) aRN
             FROM [dbo].[uhc_membersByPcp] m
         ) AS src
         WHERE src.aRN = 1
     ) AS AllMembers
     JOIN UHC_MembersByPCP m ON AllMembers.urn = m.URN
     JOIN [adw].[A_LIST_Clients] c ON 1 = c.A_Client_ID;
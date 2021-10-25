
CREATE VIEW dbo.vw_UHC_Mbr_LastPcpInfo 
AS 
SELECT *
FROM (
    SELECT [URN]
          ,[UHC_SUBSCRIBER_ID]
          ,[PCP_FIRST_NAME]
          ,[PCP_LAST_NAME]
          ,[PCP_NPI]
          ,[PCP_PHONE]
          ,[PCP_FAX]
          ,[PCP_ADDRESS]
          ,[PCP_ADDRESS2]
          ,[PCP_CITY]
          ,[PCP_STATE]
          ,[PCP_ZIP]
          ,[PCP_COUNTY]
          ,[A_LAST_UPDATE_DATE]
          ,[A_LAST_UPDATE_BY]
          ,[A_LAST_UPDATE_FLAG]
          ,[MEMBER_STATUS]
          ,[MEMBER_TERM_DATE]
    	 , ROW_NUMBER() OVER (PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY A_LAST_UPDATE_DATE DESC ) AS aRN
      FROM [dbo].[UHC_MembersByPCP] m
	 ) as src
WHERE src.aRN = 1





--DROP VIEW [adw].[A_vw_MSTR_MPI_PatientInfo]

CREATE VIEW [adw].[A_vw_MSTR_MPI_PatientInfo]
AS
     SELECT
            mrn.[A_MSTR_MRN]
          , mpi.First_Name AS MEMBER_FIRST_NAME
          , mpi.Last_Name AS MEMBER_LAST_NAME
          , mpi.Middle_Initial AS MEMBER_MI
          , mpi.Date_Of_Birth AS DATE_OF_BIRTH
          , mpi.Gender AS GENDER
          , mpi.Medicaid_ID AS MEDICAID_ID
          , mpi.Medicare_ID AS MEDICARE_ID
          , Mem.MEMBER_HOME_ADDRESS AS MEMBER_HOME_ADDRESS
          , Mem.MEMBER_HOME_ADDRESS2 AS MEMBER_HOME_ADDRESS2
          , Mem.MEMBER_HOME_CITY AS MEMBER_HOME_CITY
          , Mem.MEMBER_HOME_STATE AS MEMBER_HOME_STATE
          , substring(Mem.MEMBER_HOME_ZIP,0,6) AS MEMBER_HOME_ZIP
		, CASE WHEN (len(Mem.Member_Home_Zip)> 5 )
			 THEN SUBSTRING(Mem.MEMBER_HOME_ZIP, 6, len(Mem.MEMBER_HOME_ZIP)) 
			 ELSE '' 
			 END  AS MEMBER_HOME_ZIP_PLUS_4
		, mem.Member_Home_Phone
		, mem.Member_Business_Phone
		, mem.Member_Alt_Phone_1
		, mem.Member_Alt_Phone_2
          , Mem.Client_Member_ID
          , Mem.A_Client_ID
     FROM
     (
         SELECT
                MRN.[A_MSTR_MRN] AS [A_MSTR_MRN]
              , MRN.Client_Member_ID
         FROM adw.A_Mbr_Members MRN
		 WHERE mrn.Active = 1
     ) mrn
     JOIN
     (
         SELECT
                mems.UHC_SUBSCRIBER_ID AS Client_Member_ID
              , mems.MEMBER_FIRST_NAME
              , mems.MEMBER_LAST_NAME
              , mems.MEMBER_MI
              , mems.DATE_OF_BIRTH
              , mems.GENDER
              , mems.MEDICAID_ID
              , mems.MEDICARE_ID
              , mems.MEMBER_HOME_ADDRESS
              , mems.MEMBER_HOME_ADDRESS2
              , mems.MEMBER_HOME_CITY
              , mems.MEMBER_HOME_STATE
              , mems.MEMBER_HOME_ZIP
		    , mems.Member_Home_Phone
		    , mems.Member_Business_Phone
		    , mems.Member_Alt_Phone_1
		    , mems.Member_Alt_Phone_2
              , 1 AS A_Client_ID
         FROM
         (
             SELECT
                    RTRIM(m.UHC_SUBSCRIBER_ID) UHC_SUBSCRIBER_ID
                  , RTRIM(m.MEMBER_LAST_NAME) MEMBER_LAST_NAME
                  , RTRIM(m.MEMBER_FIRST_NAME) MEMBER_FIRST_NAME
                  , RTRIM(m.MEMBER_MI) MEMBER_MI
                  , m.DATE_OF_BIRTH
                  , RTRIM(m.GENDER) GENDER
                  , RTRIM(m.MEDICAID_ID) MEDICAID_ID
                  , RTRIM(m.MEDICARE_ID) MEDICARE_ID
                  , RTRIM(m.MEMBER_HOME_ADDRESS) MEMBER_HOME_ADDRESS
                  , RTRIM(m.MEMBER_HOME_ADDRESS2) MEMBER_HOME_ADDRESS2
                  , RTRIM(m.MEMBER_HOME_CITY) MEMBER_HOME_CITY
                  , RTRIM(m.MEMBER_HOME_STATE) MEMBER_HOME_STATE
                  , RTRIM(m.MEMBER_HOME_ZIP) MEMBER_HOME_ZIP
			   , RTRIM(LTRIM(m.MEMBER_HOME_PHONE))	 Member_Home_Phone
			   , RTRIM(LTRIM(m.MEMBER_BUS_PHONE))	 Member_Business_Phone
			   , RTRIM(LTRIM(m.MEMBER_MAIL_PHONE))	 Member_Alt_Phone_1
			   , RTRIM(LTRIM(m.RESP_PHONE))		 Member_Alt_Phone_2
                  , ROW_NUMBER() OVER(PARTITION BY m.UHC_SUBSCRIBER_ID ORDER BY m.A_LAST_UPDATE_DATE DESC) aRN			   
             FROM dbo.UHC_MembersByPCP m
         ) mems
         WHERE mems.aRN = 1	    
     ) Mem ON MRN.Client_Member_ID = Mem.Client_Member_ID
     JOIN adw.A_MSTR_MPI mpi ON mrn.A_MSTR_MRN = mpi.A_MSTR_MRN
	WHERE mpi.ACTIVE = 1;

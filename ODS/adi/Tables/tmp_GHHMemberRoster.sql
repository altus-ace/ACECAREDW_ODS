CREATE TABLE [adi].[tmp_GHHMemberRoster] (
    [AceID]                VARCHAR (41)  NULL,
    [LAST_NAME]            VARCHAR (255) NULL,
    [FIRST_NAME]           VARCHAR (255) NULL,
    [MIDDLE_NAME]          VARCHAR (255) NULL,
    [GENDER]               VARCHAR (1)   NOT NULL,
    [DATE_OF_BIRTH]        VARCHAR (8)   NULL,
    [SSN]                  VARCHAR (1)   NOT NULL,
    [MEMBER_HOME_ADDRESS]  VARCHAR (255) NULL,
    [MEMBER_HOME_ADDRESS2] VARCHAR (255) NULL,
    [MEMBER_HOME_CITY]     VARCHAR (255) NULL,
    [MEMBER_HOME_STATE]    VARCHAR (2)   NULL,
    [MEMBER_HOME_ZIP]      VARCHAR (20)  NOT NULL,
    [Member_Home_Phone]    VARCHAR (25)  NOT NULL,
    [MinEligDate]          VARCHAR (8)   NULL,
    [MinExpDate]           VARCHAR (8)   NULL,
    [ClientMemberKey]      VARCHAR (255) NULL,
    [clientKey]            INT           NOT NULL
);


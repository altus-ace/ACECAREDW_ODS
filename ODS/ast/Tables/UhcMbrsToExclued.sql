CREATE TABLE [ast].[UhcMbrsToExclued] (
    [MEMBER_ID]                   [adw].[Client_Member_Identifier] NOT NULL,
    [LOB]                         VARCHAR (50)                     NULL,
    [BENEFIT PLAN]                VARCHAR (150)                    NOT NULL,
    [INTERNAL/EXTERNAL INDICATOR] VARCHAR (1)                      NOT NULL,
    [START_DATE]                  VARCHAR (10)                     NULL,
    [END_DATE]                    VARCHAR (10)                     NULL
);


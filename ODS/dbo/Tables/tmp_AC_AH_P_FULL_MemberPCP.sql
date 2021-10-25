CREATE TABLE [dbo].[tmp_AC_AH_P_FULL_MemberPCP] (
    [Key]                                 INT           IDENTITY (1, 1) NOT NULL,
    [MEMBER_ID]                           VARCHAR (50)  NULL,
    [MEMBER_PCP]                          VARCHAR (50)  NULL,
    [PROVIDER_RELATIONSHIP_TYPE]          VARCHAR (50)  NULL,
    [LOB]                                 VARCHAR (50)  NULL,
    [PCP_EFFECTIVE_DATE]                  DATE          NULL,
    [PCP_TERM_DATE]                       DATE          NULL,
    [MEMBER_PCP_ADDITIONAL_INFORMATION_1] VARCHAR (50)  NULL,
    [LoadDate]                            DATETIME      NULL,
    [SrcFileName]                         VARCHAR (100) NULL
);


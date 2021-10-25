CREATE TABLE [ast].[Mbr_ClientRiskScores] (
    [ClientKey]       INT           NOT NULL,
    [ClientMemberKey] VARCHAR (50)  NOT NULL,
    [Ace_ID]          NUMERIC (15)  NOT NULL,
    [PlanName]        VARCHAR (50)  NULL,
    [LOB]             VARCHAR (20)  NULL,
    [Contract]        VARCHAR (20)  NULL,
    [ClientRiskScore] VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ClientKey] ASC, [ClientMemberKey] ASC, [Ace_ID] ASC)
);


CREATE TABLE [adw].[QM_ResultByMember_History] (
    [QM_ResultByMbr_HistoryKey] INT           IDENTITY (1, 1) NOT NULL,
    [ClientKey]                 INT           NOT NULL,
    [ClientMemberKey]           VARCHAR (50)  NOT NULL,
    [QmMsrId]                   VARCHAR (100) NULL,
    [QmCntCat]                  VARCHAR (10)  NOT NULL,
    [QMDate]                    DATE          CONSTRAINT [DF_QM_ResultByMbr_History_QmDate] DEFAULT (CONVERT([date],getdate())) NULL,
    [CreateDate]                DATETIME      CONSTRAINT [DF_QM_ResultByMbr_History_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreateBy]                  VARCHAR (50)  CONSTRAINT [DF_QM_ResultByMbr_History_CreateBy] DEFAULT (suser_sname()) NOT NULL,
    [LastUpdatedDate]           DATETIME      CONSTRAINT [df_AdwQM_ResultByMember_History_LastUpdatedDate] DEFAULT (getdate()) NOT NULL,
    [LastUpdatedBy]             VARCHAR (50)  CONSTRAINT [df_AdwQM_ResultByMember_History_LastUpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [AdiKey]                    INT           NULL,
    [adiTableName]              VARCHAR (100) NULL,
    [Addressed]                 INT           NULL,
    PRIMARY KEY CLUSTERED ([QM_ResultByMbr_HistoryKey] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ndx_AdwQMResultByMember_History_QmCntCatQmMsrIdQmDate]
    ON [adw].[QM_ResultByMember_History]([QmCntCat] ASC, [QmMsrId] ASC, [QMDate] ASC)
    INCLUDE([ClientKey], [ClientMemberKey], [CreateDate]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QM_ResultByMember_History_6_1202155378__K4_K5_K2_K6_K3_7]
    ON [adw].[QM_ResultByMember_History]([QmMsrId] ASC, [QmCntCat] ASC, [ClientKey] ASC, [QMDate] ASC, [ClientMemberKey] ASC)
    INCLUDE([CreateDate]);


GO
CREATE NONCLUSTERED INDEX [ndx_AdwQmResultByMember_ClientKey]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey] ASC)
    INCLUDE([ClientKey], [QmMsrId], [QmCntCat], [QMDate]);


GO
CREATE NONCLUSTERED INDEX [ndx_AdwQmResultByMember_ClientKeyClientMemberKeyQmMsrIdQmDate]
    ON [adw].[QM_ResultByMember_History]([ClientKey] ASC, [ClientMemberKey] ASC, [QmMsrId] ASC, [QMDate] ASC)
    INCLUDE([QM_ResultByMbr_HistoryKey]);


GO
CREATE NONCLUSTERED INDEX [ndx_QmResByMemberHist_ClientKey]
    ON [adw].[QM_ResultByMember_History]([ClientKey] ASC)
    INCLUDE([ClientMemberKey], [QmMsrId], [QmCntCat], [QMDate]);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QM_ResultByMember_History_6_1202155378__K2_K6]
    ON [adw].[QM_ResultByMember_History]([ClientKey] ASC, [QMDate] ASC);


GO
CREATE NONCLUSTERED INDEX [_dta_index_QM_ResultByMember_History_6_1202155378__K6_K2_K4_K3_1_5]
    ON [adw].[QM_ResultByMember_History]([QMDate] ASC, [ClientKey] ASC, [QmMsrId] ASC, [ClientMemberKey] ASC)
    INCLUDE([QM_ResultByMbr_HistoryKey], [QmCntCat]);


GO
CREATE STATISTICS [_dta_stat_1202155378_5_2]
    ON [adw].[QM_ResultByMember_History]([QmCntCat], [ClientKey]);


GO
CREATE STATISTICS [_dta_stat_1202155378_2_4]
    ON [adw].[QM_ResultByMember_History]([ClientKey], [QmMsrId]);


GO
CREATE STATISTICS [_dta_stat_1202155378_3_4_5]
    ON [adw].[QM_ResultByMember_History]([ClientMemberKey], [QmMsrId], [QmCntCat]);


GO
CREATE STATISTICS [_dta_stat_1202155378_2_3_6_5]
    ON [adw].[QM_ResultByMember_History]([ClientKey], [ClientMemberKey], [QMDate], [QmCntCat]);


GO
CREATE STATISTICS [_dta_stat_1202155378_4_6_2]
    ON [adw].[QM_ResultByMember_History]([QmMsrId], [QMDate], [ClientKey]);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Skey', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QM_ResultByMbr_HistoryKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK: Client', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'ClientKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Client Member Key', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'ClientMemberKey';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID of Care OP/Measure', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QmMsrId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DEN: In Denom, Num: in Numerator, COP: is care op', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QmCntCat';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Date QM Is effective for', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'QMDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Adi Source Row Primary Key value', @level0type = N'SCHEMA', @level0name = N'adw', @level1type = N'TABLE', @level1name = N'QM_ResultByMember_History', @level2type = N'COLUMN', @level2name = N'AdiKey';


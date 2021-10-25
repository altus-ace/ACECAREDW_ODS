CREATE TABLE [dbo].[z_tmp_ChurnMembers] (
    [URN]             INT          IDENTITY (1, 1) NOT NULL,
    [ChurnDate]       VARCHAR (10) NULL,
    [ClientMemberKey] VARCHAR (50) NULL,
    [CreateDate]      DATETIME     DEFAULT (getdate()) NULL,
    [CreateBy]        VARCHAR (50) DEFAULT (suser_sname()) NULL
);


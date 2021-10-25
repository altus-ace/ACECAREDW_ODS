CREATE TABLE [dbo].[LIST_ZIPCODES] (
    [ZipCode]  VARCHAR (15) NOT NULL,
    [Quadrant] VARCHAR (50) NULL,
    [Pod]      VARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ZipCode] ASC)
);


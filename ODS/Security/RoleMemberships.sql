ALTER ROLE [db_owner] ADD MEMBER [altus_sa];


GO
ALTER ROLE [db_owner] ADD MEMBER [cmuser];


GO
ALTER ROLE [db_owner] ADD MEMBER [ALTUSACE\rhe];


GO
ALTER ROLE [db_owner] ADD MEMBER [ALTUSACE\byu];


GO
ALTER ROLE [db_securityadmin] ADD MEMBER [altus_sa];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ALTUSACE\ITS-DB-BA];


GO
ALTER ROLE [db_datareader] ADD MEMBER [tdmReader];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ACDW_ETL_Reader];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ALTUSACE\ACE-CMDATA-READ];


GO
ALTER ROLE [db_datareader] ADD MEMBER [SqlServerAgent];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ALTUSACE\ACE-DWDATA-READ];


GO
ALTER ROLE [db_datareader] ADD MEMBER [ALTUSACE\etl-admin];


GO
ALTER ROLE [db_datareader] ADD MEMBER [tb_AppUser01];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [ACDW_ETL_Writer];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [SqlServerAgent];


GO
ALTER ROLE [db_datawriter] ADD MEMBER [ALTUSACE\etl-admin];


GO
ALTER ROLE [db_denydatareader] ADD MEMBER [ALTUSACE\ITS-EXCLUDE-DB];


GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [ALTUSACE\ACE-CMDATA-READ];


GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [tb_AppUser01];


GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [ALTUSACE\ITS-EXCLUDE-DB];


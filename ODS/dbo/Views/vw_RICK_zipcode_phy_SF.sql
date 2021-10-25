create view [vw_RICK_zipcode_phy_SF]
AS
select distinct substring(Zip,1,5) as Name from RiCK_physician_Roster
except 
select distinct name from tmpsalesforce_zip_code__C

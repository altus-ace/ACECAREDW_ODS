create view vw_ACE_PROV_MAP_PCP_SPEC
as
select distinct npi, case when specialty_type in ('PCP') then 'PCP' else 'SPECIALIST' end as prov_type,  case when [primary zipcode] is null or  [primary zipcode] = '' then b.zip else  [primary zipcode] end as ZIPCODE
  from acecaredw.[dbo].[vw_Feeder_AllClient_ProviderRoster] a
  left join (SELECT ["NPI"] as NPI_NPPES
   
      ,left(["Provider Business Practice Location Address Postal Code"],5) as ZIP

  FROM [ACECAREDW_TEST].[dbo].[NPI_NPPES]) b on a.npi = b.npi_nppes where specialty_type not in ('FQHC')

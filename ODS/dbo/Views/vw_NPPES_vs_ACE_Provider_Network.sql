
CREATE VIEW [dbo].[vw_NPPES_vs_ACE_Provider_Network]
AS
/* data is upto date for April 2019 from CMS NPI Registry
This view overlaps NPI Zip codes from NPi registry and ACE provider Roster */




SELECT DISTINCT 
       a.NPI, 
       CASE WHEN a.NPI = b.NPI THEN ''
	        ELSE LEFT([Provider Business Practice Location Address Postal Code], 5) END as NPPES_NPI_ZIP, 
       [Provider Organization Name (Legal Business Name)], 
       [Is Sole Proprietor]
	   , case when a.NPI = b.NPI then 'Y' else 'N' end as ACE_provider
	   ,b.[PRIMARY ZIPCODE]
	   ,a.[Healthcare Provider Taxonomy Code_1]
FROM DEV_ACECAREDW.[dbo].[tmp_NPPES_April2019] a
LEFT JOIN ACECAREDW.[dbo].[vw_NetworkRosterN] b on b.NPI = a.NPI 
WHERE [NPI Deactivation Date] IS NOT NULL
--and A.NPI = '1003971755'
  --    AND LTRIM(RTRIM([Is Sole Proprietor])) = 'Y'
      AND LTRIM(RTRIM(LEFT([Provider Business Practice Location Address Postal Code], 2))) = '77'
;

